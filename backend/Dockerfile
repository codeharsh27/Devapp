# ============================================================
# Stage 1 — Build wheels (keeps final image small)
# ============================================================
FROM python:3.11-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /build

# System deps needed to compile native extensions (asyncpg, psycopg2-binary)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY backend/requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /build/wheels -r requirements.txt

# ============================================================
# Stage 2 — Lean runtime image
# ============================================================
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Runtime system dependency for asyncpg / psycopg2
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev curl && \
    rm -rf /var/lib/apt/lists/*

# Install pre-built wheels
COPY --from=builder /build/wheels /wheels
RUN pip install --no-cache /wheels/*

# Copy ONLY the backend source code (not mobile, web, docs, etc.)
COPY backend/ .

# Non-root user for security
RUN addgroup --system app && adduser --system --group app
USER app

# Railway assigns $PORT dynamically — expose a default for local dev only
EXPOSE 8000

# Healthcheck uses $PORT so it matches whatever Railway binds to
# Note: HEALTHCHECK in Dockerfile is a fallback; Railway uses its own probe via railway.toml
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s --retries=5 \
    CMD curl -f http://localhost:${PORT:-8000}/health || exit 1

# CMD is overridden by railway.toml startCommand which uses $PORT
# This fallback is for local docker run
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
