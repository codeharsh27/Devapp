# Authentication & Onboarding Implementation Guide

## Overview
This document outlines the implementation of the new Developer Authentication and Onboarding flow using Supabase.

## Flow
1. **User Entry**: User clicks "Join as Developer" on Landing Page -> Redirects to `/auth?view=signup`.
2. **Authentication**:
   - New Users: Sign up via Email/Password or OAuth (GitHub).
   - Existing Users: Log in via `/auth`.
3. **Post-Auth Routing**:
   - If Email Confirmation enabled: User clicks link -> `/auth/callback` -> `/dashboard`.
   - If Email Confirmation disabled: User -> `/onboarding` (for new signups) or `/dashboard` (for logins).
4. **Dashboard Access**:
   - Accessing `/dashboard`:
     - Checks if user is authenticated (Middleware).
     - Checks if user profile exists (Server Component).
     - If no profile -> Redirect to `/onboarding`.
     - If profile exists -> Redirect to `/dashboard/talent`.

## Folder Structure
```
app/
├── auth/
│   ├── callback/
│   │   └── route.ts       # OAuth Callback Handler
│   ├── forgot-password/
│   │   └── route.tsx      # Password Reset Request
│   ├── update-password/
│   │   └── route.tsx      # Set New Password
│   └── page.tsx           # Login / Signup UI
├── onboarding/
│   └── page.tsx           # Multi-step Profile Form
├── dashboard/
│   └── page.tsx           # Route Guard & Redirector
lib/
└── supabase/
    ├── client.ts          # Browser Client
    ├── server.ts          # Server Client (Cookies)
    └── middleware.ts      # Middleware Helper
middleware.ts              # Route Protection
```

## Database Schema
The `profiles` table is setup with RLS policies to ensure users can only edit their own data.
See `supabase/schema.sql` for the full SQL.

## Security
- **Middleware**: Protects all `/dashboard` routes from unauthenticated access.
- **RLS**: Database policies prevent unauthorized data access.
- **Server-Side Checks**: Vital logic (like profile existence) is verified on the server before rendering the dashboard.

## Next Steps
1. Run the SQL in `supabase/schema.sql` in your Supabase SQL Editor.
2. Enable Email Auth and GitHub Auth in Supabase Dashboard.
3. Configure Redirect URLs in Supabase Authentication settings to include `[your-domain]/auth/callback`.
