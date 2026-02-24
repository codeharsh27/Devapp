import httpx
import logging
import re
from datetime import datetime, timedelta, timezone
from sqlalchemy.future import select
from sqlalchemy import delete
from ..models import Drop, DifficultyLevel
from app.core.database import AsyncSessionLocal

logger = logging.getLogger(__name__)

GITHUB_SEARCH_URL = "https://api.github.com/search/issues"

DOMAIN_MAP = {
    "javascript": "frontend",
    "typescript": "frontend",
    "react": "frontend",
    "vue": "frontend",
    "flutter": "mobile",
    "dart": "mobile",
    "android": "mobile",
    "kotlin": "mobile",
    "ios": "mobile",
    "swift": "mobile",
    "python": "backend",
    "java": "backend",
    "go": "backend",
    "rust": "backend",
    "cpp": "backend",
    "c++": "backend",
    "c": "backend",
    "machine learning": "ai",
    "ai": "ai",
}

SKIP_KEYWORDS = ["readme", "typo", "translation", "docs", "documentation"]


async def sync_github_drops():
    """
    Fetches 'good first issues' from GitHub and adds them as Source B drops.
    Also cleans up old Source B drops (older than 7 days) to keep the list fresh.
    """
    base_query = (
        'is:issue is:open label:"good first issue" no:assignee stars:>1000 '
        "-docs -documentation -readme -translation -typo -localization"
    )
    queries = [
        f"{base_query} language:python",
        f"{base_query} language:javascript",
        f"{base_query} language:typescript",
        f"{base_query} language:java",
        f"{base_query} language:cpp",
        f"{base_query} language:go",
        f"{base_query} language:kotlin",
        f"{base_query} language:swift",
        f"{base_query} language:rust",
        f"{base_query} language:dart",
    ]

    all_items: list = []
    headers = {"Accept": "application/vnd.github.v3+json"}

    # ── 1. Fetch from GitHub ─────────────────────────────────────────────────
    async with httpx.AsyncClient(timeout=15.0) as client:
        for q in queries:
            params = {"q": q, "sort": "created", "order": "desc", "per_page": 10}
            try:
                response = await client.get(GITHUB_SEARCH_URL, params=params, headers=headers)
                response.raise_for_status()
                all_items.extend(response.json().get("items", []))
            except Exception as req_err:
                logger.warning(f"GitHub fetch failed for query '{q}': {req_err}")

    if not all_items:
        logger.info("GitHub Sync: No issues fetched.")
        return

    # Deduplicate by URL (an issue may match multiple language queries)
    unique_items = list({item["html_url"]: item for item in all_items}.values())

    # ── 2. Persist to DB ─────────────────────────────────────────────────────
    async with AsyncSessionLocal() as db:
        try:
            count_added = 0

            for item in unique_items:
                source_url = item.get("html_url")
                if not source_url:
                    continue

                title = item.get("title", "Untitled Task")

                # Post-fetch filter: skip non-code issues
                if any(kw in title.lower() for kw in SKIP_KEYWORDS):
                    continue

                # Check if we already have this issue
                existing_res = await db.execute(
                    select(Drop).filter(Drop.source_url == source_url)
                )
                if existing_res.scalars().first():
                    continue

                # Infer domain from GitHub labels
                labels = [lbl["name"].lower() for lbl in item.get("labels", [])]
                domain = "backend"
                for label in labels:
                    if label in DOMAIN_MAP:
                        domain = DOMAIN_MAP[label]
                        break

                # Clean body
                body = item.get("body") or "No description provided."
                body = re.sub(r"<!--.*?-->", "", body, flags=re.DOTALL).strip()
                body += f"\n\n**Source:** [{source_url}]({source_url})"

                if len(body) < 50:
                    continue

                new_drop = Drop(
                    title=title,
                    description=body,
                    domain=domain,
                    difficulty=DifficultyLevel.EASY,
                    time_limit_minutes=120,
                    reward_xp=50,
                    source_url=source_url,
                    source_type="B",
                    submission_type="code",
                )
                db.add(new_drop)
                count_added += 1

            # ── 3. Remove stale Source B drops (older than 7 days) ─────────
            expiration_date = datetime.now(timezone.utc) - timedelta(days=7)
            await db.execute(
                delete(Drop).where(
                    Drop.source_type == "B",
                    Drop.created_at < expiration_date,
                )
            )

            await db.commit()
            logger.info(f"GitHub Sync complete: added {count_added} new drops.")

        except Exception as e:
            logger.error(f"GitHub Sync failed: {e}")
            await db.rollback()
