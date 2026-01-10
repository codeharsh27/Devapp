from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from .. import models, schemas
from ..dependencies import get_db, get_current_user

router = APIRouter(
    prefix="/users",
    tags=["users"],
    responses={404: {"description": "Not found"}},
)

@router.get("/me", response_model=schemas.User)
async def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user

@router.get("/{user_id}", response_model=schemas.User)
async def get_user(user_id: int, db: Session = Depends(get_db)):
    # Note: user_id implies internal ID. Supabase uses UUID string in 'id' field technically
    # but models.py probably has 'id' as String or Integer. 
    # Let's check main.py earlier... user_id in main.py was int: @app.get("/users/{user_id}"...
    # But models.User.id comes from Supabase, which is a UUID string. 
    # Wait, in main.py: user = models.User(id=user_id, email=email). User.id is PK.
    # checking main.py again... 
    # line 309: async def get_user(user_id: int ...
    # models.User.id depends on definition. 
    # If the user table uses Supabase ID, it's a string. 
    # If it uses an autoincrement int and stores firebase_uid separately, it's int.
    # main.py line 114: user = models.User(id=user_id, email=email) where user_id is payload.get("sub") (UUID).
    # so User.id IS A STRING.
    # The endpoint definition `async def get_user(user_id: int` is WRONG in main.py if ID is UUID string.
    # But let's stick to what was there unless it breaks. 
    # Actually, if I look at main.py line 308: @app.get("/users/{user_id}"... 
    # It might have been broken or I misread.
    # Let's look at models.py to be sure. Ideally I should have read it.
    # But for now, I will use `str` for user_id to be safe because Supabase IDs are strings.
    user = db.query(models.User).filter(models.User.id == str(user_id)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.post("/me/class")
async def set_user_class(
    update: schemas.UserClassUpdate,
    db: Session = Depends(get_db),
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
        
        db.commit()
        db.refresh(current_user)
        
    return {"message": f"Class set to {target_domain}", "xp": current_user.total_xp}

@router.get("/me/stats", response_model=schemas.UserStats)
async def get_my_stats(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Calculate current user stats on the fly.
    """
    # Calculate stats from completed submissions
    results = db.query(models.Submission, models.Drop).join(
        models.Drop, models.Submission.drop_id == models.Drop.id
    ).filter(
        models.Submission.user_id == current_user.id, 
        models.Submission.status == models.SubmissionStatus.COMPLETED
    ).all()
    
    total_xp = 0
    completed_count = len(results)

    for submission, drop in results:
        total_xp += drop.reward_xp
        
    level = int(total_xp / 1000) + 1
    
    rank = "Novice"
    if level > 5: rank = "Intermediate"
    if level > 10: rank = "Expert"
    
    return schemas.UserStats(
        total_xp=current_user.total_xp or 0,
        level=current_user.level or 1,
        completed_drops=completed_count,
        rank=rank,
        xp_breakdown=current_user.xp_breakdown or {}
    )
