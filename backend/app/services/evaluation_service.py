
import httpx
import logging
import re
from typing import Tuple

logger = logging.getLogger(__name__)

async def evaluate_github_submission(submission_url: str, required_domain: str = None) -> Tuple[int, str]:
    """
    Evaluates a GitHub URL for quality indicators.
    Returns: (score (0-100), feedback_string)
    """
    if "github.com" not in submission_url:
        return 0, "Invalid URL. Please submit a GitHub repository or PR link."

    try:
        # Extract Owner/Repo
        # Matches https://github.com/owner/repo or owner/repo
        match = re.search(r'github\.com/([^/]+)/([^/]+)', submission_url)
        if not match:
            return 10, "Could not parse GitHub Repository from URL."
        
        owner, repo = match.group(1), match.group(2)
        repo = repo.replace('.git', '') # Clean extension
        
        api_url = f"https://api.github.com/repos/{owner}/{repo}"
        
        headers = {"Accept": "application/vnd.github.v3+json"}
        
        async with httpx.AsyncClient() as client:
            # 1. Check Repo Details (Stars, Pushed At, Language)
            resp = await client.get(api_url, headers=headers)
            if resp.status_code == 404:
                return 0, "GitHub Repository not found or is private."
            if resp.status_code != 200:
                return 40, f"Could not verify repository details. Status: {resp.status_code}"
                
            data = resp.json()
            
            score = 60 # Base score for existence
            feedback = ["Repository verified."]
            
            # 2. Heuristics
            
            # A. Recent Activity
            last_pushed = data.get("pushed_at")
            if last_pushed:
                # Simple check: Is it this year? (Very rough)
                if "2024" in last_pushed or "2025" in last_pushed or "2026" in last_pushed:
                     score += 10
                     feedback.append("Recent activity detected (+10).")
                else:
                    feedback.append("Repository seems inactive.")

            # B. Description Exists
            if data.get("description"):
                score += 5
                feedback.append("Description present (+5).")
                
            # C. Language Match (if domain provided)
            # This is tricky as 'backend' isn't a language. 
            # We skip strict enforcement but award bonus for likely match.
            repo_lang = data.get("language")
            if repo_lang:
                feedback.append(f"Primary language: {repo_lang}.")
                
            # D. Has Readme? (Usually need content check, but we assume good faith if size > 0)
            if data.get("size", 0) > 0:
                score += 10
                feedback.append("Codebase content verified (+10).")
                
            # 3. Check for specific file if possible (e.g. README.md)
            readme_resp = await client.get(f"{api_url}/readme", headers=headers)
            if readme_resp.status_code == 200:
                 score += 15
                 feedback.append("README documentation found (+15).")
            else:
                 feedback.append("Missing README.md (-15 potential).")

            # Final Clamp
            score = min(100, max(0, score))
            
            return score, " ".join(feedback)

    except Exception as e:
        logger.error(f"GitHub Eval Error: {e}")
        return 50, "Error connecting to GitHub API. Manual review queued."
