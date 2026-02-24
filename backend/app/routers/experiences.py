from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
from .. import models, schemas
from app.core.dependencies import get_db, get_current_user

router = APIRouter(
    prefix="/experiences",
    tags=["experiences"]
)


@router.get("/", response_model=List[schemas.Experience])
async def get_my_experiences(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get 'Contributions' - automatically generated from completed submissions.
    Filters for Open Source, Gig, or Recruiter tasks (simulated by filtering for EVALUATED status for now).
    """
    stmt = (
        select(models.Submission)
        .join(models.Task)
        .filter(
            models.Submission.developer_id == current_user.id,
            models.Submission.status == models.SubmissionStatus.EVALUATED
        )
        .order_by(models.Submission.completed_at.desc())
    )
    result = await db.execute(stmt)
    submissions = result.scalars().all()

    experiences = []
    for sub in submissions:
        exp_type = "project"
        title_lower = sub.task.title.lower() if sub.task else "unknown"
        if "gig" in title_lower:
            exp_type = "gig"
        elif "open source" in title_lower or "contribution" in title_lower:
            exp_type = "opensource"
        elif "hackathon" in title_lower:
            exp_type = "hackathon"
        
        tech_stack = [sub.task.category] if sub.task and sub.task.category else []
        
        exp = schemas.Experience(
            id=sub.id,
            user_id=sub.developer_id,
            title=sub.task.title if sub.task else "Unknown Task",
            role="Contributor",
            experience_type=exp_type,
            description=sub.task.description if sub.task else "",
            contributions=[f"Completed {sub.task.title if sub.task else 'Task'}", f"Score: {sub.final_score or 'N/A'}"],
            tech_stack=tech_stack,
            project_url=sub.repo_url,
            image_url=sub.demo_url,
            start_date=sub.created_at, 
            end_date=sub.completed_at,
            is_current=False,
            is_verified=True,
            is_featured=False, 
            display_order=0,
            created_at=sub.created_at,
            updated_at=sub.completed_at or sub.created_at
        )
        experiences.append(exp)

    return experiences


@router.get("/featured", response_model=List[schemas.ExperienceSummary])
async def get_featured_experiences(
    limit: int = 3,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """
    Get top 'Contributions' for profile display - automatically generated from completed submissions.
    """
    stmt = (
        select(models.Submission)
        .join(models.Task)
        .filter(
            models.Submission.developer_id == current_user.id,
            models.Submission.status == models.SubmissionStatus.EVALUATED
        )
        .order_by(models.Submission.completed_at.desc())
        .limit(limit)
    )
    result = await db.execute(stmt)
    submissions = result.scalars().all()

    experiences = []
    for sub in submissions:
        exp_type = "project"
        title_lower = sub.task.title.lower() if sub.task else "unknown"
        if "gig" in title_lower:
            exp_type = "gig"
        elif "open source" in title_lower or "contribution" in title_lower:
            exp_type = "opensource"
        elif "hackathon" in title_lower:
            exp_type = "hackathon"
        
        tech_stack = [sub.task.category] if sub.task and sub.task.category else []
        
        role_str = sub.completed_at.strftime("%b %Y") if sub.completed_at else "In Progress"
        
        exp = schemas.ExperienceSummary(
            id=sub.id,
            title=sub.task.title if sub.task else "Unknown",
            role=role_str,
            experience_type=exp_type,
            tech_stack=tech_stack,
            project_url=sub.repo_url,
            image_url=sub.demo_url,
            is_current=False, 
            is_verified=True
        )
        experiences.append(exp)
    
    return experiences


@router.get("/{experience_id}", response_model=schemas.Experience)
async def get_experience(
    experience_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Get a specific experience by ID"""
    stmt = select(models.Experience).filter(
        models.Experience.id == experience_id,
        models.Experience.user_id == current_user.id
    )
    result = await db.execute(stmt)
    experience = result.scalars().first()
    
    if not experience:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Experience not found"
        )
    
    return experience


@router.post("/", response_model=schemas.Experience, status_code=status.HTTP_201_CREATED)
async def create_experience(
    experience: schemas.ExperienceCreate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Create a new experience entry"""
    db_experience = models.Experience(
        user_id=current_user.id,
        title=experience.title,
        role=experience.role,
        experience_type=experience.experience_type or "project",
        description=experience.description,
        contributions=experience.contributions or [],
        tech_stack=experience.tech_stack or [],
        project_url=experience.project_url,
        image_url=experience.image_url,
        start_date=experience.start_date,
        end_date=experience.end_date,
        is_current=experience.is_current or False,
        is_featured=experience.is_featured or False,
    )
    
    db.add(db_experience)
    await db.commit()
    await db.refresh(db_experience)
    
    return db_experience


@router.put("/{experience_id}", response_model=schemas.Experience)
async def update_experience(
    experience_id: str,
    experience: schemas.ExperienceUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Update an experience entry"""
    stmt = select(models.Experience).filter(
        models.Experience.id == experience_id,
        models.Experience.user_id == current_user.id
    )
    result = await db.execute(stmt)
    db_experience = result.scalars().first()
    
    if not db_experience:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Experience not found"
        )
    
    # Update only provided fields
    update_data = experience.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        if value is not None:
            setattr(db_experience, field, value)
    
    await db.commit()
    await db.refresh(db_experience)
    
    return db_experience


@router.delete("/{experience_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_experience(
    experience_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Delete an experience entry"""
    stmt = select(models.Experience).filter(
        models.Experience.id == experience_id,
        models.Experience.user_id == current_user.id
    )
    result = await db.execute(stmt)
    db_experience = result.scalars().first()
    
    if not db_experience:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Experience not found"
        )
    
    await db.delete(db_experience)
    await db.commit()
    
    return None


@router.post("/{experience_id}/toggle-featured", response_model=schemas.Experience)
async def toggle_featured(
    experience_id: str,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    """Toggle the featured status of an experience"""
    stmt = select(models.Experience).filter(
        models.Experience.id == experience_id,
        models.Experience.user_id == current_user.id
    )
    result = await db.execute(stmt)
    db_experience = result.scalars().first()
    
    if not db_experience:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Experience not found"
        )
    
    db_experience.is_featured = not db_experience.is_featured
    await db.commit()
    await db.refresh(db_experience)
    
    return db_experience
