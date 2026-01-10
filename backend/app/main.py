from fastapi import FastAPI
from . import models, database
from .routers import users, drops, submissions

# Create DB Tables
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI(
    title="DevApp API",
    description="Backend for DevApp - Talent Execution Network",
    version="0.2.0-refactored",
)

# Include Routers
app.include_router(users.router)
app.include_router(drops.router)
app.include_router(submissions.router)

@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "DevApp Backend"}

@app.get("/")
async def root():
    return {"message": "Welcome to DevApp API"}
