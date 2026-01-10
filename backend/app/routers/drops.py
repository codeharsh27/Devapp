from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
from typing import List
from .. import models, schemas
from ..dependencies import get_db

router = APIRouter(
    prefix="/drops",
    tags=["drops"],
    responses={404: {"description": "Not found"}},
)

@router.get("", response_model=List[schemas.Drop])
async def get_drops(db: Session = Depends(get_db)):
    """
    Fetch all available drops.
    """
    drops = db.query(models.Drop).all()
    return drops

@router.post("/sync-github")
async def sync_github_source(background_tasks: BackgroundTasks):
    """
    Triggers a background task to fetch and sync GitHub 'good first issues' as drops.
    """
    from ..services import github_service
    background_tasks.add_task(github_service.sync_github_drops)
    return {"message": "GitHub sync started in background"}

@router.post("/seed")
async def seed_database(db: Session = Depends(get_db)):
    """
    Dev utility to seed the database with initial drops.
    """
    if db.query(models.Drop).first():
        return {"message": "Database already seeded"}
    
    seeds = [
        models.Drop(
            title="Implement JWT Auth",
            description="Create a secure authentication system using JSON Web Tokens. Handle token generation, validation, and refresh flow.",
            domain="backend",
            difficulty=models.DifficultyLevel.MEDIUM,
            time_limit_minutes=120,
            reward_xp=500,
            inputs_url="https://github.com/devapp-corp/challenge-jwt-auth"
        ),
        models.Drop(
            title="React Infinite Scroll",
            description="Build a performant infinite scroll component in React that fetches data from an API. Must handle loading states and error boundaries.",
            domain="frontend",
            difficulty=models.DifficultyLevel.EASY,
            time_limit_minutes=60,
            reward_xp=300,
            inputs_url="https://github.com/devapp-corp/challenge-infinite-scroll"
        ),
        models.Drop(
            title="Optimize SQL Query",
            description="Given a slow query and a rigorous dataset, optimize the indexes and query structure to reduce execution time by 90%.",
            domain="backend",
            difficulty=models.DifficultyLevel.HARD,
            time_limit_minutes=45,
            reward_xp=800,
            inputs_url="https://github.com/devapp-corp/challenge-sql-opt"
        ),
    ]
    
    db.add_all(seeds)
    db.commit()
    return {"message": "Seeded 3 drops"}
