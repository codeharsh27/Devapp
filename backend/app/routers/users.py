from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from .. import models, schemas
from app.core.dependencies import get_db, get_current_user
import uuid

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
)

@router.get("/activity/global", response_model=list[schemas.ActivityEntry])
async def get_global_activity(db: AsyncSession = Depends(get_db)):
    """
    Get the last 10 completed submissions from any user for the 'Live Ops' feed.
    """
    # Join Submission, User, and Task
    stmt = (
        select(models.Submission, models.User, models.Task)
        .join(models.User, models.Submission.developer_id == models.User.id)
        .join(models.Task, models.Submission.task_id == models.Task.id)
        .filter(models.Submission.status == models.SubmissionStatus.EVALUATED)
        .order_by(models.Submission.completed_at.desc())
        .limit(10)
    )
    
    result = await db.execute(stmt)
    results = result.all()
    
    activity = []
    for sub, user, task in results:
        activity.append(schemas.ActivityEntry(
            user_id=user.id,
            user_name=user.full_name or "Unknown Agent",
            user_avatar=user.avatar_url,
            drop_title=task.title,
            drop_domain=task.category,
            completed_at=sub.completed_at or sub.created_at,
            xp_earned=(task.difficulty_level or 1) * 100
        ))
        
    return activity

@router.get("/me", response_model=schemas.User)
async def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user

@router.put("/me", response_model=schemas.User)
async def update_user_me(
    update: schemas.UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    if update.full_name is not None:
        current_user.full_name = update.full_name
    if update.bio is not None:
        current_user.bio = update.bio
    if update.avatar_url is not None:
        current_user.avatar_url = update.avatar_url
    if update.role is not None:
        current_user.role = update.role
    if update.website is not None:
        current_user.website = update.website
    if update.location is not None:
        current_user.location = update.location
    if update.industry is not None:
        current_user.industry = update.industry
    if update.team_size is not None:
        current_user.team_size = update.team_size
    if update.upi_id is not None:
        current_user.upi_id = update.upi_id
    if update.skills is not None:
        current_user.skills = update.skills
        from sqlalchemy.orm.attributes import flag_modified
        flag_modified(current_user, "skills")

    await db.commit()
    await db.refresh(current_user)
    return current_user

@router.get("/leaderboard", response_model=list[schemas.LeaderboardEntry])
async def get_leaderboard(
    domain: str | None = None,
    db: AsyncSession = Depends(get_db)
):
    """
    Return top 50 users sorted by XP.
    """
    if domain:
        domain_lower = domain.lower()
        # Filter out users with no XP for this domain, sort descending.
        stmt = (
            select(models.User)
            .filter(
                models.User.xp_breakdown[domain_lower].as_integer() > 0
            )
            .order_by(
                models.User.xp_breakdown[domain_lower].as_integer().desc()
            )
            .limit(50)
        )
    else:
        stmt = (
            select(models.User)
            .filter(models.User.total_xp > 0)
            .order_by(models.User.total_xp.desc())
            .limit(50)
        )

    result = await db.execute(stmt)
    users = result.scalars().all()

    entries = []
    for user in users:
        if domain:
            domain_lower = domain.lower()
            xp_breakdown = user.xp_breakdown or {}
            current_xp = xp_breakdown.get(domain_lower, 0)
            current_level = int(current_xp / 500) + 1
        else:
            current_xp = user.total_xp or 0
            current_level = user.level or 1

        entries.append(schemas.LeaderboardEntry(
            id=user.id,
            full_name=user.full_name,
            avatar_url=user.avatar_url,
            total_xp=current_xp,
            level=current_level
        ))

    return entries


@router.get("/{user_id}", response_model=schemas.User)
async def get_user(user_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(models.User).filter(models.User.id == str(user_id)))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@router.get("/me/stats", response_model=schemas.UserStats)
async def get_my_stats(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Calculate current user stats on the fly.
    """
    stmt = (
        select(models.Submission, models.Task)
        .join(models.Task, models.Submission.task_id == models.Task.id)
        .filter(
            models.Submission.developer_id == current_user.id, 
            models.Submission.status == models.SubmissionStatus.EVALUATED
        )
    )
    result = await db.execute(stmt)
    results = result.all()
    
    total_xp = 0
    completed_count = len(results)

    for submission, task in results:
        total_xp += (task.difficulty_level or 1) * 100
        
    level = int(total_xp / 1000) + 1
    
    rank = "Novice"
    if level > 5: rank = "Intermediate"
    if level > 10: rank = "Expert"
    
    return schemas.UserStats(
        total_xp=int(current_user.total_xp or 0),
        level=int(current_user.level or 1),
        completed_drops=completed_count,
        rank=rank,
        xp_breakdown=current_user.xp_breakdown or {}
    )

@router.get("/me/activity", response_model=dict[str, int])
async def get_my_activity(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get daily submission activity for the contribution graph.
    Returns { "YYYY-MM-DD": count }
    """
    result = await db.execute(select(models.Submission).filter(
        models.Submission.developer_id == current_user.id,
        models.Submission.status == models.SubmissionStatus.EVALUATED
    ))
    submissions = result.scalars().all()
    
    activity = {}
    for sub in submissions:
        if sub.completed_at:
            date_str = sub.completed_at.strftime("%Y-%m-%d")
            activity[date_str] = activity.get(date_str, 0) + 1
            
    return activity

@router.get("/me/submissions", response_model=list[schemas.SubmissionWithTask])
async def get_my_submissions(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all submissions for the current user, including Task details.
    """
    stmt = (
        select(models.Submission)
        .options(selectinload(models.Submission.task))
        .filter(models.Submission.developer_id == current_user.id)
        .order_by(models.Submission.created_at.desc())
    )
    result = await db.execute(stmt)
    submissions = result.scalars().all()
    
    return submissions

@router.get("/me/candidates", response_model=list[schemas.SubmissionWithTaskAndDeveloper])
async def get_my_candidates(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all submissions for tasks created by the current user (startup).
    """
    stmt = (
        select(models.Submission)
        .join(models.Task, models.Submission.task_id == models.Task.id)
        .filter(models.Task.startup_id == current_user.id)
        .options(
            selectinload(models.Submission.task),
            selectinload(models.Submission.developer)
        )
        .order_by(models.Submission.created_at.desc())
    )
    result = await db.execute(stmt)
    submissions = result.scalars().all()
    
    return submissions

@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_my_account(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Delete the current user's account and all associated data.
    This action is irreversible.
    """
    await db.delete(current_user)
    await db.commit()
    
    return None


