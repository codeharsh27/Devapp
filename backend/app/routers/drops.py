from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, Header
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
import os
from .. import models, schemas
from ..dependencies import get_db, get_current_user
from ..services.email_service import EmailService

email_service = EmailService()

router = APIRouter(
    prefix="/drops",
    tags=["drops"],
    responses={404: {"description": "Not found"}},
)

# ---------------------------------------------------------------------------
# Internal admin helper for management endpoints.
# Same pattern used in inbox.py.
# ---------------------------------------------------------------------------
_INTERNAL_SECRET = os.environ.get("INTERNAL_API_SECRET", "")


def _require_internal_secret(x_internal_secret: str = Header("")):
    """Dependency — only trusted internal callers may trigger admin operations."""
    if not _INTERNAL_SECRET:
        raise HTTPException(
            status_code=500,
            detail="Server misconfiguration: INTERNAL_API_SECRET not set.",
        )
    if x_internal_secret != _INTERNAL_SECRET:
        raise HTTPException(
            status_code=403,
            detail="Forbidden: invalid or missing internal secret.",
        )


@router.get("", response_model=List[schemas.Drop])
async def get_drops(db: AsyncSession = Depends(get_db)):
    """Fetch all available drops."""
    result = await db.execute(select(models.Drop))
    drops = result.scalars().all()
    return drops


@router.post("/{drop_id}/deploy")
async def deploy_drop_to_desktop(
    drop_id: int,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Simulates deploying mission resources to the user's desktop (via email)."""
    result = await db.execute(select(models.Drop).filter(models.Drop.id == drop_id))
    drop = result.scalars().first()

    if not drop:
        raise HTTPException(status_code=404, detail="Drop not found")

    # Send email in background to avoid blocking response
    background_tasks.add_task(
        email_service.send_mission_briefing,
        to_email=current_user.email,
        drop_title=drop.title,
        drop_domain=drop.domain
    )

    return {"message": "Mission Intel deployed to connected terminal"}


@router.post("/sync-github")
async def sync_github_source(
    background_tasks: BackgroundTasks,
    _: None = Depends(_require_internal_secret),
):
    """
    Triggers a background task to fetch and sync GitHub 'good first issues' as drops.
    Protected: requires INTERNAL_API_SECRET header.
    """
    from ..services import github_service
    background_tasks.add_task(github_service.sync_github_drops)
    return {"message": "GitHub sync started in background"}


@router.post("/seed")
async def seed_database(
    db: AsyncSession = Depends(get_db),
    _: None = Depends(_require_internal_secret),
):
    """
    Dev/admin utility to seed the database with initial drops.
    Protected: requires INTERNAL_API_SECRET header. Should only run once.
    """
    result = await db.execute(select(models.Drop).limit(1))
    if result.scalars().first():
        return {"message": "Database already seeded"}

    seeds = [
        models.Drop(
            title="Implement JWT Auth",
            description="Create a secure authentication system using JSON Web Tokens. Handle token generation, validation, and refresh flow.",
            domain="backend",
            difficulty=models.DifficultyLevel.MEDIUM,
            time_limit_minutes=120,
            reward_xp=500,
            inputs_url="https://github.com/devapp-corp/challenge-jwt-auth"
        ),
        models.Drop(
            title="React Infinite Scroll",
            description="Build a performant infinite scroll component in React that fetches data from an API. Must handle loading states and error boundaries.",
            domain="frontend",
            difficulty=models.DifficultyLevel.EASY,
            time_limit_minutes=60,
            reward_xp=300,
            inputs_url="https://github.com/devapp-corp/challenge-infinite-scroll"
        ),
        models.Drop(
            title="Optimize SQL Query",
            description="Given a slow query and a rigorous dataset, optimize the indexes and query structure to reduce execution time by 90%.",
            domain="backend",
            difficulty=models.DifficultyLevel.HARD,
            time_limit_minutes=45,
            reward_xp=800,
            inputs_url="https://github.com/devapp-corp/challenge-sql-opt"
        ),
    ]

    db.add_all(seeds)
    await db.commit()
    return {"message": "Seeded 3 drops"}
