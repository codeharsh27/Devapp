from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, status
from sqlalchemy.orm import Session
import asyncio
import random
from datetime import datetime
from .. import models, schemas, database
from ..dependencies import get_db, get_current_user

router = APIRouter(
    tags=["submissions"],
    responses={404: {"description": "Not found"}},
)

# --- BACKGROUND TASKS ---

async def mock_evaluate_submission(submission_id: int):
    print(f"DEBUG: Starting evaluation for {submission_id}...")
    """
    Simulates a time-consuming evaluation process (e.g. running unit tests via Docker).
    """
    await asyncio.sleep(5) # Simulate processing time
    
    # Randomly assign pass/fail and score
    # In a real app, this would read from the worker result
    score = random.randint(0, 100)
    status_val = models.SubmissionStatus.COMPLETED
    feedback = "Automated tests passed."
    
    if score < 50:
        status_val = models.SubmissionStatus.FAILED
        feedback = "Automated tests failed. Check edge cases."
        
    # Re-instantiate session for the background task to be safe
    new_db = database.SessionLocal()
    try:
        submission = new_db.query(models.Submission).filter(models.Submission.id == submission_id).first()
        if submission:
            submission.score = score
            submission.status = status_val
            submission.feedback = feedback
            submission.completed_at = datetime.utcnow()

            # GAMIFICATION UPDATE: Award XP if passed
            if status_val == models.SubmissionStatus.COMPLETED:
                user = new_db.query(models.User).filter(models.User.id == submission.user_id).first()
                drop = new_db.query(models.Drop).filter(models.Drop.id == submission.drop_id).first()
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
                    from sqlalchemy import inspect
                    inspect(user).attrs.xp_breakdown.history.has_changes() # Trigger change detection

            new_db.commit()
            print(f"Evaluated Submission {submission_id}: Score {score}, User XP: {user.total_xp if 'user' in locals() else 'N/A'}")
            
    except Exception as e:
        print(f"Error in background evaluation: {e}")
    finally:
        new_db.close()

# --- ENDPOINTS ---

@router.post("/submit", response_model=schemas.Submission)
async def submit_drop(
    submission: schemas.SubmissionCreate, 
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Submit a solution for a Drop. Triggers async evaluation.
    Requires Authentication.
    """
    # Verify drop exists
    drop = db.query(models.Drop).filter(models.Drop.id == submission.drop_id).first()
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
    db.commit()
    db.refresh(db_submission)
    
    # Trigger background evaluation
    background_tasks.add_task(mock_evaluate_submission, db_submission.id)
    
    return db_submission

@router.get("/submissions/{submission_id}", response_model=schemas.Submission)
async def get_submission(submission_id: int, db: Session = Depends(get_db)):
    """
    Get the status and details of a specific submission.
    """
    submission = db.query(models.Submission).filter(models.Submission.id == submission_id).first()
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
    return submission
