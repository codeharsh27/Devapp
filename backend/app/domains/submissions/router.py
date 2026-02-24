from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from pydantic import BaseModel
from app import schemas
from app.core.dependencies import get_db, get_startup_user
from app.models import User
from app.domains.tasks.service import TaskService
from app.domains.submissions.repository import SubmissionRepository
from app.core.exceptions import BusinessRuleException

router = APIRouter(
    prefix="/api/v1/submissions",
    tags=["submissions"],
)

class ReviewRequest(BaseModel):
    action: str  # ACCEPT or REJECT
    feedback: str = None

@router.get("/{submission_id}", response_model=schemas.Submission)
async def get_submission(
    submission_id: str,
    db: AsyncSession = Depends(get_db)
):
    repo = SubmissionRepository(db)
    sub = await repo.get_by_id(submission_id)
    if not sub:
        raise BusinessRuleException("NOT_FOUND", "Submission not found", 404)
    return sub

@router.post("/{submission_id}/review")
async def review_submission(
    submission_id: str,
    req: ReviewRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_startup_user)
):
    """Startups accept or reject a submission. Transactional."""
    svc = TaskService(db)
    repo = SubmissionRepository(db)
    sub = await repo.get_by_id(submission_id)
    if not sub:
        raise BusinessRuleException("NOT_FOUND", "Submission not found", 404)
        
    updated_sub = await svc.review_submission(
        task_id=sub.task_id,
        submission_id=submission_id,
        startup_id=current_user.id,
        action=req.action,
        feedback=req.feedback
    )
    return {"message": f"Submission {req.action.lower()}ed successfully"}
