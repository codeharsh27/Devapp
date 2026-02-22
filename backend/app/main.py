from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from . import models, database
from .routers import users, drops, submissions, ws, auth, inbox, experiences

# Create DB Tables
# models.Base.metadata.create_all(bind=database.engine)

from .config import settings
import sentry_sdk

# Initialize Sentry if DSN is configured
if settings.SENTRY_DSN:
    sentry_sdk.init(
        dsn=settings.SENTRY_DSN,
        # 10% of transactions captured — sufficient for production monitoring.
        # Increase temporarily when debugging a specific issue.
        traces_sample_rate=0.1,
        profiles_sample_rate=0.1,
    )

app = FastAPI(
    title="DevApp API",
    description="Backend for DevApp - Talent Execution Network",
    version="0.2.0-refactored",
)

# CORS Configuration
# In production, this must be restricted to real domains
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(auth.router, prefix="/auth")
app.include_router(users.router)
app.include_router(drops.router)
app.include_router(submissions.router)
app.include_router(inbox.router)
app.include_router(experiences.router)
app.include_router(ws.router)


@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "DevApp Backend"}

@app.get("/")
async def root():
    return {"message": "Welcome to DevApp API"}
