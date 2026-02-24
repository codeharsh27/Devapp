from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, Header
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
import os
from .. import models, schemas
from app.core.dependencies import get_db, get_current_user
from ..services.email_service import EmailService

email_service = EmailService()

# We keep the /drops endpoint for backwards compatibility with the mobile app,
# but internally these are modeled as Tasks.
router = APIRouter(
    prefix="/drops",
    tags=["drops"],
    responses={404: {"description": "Not found"}},
)

_INTERNAL_SECRET = os.environ.get("INTERNAL_API_SECRET", "")


def _require_internal_secret(x_internal_secret: str = Header("")):
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


@router.get("", response_model=List[schemas.Task])
async def get_drops(db: AsyncSession = Depends(get_db)):
    """Fetch all available drops (tasks)."""
    result = await db.execute(select(models.Task))
    drops = result.scalars().all()
    return drops

@router.post("", response_model=schemas.Task)
async def create_drop(
    task_in: schemas.TaskCreate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Startups create a new Drop (Task). Requires auth."""
    # Ensure only founders/startups create drops if you have a role check,
    # for now we allow any authenticated user to create a task assigned to them.
    new_task = models.Task(
        startup_id=current_user.id,
        title=task_in.title,
        description=task_in.description,
        bounty_amount=task_in.bounty_amount,
        category=task_in.category,
        difficulty_level=task_in.difficulty_level,
        estimated_hours=task_in.estimated_hours,
        status=task_in.status,
        repo_url=task_in.repo_url,
        requirements=task_in.requirements,
        is_promoted=task_in.is_promoted,
        deadline=task_in.deadline,
        max_submissions=task_in.max_submissions
    )
    db.add(new_task)
    await db.commit()
    await db.refresh(new_task)
    return new_task

@router.get("/{task_id}/submissions", response_model=List[schemas.SubmissionWithDeveloper])
async def get_task_submissions(
    task_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all submissions for a specific drop (task).
    Only the startup that created the task can view its submissions.
    """
    from sqlalchemy.orm import selectinload

    result = await db.execute(select(models.Task).filter(models.Task.id == task_id))
    task = result.scalars().first()
    
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
        
    if task.startup_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to view these submissions")
        
    submissions_result = await db.execute(
        select(models.Submission)
        .options(selectinload(models.Submission.developer))
        .filter(models.Submission.task_id == task_id)
        .order_by(models.Submission.created_at.desc())
    )
    
    return submissions_result.scalars().all()

@router.post("/{drop_id}/deploy")
async def deploy_drop_to_desktop(
    drop_id: str,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    """Simulates deploying mission resources to the user's desktop (via email)."""
    result = await db.execute(select(models.Task).filter(models.Task.id == drop_id))
    drop = result.scalars().first()

    if not drop:
        raise HTTPException(status_code=404, detail="Drop not found")

    background_tasks.add_task(
        email_service.send_mission_briefing,
        to_email=current_user.email,
        drop_title=drop.title,
        drop_domain=drop.category
    )

    return {"message": "Mission Intel deployed to connected terminal"}


@router.post("/seed")
async def seed_database(
    db: AsyncSession = Depends(get_db),
    _: None = Depends(_require_internal_secret),
):
    """
    Dev/admin utility to seed the database with initial drops.
    Protected: requires INTERNAL_API_SECRET header. Should only run once.
    """
    result = await db.execute(select(models.Task).limit(1))
    if result.scalars().first():
        return {"message": "Database already seeded"}

    # We need a system or admin user ID to assign these seeds to.
    # For a real implementation, you'd find a specific startup ID.
    # Let's just create a dummy startup to own seeds.
    dummy_startup = models.User(id="seed-startup-uuid", email="startup@seed.com", full_name="Seed Startup")
    db.add(dummy_startup)
    await db.commit()
    await db.refresh(dummy_startup)

    seeds = [
        models.Task(
            startup_id=dummy_startup.id,
            title="Implement JWT Auth",
            description="Create a secure authentication system using JSON Web Tokens. Handle token generation, validation, and refresh flow.",
            category="backend",
            difficulty_level=2,
            estimated_hours=2,
            bounty_amount=0,
            repo_url="https://github.com/devapp-corp/challenge-jwt-auth",
            status=models.TaskStatus.OPEN
        ),
        models.Task(
            startup_id=dummy_startup.id,
            title="React Infinite Scroll",
            description="Build a performant infinite scroll component in React that fetches data from an API. Must handle loading states and error boundaries.",
            category="frontend",
            difficulty_level=1,
            estimated_hours=1,
            bounty_amount=0,
            repo_url="https://github.com/devapp-corp/challenge-infinite-scroll",
            status=models.TaskStatus.OPEN
        ),
    ]

    db.add_all(seeds)
    await db.commit()
    return {"message": f"Seeded {len(seeds)} drops"}
