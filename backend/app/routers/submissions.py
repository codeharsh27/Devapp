from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import asyncio
import random
from datetime import datetime, timezone
from .. import models, schemas, database
from ..dependencies import get_db, get_current_user
from ..websockets import manager

router = APIRouter(
    tags=["submissions"],
    responses={404: {"description": "Not found"}},
)

# --- BACKGROUND TASKS ---

async def mock_evaluate_submission(submission_id: int):
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

            if submission.submission_url and "github.com" in submission.submission_url:
                # GitHub Strategy
                score, feedback = await evaluation_service.evaluate_github_submission(submission.submission_url)
            else:
                # Generic Link Strategy (Figma, deployed site)
                # For now, if it's not GitHub but has text, we give a participation score
                if submission.submission_url and len(submission.submission_url) > 5:
                    score = 70
                    feedback = "External Link verified. Manual review pending for higher score."
                else:
                    score = 0
                    feedback = "Invalid submission link."

            # Pass logic
            if score >= 50:
                status_val = models.SubmissionStatus.COMPLETED
            else:
                status_val = models.SubmissionStatus.FAILED

            # Update DB
            submission.score = score
            submission.status = status_val
            submission.feedback = feedback
            submission.completed_at = datetime.now(timezone.utc)

            drop = None
            # GAMIFICATION UPDATE: Award XP if passed
            if status_val == models.SubmissionStatus.COMPLETED:
                result_user = await new_db.execute(select(models.User).filter(models.User.id == submission.user_id))
                user = result_user.scalars().first()
                
                result_drop = await new_db.execute(select(models.Drop).filter(models.Drop.id == submission.drop_id))
                drop = result_drop.scalars().first()
                
                if user and drop:
                    user.total_xp = (user.total_xp or 0) + drop.reward_xp
                    
                    # DOMAIN XP UPDATE
                    current_breakdown = dict(user.xp_breakdown) if user.xp_breakdown else {}
                    domain_key = drop.domain.lower()
                    current_xp = current_breakdown.get(domain_key, 0)
                    current_breakdown[domain_key] = current_xp + drop.reward_xp
                    
                    # Force update because SQLAlchemy sometimes misses JSON mutations
                    user.xp_breakdown = current_breakdown
                    
                    # Simple Linear Leveling: 1000 XP per level
                    user.level = int(user.total_xp / 1000) + 1
                    
                    # Re-assign to force update
                    from sqlalchemy.orm.attributes import flag_modified
                    flag_modified(user, "xp_breakdown")

            await new_db.commit()
            print(f"Evaluated Submission {submission_id}: Score {score}, Status {status_val}")
            
            # WEBSOCKET BROADCAST
            await manager.send_personal_message({
                "type": "submission_update",
                "data": {
                    "id": submission.id,
                    "status": status_val.value,  # Convert enum to string
                    "score": score,
                    "drop_id": submission.drop_id,
                    "drop_title": drop.title if drop else "Unknown Drop"
                }
            }, submission.user_id)
                
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
    # Verify drop exists
    result = await db.execute(select(models.Drop).filter(models.Drop.id == submission.drop_id))
    drop = result.scalars().first()
    
    if not drop:
        raise HTTPException(status_code=404, detail="Drop not found")
    
    db_submission = models.Submission(
        user_id=current_user.id,
        drop_id=submission.drop_id,
        submission_url=submission.submission_url,
        doc_url=submission.doc_url,
        image_url=submission.image_url,
        status=models.SubmissionStatus.EVALUATING 
    )
    
    db.add(db_submission)
    await db.commit()
    await db.refresh(db_submission)
    
    # Trigger background evaluation
    background_tasks.add_task(mock_evaluate_submission, db_submission.id)
    
    return db_submission

@router.get("/submissions/{submission_id}", response_model=schemas.Submission)
async def get_submission(submission_id: int, db: AsyncSession = Depends(get_db)):
    """
    Get the status and details of a specific submission.
    """
    result = await db.execute(select(models.Submission).filter(models.Submission.id == submission_id))
    submission = result.scalars().first()
    
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
    return submission
