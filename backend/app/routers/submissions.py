from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import asyncio
import random
from datetime import datetime, timezone
from app import models, schemas
from app.core import database
from app.core.dependencies import get_db, get_current_user
from ..websockets import manager

router = APIRouter(
    tags=["submissions"],
    responses={404: {"description": "Not found"}},
)

# --- BACKGROUND TASKS ---

async def mock_evaluate_submission(submission_id: str):
    # Simulate processing time for "Analysis"
    await asyncio.sleep(3) 

    # Re-instantiate session for the background task
    async with database.AsyncSessionLocal() as new_db:
        try:
            result = await new_db.execute(select(models.Submission).filter(models.Submission.id == submission_id))
            submission = result.scalars().first()
            if not submission:
                print(f"Submission {submission_id} not found during eval.")
                return

            # --- REAL EVALUATION LOGIC ---
            from ..services import evaluation_service
            
            score = 0
            status_val = models.SubmissionStatus.FAILED
            feedback = "Evaluation failed."

            if submission.repo_url and "github.com" in submission.repo_url:
                # GitHub Strategy
                score, feedback = await evaluation_service.evaluate_github_submission(submission.repo_url)
            else:
                # Generic Link Strategy
                if submission.demo_url and len(submission.demo_url) > 5:
                    score = 70
                    feedback = "External Link verified. Manual review pending for higher score."
                else:
                    score = 0
                    feedback = "Invalid submission link."

            # Pass logic
            if score >= 50:
                status_val = models.SubmissionStatus.EVALUATED
            else:
                status_val = models.SubmissionStatus.FAILED

            # Update DB
            submission.ai_score = score
            submission.final_score = score
            submission.status = status_val
            submission.feedback = feedback
            submission.completed_at = datetime.now(timezone.utc)

            task = None
            if status_val == models.SubmissionStatus.EVALUATED:
                result_user = await new_db.execute(select(models.User).filter(models.User.id == submission.developer_id))
                user = result_user.scalars().first()
                
                result_task = await new_db.execute(select(models.Task).filter(models.Task.id == submission.task_id))
                task = result_task.scalars().first()
                
                if user and task:
                    reward_xp = (task.difficulty_level or 1) * 100
                    user.total_xp = (user.total_xp or 0) + reward_xp
                    
                    # DOMAIN XP UPDATE
                    current_breakdown = dict(user.xp_breakdown) if user.xp_breakdown else {}
                    domain_key = (task.category or "general").lower()
                    current_xp = current_breakdown.get(domain_key, 0)
                    current_breakdown[domain_key] = current_xp + reward_xp
                    
                    user.xp_breakdown = current_breakdown
                    user.level = int(user.total_xp / 1000) + 1
                    
                    from sqlalchemy.orm.attributes import flag_modified
                    flag_modified(user, "xp_breakdown")

            await new_db.commit()
            print(f"Evaluated Submission {submission_id}: Score {score}, Status {status_val}")
            
            # WEBSOCKET BROADCAST
            await manager.send_personal_message({
                "type": "submission_update",
                "data": {
                    "id": submission.id,
                    "status": status_val.value,
                    "score": score,
                    "task_id": submission.task_id,
                    "task_title": task.title if task else "Unknown Drop"
                }
            }, submission.developer_id)
                
        except Exception as e:
            print(f"Error in background evaluation: {e}")

# --- ENDPOINTS ---

@router.post("/submit", response_model=schemas.Submission)
async def submit_drop(
    submission: schemas.SubmissionCreate, 
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Submit a solution for a Drop. Triggers async evaluation.
    Requires Authentication.
    """
    # Verify task exists
    result = await db.execute(select(models.Task).filter(models.Task.id == submission.task_id))
    task = result.scalars().first()
    
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    
    db_submission = models.Submission(
        developer_id=current_user.id,
        task_id=submission.task_id,
        repo_url=submission.repo_url,
        demo_url=submission.demo_url,
        notes=submission.notes,
        status=models.SubmissionStatus.PROCESSING 
    )
    
    db.add(db_submission)
    await db.commit()
    await db.refresh(db_submission)
    
    # Trigger background evaluation
    background_tasks.add_task(mock_evaluate_submission, db_submission.id)
    
    return db_submission

@router.get("/submissions/{submission_id}", response_model=schemas.Submission)
async def get_submission(submission_id: str, db: AsyncSession = Depends(get_db)):
    """
    Get the status and details of a specific submission.
    """
    result = await db.execute(select(models.Submission).filter(models.Submission.id == submission_id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
    return submission

@router.post("/submissions/{submission_id}/award")
async def award_submission(
    submission_id: str, 
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Award a submission (hire the developer).
    Requires startup authentication.
    """
    result = await db.execute(select(models.Submission).filter(models.Submission.id == submission_id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")

    result_task = await db.execute(select(models.Task).filter(models.Task.id == submission.task_id))
    task = result_task.scalars().first()

    if not task or task.startup_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to award this task")

    # Update Submission Status
    submission.status = models.SubmissionStatus.HIRED
    
    # Update Task Status
    task.status = models.TaskStatus.CLOSED

    # Reward XP logic (extra for being hired)
    result_dev = await db.execute(select(models.User).filter(models.User.id == submission.developer_id))
    dev = result_dev.scalars().first()
    if dev:
        reward_xp = 500  # Bonus for being hired
        dev.total_xp = (dev.total_xp or 0) + reward_xp
        
        # DOMAIN XP UPDATE
        current_breakdown = dict(dev.xp_breakdown) if dev.xp_breakdown else {}
        domain_key = (task.category or "general").lower()
        current_xp = current_breakdown.get(domain_key, 0)
        current_breakdown[domain_key] = current_xp + reward_xp
        
        dev.xp_breakdown = current_breakdown
        dev.level = int(dev.total_xp / 1000) + 1
        
        from sqlalchemy.orm.attributes import flag_modified
        flag_modified(dev, "xp_breakdown")

    await db.commit()
    return {"message": "Success", "status": "HIRED"}
