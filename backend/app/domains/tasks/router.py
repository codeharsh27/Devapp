from fastapi import APIRouter, Depends, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app import schemas
from app.core.dependencies import get_db, get_startup_user, get_talent_user, get_current_user
from app.models import User
from app.domains.tasks.service import TaskService

router = APIRouter(
    prefix="/api/v1/tasks",
    tags=["tasks"],
)

@router.get("", response_model=List[schemas.Task])
async def get_tasks(db: AsyncSession = Depends(get_db)):
    """Talent browses all open tasks."""
    svc = TaskService(db)
    return await svc.task_repo.get_all_open()

@router.post("", response_model=schemas.Task)
async def create_task(
    task_in: schemas.TaskCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_startup_user)
):
    """Startups create a new Task."""
    svc = TaskService(db)
    return await svc.create_task(current_user.id, task_in.model_dump())

@router.post("/{task_id}/enroll")
async def enroll_task(
    task_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_talent_user)
):
    """Talent opts into a task."""
    svc = TaskService(db)
    sub = await svc.enroll(task_id, current_user.id)
    return {"message": "Enrolled successfully", "submission_id": sub.id}

@router.post("/{task_id}/submit")
async def submit_task(
    task_id: str,
    submission_in: schemas.SubmissionCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_talent_user)
):
    """Talent submits their work."""
    svc = TaskService(db)
    sub = await svc.submit_work(
        task_id=task_id,
        talent_id=current_user.id,
        repo_url=submission_in.repo_url or "",
        demo_url=submission_in.demo_url,
        notes=submission_in.notes
    )
    return {"message": "Submitted successfully", "submission_id": sub.id}

@router.get("/{task_id}/submissions", response_model=List[schemas.SubmissionWithDeveloper])
async def get_task_submissions(
    task_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_startup_user)
):
    """Startup views submissions for their task."""
    svc = TaskService(db)
    task = await svc.task_repo.get_by_id(task_id)
    from app.core.exceptions import RBACException, BusinessRuleException
    if not task:
         raise BusinessRuleException("NOT_FOUND", "Task not found")
    if task.startup_id != current_user.id:
         raise RBACException("Not authorized")
         
    return await svc.sub_repo.get_all_by_task(task_id)
