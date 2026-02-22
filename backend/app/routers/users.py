from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from .. import models, schemas
from ..dependencies import get_db, get_current_user

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
    # Join Submission, User, and Drop
    stmt = (
        select(models.Submission, models.User, models.Drop)
        .join(models.User, models.Submission.user_id == models.User.id)
        .join(models.Drop, models.Submission.drop_id == models.Drop.id)
        .filter(models.Submission.status == models.SubmissionStatus.COMPLETED)
        .order_by(models.Submission.completed_at.desc())
        .limit(10)
    )
    
    result = await db.execute(stmt)
    results = result.all()
    
    activity = []
    for sub, user, drop in results:
        activity.append(schemas.ActivityEntry(
            user_id=user.id,
            user_name=user.full_name or "Unknown Agent",
            user_avatar=user.avatar_url,
            drop_title=drop.title,
            drop_domain=drop.domain,
            completed_at=sub.completed_at or sub.submitted_at,
            xp_earned=drop.reward_xp
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
    if update.upi_id is not None:
        current_user.upi_id = update.upi_id
    if update.social_links is not None:
        # Merge or Replace? Let's Replace for simplicity
        current_user.social_links = update.social_links
        # Ensure change detection for JSON
        from sqlalchemy.orm.attributes import flag_modified
        flag_modified(current_user, "social_links")

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
    Sorting and limiting happen in the database — no full table scan in Python.
    """
    from sqlalchemy import cast, Integer, func as sql_func

    if domain:
        # Extract the domain XP value from the JSON column via a SQL cast.
        # Supabase/Postgres: use json_extract_path_text; SQLite: json_extract.
        # SQLAlchemy's generic JSON subscript operator works on both.
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

@router.post("/me/class")
async def set_user_class(
    update: schemas.UserClassUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Sets the user's initial class/domain by giving them a starter boost.
    """
    current_breakdown = dict(current_user.xp_breakdown or {})
    target_domain = update.domain.lower()
    
    # Grant initial XP boost if not already present heavily
    if current_breakdown.get(target_domain, 0) < 50:
        current_breakdown[target_domain] = 50
        
        # Update Total XP
        current_user.total_xp = (current_user.total_xp or 0) + 50
        current_user.level = int(current_user.total_xp / 1000) + 1
        
        # Save
        current_user.xp_breakdown = current_breakdown
        
        # Force SQLAlchemy to detect JSON change if needed
        from sqlalchemy.orm.attributes import flag_modified
        flag_modified(current_user, "xp_breakdown")
        
        await db.commit()
        await db.refresh(current_user)
        
    return {"message": f"Class set to {target_domain}", "xp": current_user.total_xp}

@router.get("/me/stats", response_model=schemas.UserStats)
async def get_my_stats(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Calculate current user stats on the fly.
    """
    # Calculate stats from completed submissions
    stmt = (
        select(models.Submission, models.Drop)
        .join(models.Drop, models.Submission.drop_id == models.Drop.id)
        .filter(
            models.Submission.user_id == current_user.id, 
            models.Submission.status == models.SubmissionStatus.COMPLETED
        )
    )
    result = await db.execute(stmt)
    results = result.all()
    
    total_xp = 0
    completed_count = len(results)

    for submission, drop in results:
        total_xp += drop.reward_xp
        
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
        models.Submission.user_id == current_user.id,
        models.Submission.status == models.SubmissionStatus.COMPLETED
    ))
    submissions = result.scalars().all()
    
    activity = {}
    for sub in submissions:
        if sub.completed_at:
            # Format as YYYY-MM-DD
            date_str = sub.completed_at.strftime("%Y-%m-%d")
            activity[date_str] = activity.get(date_str, 0) + 1
            
    return activity

@router.get("/me/submissions", response_model=list[schemas.SubmissionWithDrop])
async def get_my_submissions(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get all submissions for the current user, including Drop details.
    """
    # For SubmissionWithDrop, we need to eager load the 'drop' relationship
    stmt = (
        select(models.Submission)
        .options(selectinload(models.Submission.drop))
        .filter(models.Submission.user_id == current_user.id)
        .order_by(models.Submission.submitted_at.desc())
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
    # Delete User (Cascade should handle related data if configured, 
    # but SQLAlchemy often needs explicit cascade in models or manual deletion if not DB-level)
    # Assuming DB-level cascade or simplified deletion for now.
    
    # Check if we need to manually delete related items if no cascade
    # For now, we trust the DB FK constraints are set to CASCADE or we just delete the user.
    await db.delete(current_user)
    await db.commit()
    
    return None


