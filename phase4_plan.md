# Phase 4 Implementation Plan: Authentication & Security

This phase focuses on securing the application by implementing proper User Authentication (Login/Signup) using JWT (JSON Web Tokens) on the backend and secure token management on the mobile app.

## 1. Backend Implementation (FastAPI)

### Dependencies
- Add verified security libraries: `passlib[bcrypt]`, `python-jose[cryptography]`, `python-multipart`.

### Auth Utilities (`app/auth.py`)
- Implement `verify_password(plain, hashed)` and `get_password_hash(password)`.
- Implement `create_access_token(data, expires)` for JWT generation.

### Schemas (`app/schemas.py`)
- Add `UserCreate` (email, password).
- Add `Token` (access_token, token_type).
- Add `TokenData` (username/email).

### API Endpoints (`app/main.py` & `app/routers/auth.py`)
- `POST /register`: Register a new user.
- `POST /token`: Login endpoint (OAuth2PasswordRequestForm) -> returns JWT.
- `GET /users/me`: Get current user profile (Protected).

### Security Dependency
- Create `get_current_user` dependency that:
    1. Extracts JWT from `Authorization` header.
    2. Decodes and validates token.
    3. Fetches user from DB.
- Protect existing endpoints:
    - `POST /submit` (was using hardcoded user_id).
    - `GET /users/{id}/stats` -> change to `GET /users/me/stats`.

---

## 2. Mobile Implementation (Flutter)

### Dependencies
- `flutter_secure_storage`: For storing JWT securely on the device.
- `jwt_decoder`: To check token expiration helper (optional, or manual check).

### Architecture Changes
- **AuthRepository**: Interact with `/register` and `/token` endpoints.
- **AuthNotifier (Riverpod)**:
    - Manage state: `AuthStatus` (initial, authenticated, unauthenticated).
    - Methods: `login(email, password)`, `register(email, password)`, `logout()`.
    - Auto-login on app start by reading stored token.

### Network Layer
- **Dio Interceptor**: Create an interceptor that automatically adds `Authorization: Bearer <token>` to every request if a token exists.

### UI Components
- **LoginPage**: Email/Password fields, "Login" button, Link to Signup.
- **SignupPage**: Email/Password fields, "Create Account" button.
- **Splash/Loading Screen**: While checking for stored token on startup.

### Routing (`router.dart`)
- Implement a `redirect` logic in GoRouter:
    - If NOT logged in -> Redirect to `/login`.
    - If logged in & on Login/Signup page -> Redirect to `/` (Home).

## 3. Migration
- Remove all hardcoded `user_id = 123` references.
- Test full flow: Signup -> Login -> Submit Drop (Authenticated) -> View Profile (Authenticated).
