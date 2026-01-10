
import httpx
import logging
from sqlalchemy.orm import Session
from ..models import Drop, DifficultyLevel
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

GITHUB_SEARCH_URL = "https://api.github.com/search/issues"

from ..database import SessionLocal

async def sync_github_drops():
    """
    Fetches 'good first issues' from GitHub and adds them as Source B drops.
    Also cleans up old Source B drops to keep the list fresh.
    """
    db = SessionLocal()

    try:
        # 1. Fetch "Good First Issues" from High Quality Repos
        # Filter out non-code tasks like docs, translations, typos
        # We increase star count to 1000 for better quality
        base_query = 'is:issue is:open label:"good first issue" no:assignee stars:>1000 -docs -documentation -readme -translation -typo -localization'
        
        queries = [
            f'{base_query} language:python',
            f'{base_query} language:javascript',
            f'{base_query} language:typescript',
            f'{base_query} language:java',       # Industry standard
            f'{base_query} language:cpp',        # C++
            f'{base_query} language:c',          # C
            f'{base_query} language:go',         # Cloud/Backend
            f'{base_query} language:kotlin',     # Android
            f'{base_query} language:swift',      # iOS
            f'{base_query} language:rust',
            f'{base_query} language:dart',
        ]
        
        all_items = []
        
        headers = {
            "Accept": "application/vnd.github.v3+json"
        }

        async with httpx.AsyncClient() as client:
            for q in queries:
                params = {
                    "q": q,
                    "sort": "created",
                    "order": "desc",
                    "per_page": 10 # 10 per language = 50 total mixed
                }
                
                try:
                    response = await client.get(GITHUB_SEARCH_URL, params=params, headers=headers)
                    response.raise_for_status()
                    data = response.json()
                    items = data.get("items", [])
                    all_items.extend(items)
                except Exception as req_err:
                    logger.warning(f"Failed to fetch for query '{q}': {req_err}")
                    continue

        if not all_items:
            logger.info("No GitHub issues found.")
            return

        # Deduplicate by ID or URL (since an issue might match multiple queries)
        unique_items = {item['html_url']: item for item in all_items}.values()
        
        items = list(unique_items)

        # 2. Add/Update Drops in DB
        # We use source_url as the unique key for Source B drops
        
        count_added = 0
        
        for item in items:
            source_url = item.get("html_url")
            if not source_url:
                continue

            # Check if exists
            existing = db.query(Drop).filter(Drop.source_url == source_url).first()
            if existing:
                continue # Already have it

            # Create new Drop
            # Infer domain from labels/language
            labels = [l["name"].lower() for l in item.get("labels", [])]
            
            # Extract content
            title = item.get("title", "Untitled Task")
            
            # --- FILTERING LOGIC (Post-Fetch) ---
            # Double check to exclude readme/docs updates that might have slipped through
            title_lower = title.lower()
            if any(x in title_lower for x in ['readme', 'typo', 'translation', 'docs', 'documentation']):
                continue

            body = item.get("body") or "No description provided."
            
            # --- DOMAIN MAPPING UPDATE ---
            domain_map = {
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
                "ai": "ai"
            }
            
            # Default to Backend if unknown, or guess based on title
            domain = "backend" 
            
            # Check labels first
            for label in labels:
                if label in domain_map:
                    domain = domain_map[label]
                    break
            body = item.get("body") or "No description provided."
            
            # --- CLEANING LOGIC ---
            # 1. Remove HTML comments <!-- ... -->
            import re
            body = re.sub(r'<!--.*?-->', '', body, flags=re.DOTALL)
            
            # 2. Append Explicit Link if requested
            body += f"\n\n**Source:** [{source_url}]({source_url})"

            # Skip very short descriptions which are usually junk
            if len(body) < 50:
                continue

            new_drop = Drop(
                title=title,
                description=body,
                domain=domain,
                difficulty=DifficultyLevel.EASY,
                time_limit_minutes=120, # 2 Hours for a standard issue
                reward_xp=50,
                source_url=source_url,
                source_type="B",
                submission_type="code" # Explicitly mark as code task
            )
            db.add(new_drop)
            count_added += 1

        # 3. Cleanup Old Source B Drops
        # Remove drops older than 7 days to ensure freshness, OR logic:
        # If we have more than 50 Source B drops, delete the oldest ones?
        # Let's go with Time-based expiry for freshness as requested.
        
        expiration_date = datetime.utcnow() - timedelta(days=7)
        old_drops = db.query(Drop).filter(
            Drop.source_type == "B",
            Drop.created_at < expiration_date
        ).delete(synchronize_session=False)

        db.commit()
        
        logger.info(f"GitHub Sync: Added {count_added} drafts, Removed {old_drops} expired.")
        
    except Exception as e:
        logger.error(f"Error syncing GitHub drops: {e}")
        db.rollback()
    finally:
        db.close()
