from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from . import models
from app.core import database
from .routers import users, drops, submissions, ws, auth, experiences

# Create DB Tables
# models.Base.metadata.create_all(bind=database.engine)

from app.core.config import settings
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

from app.core.exceptions import setup_exception_handlers
setup_exception_handlers(app)

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
app.include_router(experiences.router)
app.include_router(ws.router)

from app.domains.tasks.router import router as tasks_router
from app.domains.submissions.router import router as submissions_router
app.include_router(tasks_router)
app.include_router(submissions_router)
from app.domains.chat.router import router as chat_router
app.include_router(chat_router)


@app.get("/health")
async def health_check():
    return {"status": "ok", "service": "DevApp Backend"}

@app.get("/")
async def root():
    return {"message": "Welcome to DevApp API"}
