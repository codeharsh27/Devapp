from fastapi import FastAPI, Depends, HTTPException, status, BackgroundTasks
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import List
import asyncio
import random
from jose import JWTError, jwt
from datetime import datetime
from . import models, database, schemas, auth


models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(
    title="DevApp API",
    description="Backend for DevApp - Talent Execution Network",
    version="0.1.0",
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# Dependency
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        # ROBUST AUTH: Verify using Supabase's Public Keys (JWKS)
        # This handles key rotation and algorithm changes (HS256 vs ES256) automatically.
        
        # 1. Fetch JWKS
        import urllib.request
        import json
        
        SUPABASE_URL = "https://ntrubhipkhaoasqqkozu.supabase.co"
        jwks_url = f"{SUPABASE_URL}/auth/v1/.well-known/jwks.json"
        
        with urllib.request.urlopen(jwks_url) as response:
            jwks = json.loads(response.read())
            
        # 2. Decode & Verify
        # python-jose automatically finds the correct key from JWKS if we pass it correctly
        # or we might need to find the key matching the header 'kid'.
        
        header = jwt.get_unverified_header(token)
        rsa_key = {}
        for key in jwks["keys"]:
            if key["kid"] == header["kid"]:
                rsa_key = key
                break
                
        if not rsa_key:
             print("DEBUG: No matching key found in JWKS")
             raise credentials_exception

        payload = jwt.decode(
            token,
            rsa_key,
            algorithms=[header["alg"]], # Trust the header's alg (e.g., ES256)
            audience="authenticated"
        )

        user_id: str = payload.get("sub")
        email: str = payload.get("email")
        
        if user_id is None:
             raise credentials_exception
            
    except Exception as e:
        print(f"DEBUG: Auth Error: {e}")
        raise credentials_exception
    
    # Lazy Sync: Check if user exists in our local DB
    user = db.query(models.User).filter(models.User.id == user_id).first()
    
    if not user:
        # Create user (Upsert-ish)
        user = models.User(id=user_id, email=email)
        db.add(user)
        db.commit()
        db.refresh(user)
    elif user.email != email:
        # Update email if changed in Supabase
        user.email = email
    return user

@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "DevApp Backend"}

@app.get("/")
async def root():
    return {"message": "Welcome to DevApp API"}
    
@app.get("/users/me", response_model=schemas.User)
async def read_users_me(current_user: models.User = Depends(get_current_user)):
    return current_user

# --- DROPS APIs ---

@app.get("/drops", response_model=List[schemas.Drop])
async def get_drops(db: Session = Depends(get_db)):
    """
    Fetch all available drops.
    """
    drops = db.query(models.Drop).all()
    return drops

# --- SUBMISSION APIs ---

async def mock_evaluate_submission(submission_id: int):
    print(f"DEBUG: Starting evaluation for {submission_id}...")
    """
    Simulates a time-consuming evaluation process (e.g. running unit tests via Docker).
    """
    await asyncio.sleep(5) # Simulate processing time
    
    # Randomly assign pass/fail and score
    # In a real app, this would read from the worker result
    score = random.randint(0, 100)
    status = models.SubmissionStatus.COMPLETED
    feedback = "Automated tests passed."
    
    if score < 50:
        status = models.SubmissionStatus.FAILED
        feedback = "Automated tests failed. Check edge cases."
        
    # We need a new session heavily because of async threading in real apps, 
    # but for simple BackgroundTasks in FastAPI with sync DB driver, 
    # we must be careful. Here we re-query to get a fresh object bound to current session.
    # Note: passing 'db' session across async boundaries can be risky.
    # Better to create a new session here usually.
    
    # For this walking skeleton, we'll try to reuse or just simpler:
    # Logic: update DB
    
    # Re-instantiate session for the background task to be safe
    new_db = database.SessionLocal()
    try:
        submission = new_db.query(models.Submission).filter(models.Submission.id == submission_id).first()
        if submission:
            submission.score = score
            submission.status = status
            submission.feedback = feedback
            submission.completed_at = datetime.utcnow()
            new_db.commit()
            print(f"Evaluated Submission {submission_id}: Score {score}")
    finally:
        new_db.close()


@app.post("/submit", response_model=schemas.Submission)
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
    
    # Use current_user.id instead of submission.user_id
    
    db_submission = models.Submission(
        user_id=current_user.id,
        drop_id=submission.drop_id,
        submission_url=submission.submission_url,
        doc_url=submission.doc_url,
        image_url=submission.image_url,
        status=models.SubmissionStatus.EVALUATING # Set to evaluating immediately for this mock
    )
    
    db.add(db_submission)
    db.commit()
    db.refresh(db_submission)
    
    # Trigger background evaluation
    background_tasks.add_task(mock_evaluate_submission, db_submission.id)
    
    return db_submission

@app.get("/submissions/{submission_id}", response_model=schemas.Submission)
async def get_submission(submission_id: int, db: Session = Depends(get_db)):
    """
    Get the status and details of a specific submission.
    """
    submission = db.query(models.Submission).filter(models.Submission.id == submission_id).first()
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
    return submission

# --- USER APIs ---

@app.get("/users/{user_id}", response_model=schemas.User)
async def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.get("/users/me/stats", response_model=schemas.UserStats)
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
        total_xp=total_xp,
        level=level,
        completed_drops=completed_count,
        rank=rank
    )

# --- UTILS ---

@app.post("/seed")
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
