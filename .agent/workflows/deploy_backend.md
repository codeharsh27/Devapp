---
description: Deploy the backend using Docker Compose
---
# Backend Deployment Workflow

This workflow describes how to build and deploy the backend services including the FastAPI app, PostgreSQL database, and Redis (optional).

## Prerequisites
- Docker and Docker Compose installed.
- `.env` file configured in `backend/` with production values.

## Steps

1. **Verify Environment Variables**
   Ensure `backend/.env` contains the following (make sure `DATABASE_URL` matches the docker service name if running in compose, or external DB):
   ```
   DATABASE_URL=postgresql+asyncpg://devapp:devapp_password@db:5432/devapp
   SECRET_KEY=<your_production_secret>
   SUPABASE_URL=<your_supabase_url>
   SUPABASE_KEY=<your_supabase_key>
   AUTH_MODE=supabase
   SENTRY_DSN=<your_sentry_backend_dsn>
   ```

2. **Build and Run (Turbo)**
   Navigate to the backend directory and run docker-compose.
   ```bash
   cd backend
   docker-compose up --build -d
   ```

3. **Verify Migrations**
   The container is configured to run `alembic upgrade head` on startup. check logs:
   ```bash
   docker-compose logs -f backend
   ```

4. **Health Check**
   Visit `http://localhost:8000/health` to verify the service is running.

## Mobile Build

1. **Configure Sentry**
   Update `mobile/lib/core/config/sentry_config.dart` with your Mobile DSN.

2. **Build Release APK**
   ```bash
   cd mobile
   flutter build apk --release
   ```
