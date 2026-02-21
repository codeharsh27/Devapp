# 🎯 DevApp - Drops Feature: Complete System Documentation

## Overview

**Drops** are the core content unit in DevApp - think of them as "micro-missions" or "challenges" that developers can complete to earn XP and level up. The system sources Drops from two primary pipelines:

1. **Source A (Internal)** - Curated challenges created by the DevApp team
2. **Source B (GitHub)** - Automatically synced "Good First Issues" from popular open-source repositories

---

## 📊 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              CONTENT SOURCES                                     │
├──────────────────────────────────┬──────────────────────────────────────────────┤
│                                  │                                              │
│   📝 SOURCE A (Internal)         │   🐙 SOURCE B (GitHub Open Source)           │
│   ──────────────────────         │   ────────────────────────────────           │
│   • Admin/Seed Database          │   • GitHub Search API                        │
│   • POST /drops/seed             │   • POST /drops/sync-github                  │
│   • Curated challenges           │   • "Good First Issues" from                 │
│                                  │     repos with 1000+ stars                   │
│                                  │                                              │
└──────────────────────────────────┴──────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              CONTENT PROCESSING                                  │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   🔄 GITHUB SYNC SERVICE (github_service.py)                                    │
│   ──────────────────────────────────────────                                    │
│                                                                                 │
│   1. Query GitHub API for issues with labels:                                   │
│      • "good first issue" + no assignee + stars>1000                            │
│      • Excludes: docs, readme, typo, translation tasks                          │
│                                                                                 │
│   2. Languages Supported:                                                       │
│      Python, JavaScript, TypeScript, Java, C++, C, Go, Kotlin, Swift,          │
│      Rust, Dart                                                                 │
│                                                                                 │
│   3. Domain Mapping:                                                            │
│      ┌────────────────────┐    ┌────────────────────┐                          │
│      │ JS/TS/React/Vue    │───▶│ Frontend           │                          │
│      │ Flutter/Dart/Kotlin│───▶│ Mobile             │                          │
│      │ Python/Java/Go/Rust│───▶│ Backend            │                          │
│      │ ML/AI              │───▶│ AI                 │                          │
│      └────────────────────┘    └────────────────────┘                          │
│                                                                                 │
│   4. Content Cleaning:                                                          │
│      • Remove HTML comments                                                     │
│      • Add source attribution                                                   │
│      • Skip short/junk descriptions                                             │
│                                                                                 │
│   5. Freshness Management:                                                      │
│      • Auto-expire Source B drops after 7 days                                  │
│      • Keep content pipeline fresh and relevant                                 │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              DATABASE (PostgreSQL)                               │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   📦 DROPS TABLE                                                                │
│   ──────────────────                                                            │
│   ┌─────────────────────────────────────────────────────────────────────────┐  │
│   │ id              │ Primary Key, Auto Increment                           │  │
│   │ title           │ "Implement JWT Auth"                                  │  │
│   │ description     │ Full challenge description                            │  │
│   │ domain          │ "backend" | "frontend" | "mobile" | "ai"              │  │
│   │ difficulty      │ EASY | MEDIUM | HARD                                  │  │
│   │ submission_type │ CODE | LINK | IMAGE | FILE                            │  │
│   │ time_limit_mins │ 60, 120, 180...                                       │  │
│   │ reward_xp       │ 50, 100, 300, 500, 800...                             │  │
│   │ inputs_url      │ Link to starter resources                             │  │
│   │ source_url      │ GitHub issue link (Source B)                          │  │
│   │ source_type     │ "A" (Internal) | "B" (GitHub)                         │  │
│   │ created_at      │ Timestamp                                             │  │
│   └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              API LAYER (FastAPI)                                 │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   🌐 DROPS ROUTER (/drops)                                                      │
│   ────────────────────────                                                      │
│                                                                                 │
│   GET  /drops              → Fetch all available drops                          │
│   POST /drops/{id}/deploy  → Send mission intel to user's email                 │
│   POST /drops/sync-github  → Trigger GitHub sync (background task)              │
│   POST /drops/seed         → Seed database with initial drops                   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              MOBILE APP (Flutter)                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│   📱 DATA LAYER                                                                 │
│   ─────────────                                                                 │
│   DropsRepository (Riverpod)                                                    │
│   ├── getDrops()          → List<Drop>                                          │
│   ├── getSubmission()     → Submission                                          │
│   ├── submitDrop()        → Submit solution                                     │
│   └── deployDrop()        → Request mission intel                               │
│                                                                                 │
│   📱 PRESENTATION LAYER                                                         │
│   ─────────────────────                                                         │
│   DropsListProvider (Riverpod)                                                  │
│   ├── Fetches drops from repository                                             │
│   ├── Handles loading/error states                                              │
│   └── Provides reactive state to UI                                             │
│                                                                                 │
│   📱 UI LAYER (HomePage)                                                        │
│   ──────────────────────                                                        │
│   ┌──────────────────────────────────────────────┐                             │
│   │  ┌────────────────────────────────────────┐  │                             │
│   │  │       🔍 SEARCH BAR                    │  │                             │
│   │  └────────────────────────────────────────┘  │                             │
│   │                                              │                             │
│   │  ┌──────────────────────────────────────────┐│                             │
│   │  │  FILTER CHIPS                            ││                             │
│   │  │  [All] [Frontend] [Backend] [Mobile] ... ││                             │
│   │  └──────────────────────────────────────────┘│                             │
│   │                                              │                             │
│   │  ┌──────────────────────────────────────────┐│                             │
│   │  │  DROP CARD                               ││                             │
│   │  │  ┌────────────────────────────────────┐  ││                             │
│   │  │  │ 🎯 Implement JWT Auth              │  ││                             │
│   │  │  │ Domain: Backend  │ Difficulty: Med │  ││                             │
│   │  │  │ XP: 500  │ Time: 120 mins         │  ││                             │
│   │  │  └────────────────────────────────────┘  ││                             │
│   │  └──────────────────────────────────────────┘│                             │
│   │                                              │                             │
│   │  ┌──────────────────────────────────────────┐│                             │
│   │  │  DROP CARD                               ││                             │
│   │  │  ┌────────────────────────────────────┐  ││                             │
│   │  │  │ 🐙 Fix pagination in React app     │  ││                             │
│   │  │  │ Domain: Frontend │ Source: GitHub  │  ││                             │
│   │  │  └────────────────────────────────────┘  ││                             │
│   │  └──────────────────────────────────────────┘│                             │
│   └──────────────────────────────────────────────┘                             │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Complete Data Flow: From Source to User Feed

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│  STEP 1: CONTENT SOURCING                                                       │
│  ─────────────────────────                                                      │
│                                                                                 │
│  ┌─────────────────┐         ┌─────────────────────────────────────────────┐   │
│  │   GitHub API    │────────▶│  sync_github_drops()                        │   │
│  │  Search Issues  │         │  ├── Query: "good first issue" + filters   │   │
│  └─────────────────┘         │  ├── languages: Python, JS, TS, etc.        │   │
│                              │  ├── stars > 1000                           │   │
│                              │  └── Exclude: docs, typos, translations     │   │
│                              └─────────────────────────────────────────────┘   │
│                                              │                                  │
│                                              ▼                                  │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  FILTERING & TRANSFORMATION                                              │   │
│  │  ──────────────────────────                                              │   │
│  │                                                                          │   │
│  │  For each GitHub Issue:                                                  │   │
│  │    ┌───────────────────────────────────────────────────────────────┐    │   │
│  │    │ 1. Extract: title, body, labels, URL                         │    │   │
│  │    │ 2. Filter: Skip if title contains readme/typo/docs           │    │   │
│  │    │ 3. Map Domain: javascript→frontend, python→backend, etc.     │    │   │
│  │    │ 4. Clean Body: Remove HTML comments, add source attribution  │    │   │
│  │    │ 5. Validate: Skip if description < 50 chars                  │    │   │
│  │    │ 6. Deduplicate: Check if source_url already exists           │    │   │
│  │    └───────────────────────────────────────────────────────────────┘    │   │
│  │                                                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                              │                                  │
│                                              ▼                                  │
│                                                                                 │
│  STEP 2: STORAGE                                                                │
│  ───────────────                                                                │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                          PostgreSQL Database                             │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │                         DROPS TABLE                                │  │   │
│  │  ├───────────────────────────────────────────────────────────────────┤  │   │
│  │  │ ID │ Title              │ Domain   │ Source │ Difficulty │ XP    │  │   │
│  │  ├────┼────────────────────┼──────────┼────────┼────────────┼───────┤  │   │
│  │  │ 1  │ Implement JWT Auth │ backend  │   A    │   MEDIUM   │  500  │  │   │
│  │  │ 2  │ React Infinite Scr │ frontend │   A    │   EASY     │  300  │  │   │
│  │  │ 3  │ Fix pagination bug │ frontend │   B    │   EASY     │   50  │  │   │
│  │  │ 4  │ Add dark mode      │ mobile   │   B    │   EASY     │   50  │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                              │                                  │
│                                              ▼                                  │
│                                                                                 │
│  STEP 3: API SERVES CONTENT                                                     │
│  ──────────────────────────                                                     │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  FastAPI Backend                                                         │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐  │   │
│  │  │  GET /drops                                                        │  │   │
│  │  │  ─────────────                                                     │  │   │
│  │  │  @router.get("", response_model=List[schemas.Drop])                │  │   │
│  │  │  async def get_drops(db: Session):                                 │  │   │
│  │  │      drops = db.query(models.Drop).all()                           │  │   │
│  │  │      return drops                                                  │  │   │
│  │  └───────────────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                              │                                  │
│                                              ▼                                  │
│                                                                                 │
│  STEP 4: MOBILE APP FETCHES & DISPLAYS                                          │
│  ─────────────────────────────────────                                          │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                                                                          │   │
│  │  ┌─────────────────────┐      ┌─────────────────────┐                   │   │
│  │  │  DropsRepository    │─────▶│  DropsListProvider  │                   │   │
│  │  │  ─────────────────  │      │  ──────────────────  │                   │   │
│  │  │  getDrops() {       │      │  build() {          │                   │   │
│  │  │    response = await │      │    return ref.watch │                   │   │
│  │  │    dio.get('/drops')│      │    (dropsRepository │                   │   │
│  │  │    return drops     │      │    .notifier)       │                   │   │
│  │  │  }                  │      │    .getDrops();     │                   │   │
│  │  └─────────────────────┘      └─────────────────────┘                   │   │
│  │                                         │                                │   │
│  │                                         ▼                                │   │
│  │  ┌─────────────────────────────────────────────────────────────────┐    │   │
│  │  │                         HomePage (UI)                            │    │   │
│  │  │  ───────────────────────────────────────────────────────────     │    │   │
│  │  │                                                                  │    │   │
│  │  │  Consumer Widget watches DropsListProvider:                      │    │   │
│  │  │                                                                  │    │   │
│  │  │  dropsAsync.when(                                                │    │   │
│  │  │    data: (drops) => ListView.builder(                            │    │   │
│  │  │      itemBuilder: (ctx, i) => DropCard(drop: drops[i])           │    │   │
│  │  │    ),                                                            │    │   │
│  │  │    loading: () => CircularProgressIndicator(),                   │    │   │
│  │  │    error: (e, st) => ErrorWidget(e)                              │    │   │
│  │  │  )                                                               │    │   │
│  │  └─────────────────────────────────────────────────────────────────┘    │   │
│  │                                                                          │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🎮 User Interaction Flow: Accepting & Completing a Drop

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│  PHASE 1: DISCOVERY & SELECTION                                                 │
│  ──────────────────────────────                                                 │
│                                                                                 │
│   ┌───────────────┐                                                             │
│   │   User opens  │                                                             │
│   │   HomePage    │                                                             │
│   └───────┬───────┘                                                             │
│           │                                                                     │
│           ▼                                                                     │
│   ┌───────────────────────────────────────────────────────────────────────┐    │
│   │                      FILTERING OPTIONS                                 │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │  🔍 Search: "JWT" / "React" / "pagination"                  │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   │                                                                        │    │
│   │   ┌───────────────────────────────────────────────────────────────┐   │    │
│   │   │  Domain Filters:                                               │   │    │
│   │   │  ┌─────┐ ┌──────────┐ ┌─────────┐ ┌────────┐ ┌────┐          │   │    │
│   │   │  │ All │ │ Frontend │ │ Backend │ │ Mobile │ │ AI │          │   │    │
│   │   │  └─────┘ └──────────┘ └─────────┘ └────────┘ └────┘          │   │    │
│   │   └───────────────────────────────────────────────────────────────┘   │    │
│   │                                                                        │    │
│   │   ┌───────────────────────────────────────────────────────────────┐   │    │
│   │   │  Sort Options:                                                 │   │    │
│   │   │  • Newest First (default)                                      │   │    │
│   │   │  • Highest XP                                                  │   │    │
│   │   │  • Difficulty (Easy → Hard)                                    │   │    │
│   │   │  • Time Limit                                                  │   │    │
│   │   └───────────────────────────────────────────────────────────────┘   │    │
│   └───────────────────────────────────────────────────────────────────────┘    │
│           │                                                                     │
│           ▼                                                                     │
│   ┌───────────────────────────────────────────────────────────────────────┐    │
│   │                      FILTERED DROP LIST                                │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │  DropCard 1: Implement JWT Auth                              │     │    │
│   │   │  [Backend] [Medium] [500 XP] [120 min]                       │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │  DropCard 2: Fix React pagination                           │     │    │
│   │   │  [Frontend] [Easy] [50 XP] [60 min] [GitHub Issue]          │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   └───────────────────────────────────────────────────────────────────────┘    │
│           │                                                                     │
│           │ User taps on Drop Card                                              │
│           ▼                                                                     │
│                                                                                 │
│  PHASE 2: DROP DETAIL & ACCEPTANCE                                              │
│  ─────────────────────────────────                                              │
│                                                                                 │
│   ┌───────────────────────────────────────────────────────────────────────┐    │
│   │                      DROP DETAIL PAGE                                  │    │
│   │  ┌─────────────────────────────────────────────────────────────────┐  │    │
│   │  │  📌 Mission Briefing: Implement JWT Auth                        │  │    │
│   │  │  ──────────────────────────────────────                         │  │    │
│   │  │                                                                  │  │    │
│   │  │  OBJECTIVE:                                                      │  │    │
│   │  │  Create a secure authentication system using JSON Web Tokens.   │  │    │
│   │  │  Handle token generation, validation, and refresh flow.         │  │    │
│   │  │                                                                  │  │    │
│   │  │  ┌────────────────────────────────────────────────────────────┐ │  │    │
│   │  │  │  Domain: Backend    │  Difficulty: Medium                  │ │  │    │
│   │  │  │  Time Limit: 120min │  Reward: 500 XP                      │ │  │    │
│   │  │  │  Type: Code Submission                                     │ │  │    │
│   │  │  └────────────────────────────────────────────────────────────┘ │  │    │
│   │  │                                                                  │  │    │
│   │  │  ┌──────────────────────────────────────────────────────────┐   │  │    │
│   │  │  │  🚀 ACCEPT MISSION                                        │   │  │    │
│   │  │  └──────────────────────────────────────────────────────────┘   │  │    │
│   │  │                                                                  │  │    │
│   │  │  ┌──────────────────────────────────────────────────────────┐   │  │    │
│   │  │  │  📧 DEPLOY INTEL (Send resources via email)              │   │  │    │
│   │  │  └──────────────────────────────────────────────────────────┘   │  │    │
│   │  └─────────────────────────────────────────────────────────────────┘  │    │
│   └───────────────────────────────────────────────────────────────────────┘    │
│           │                                                                     │
│           │ User clicks "Accept Mission"                                        │
│           ▼                                                                     │
│                                                                                 │
│  PHASE 3: ACTIVE EXECUTION                                                      │
│  ─────────────────────────                                                      │
│                                                                                 │
│   ┌───────────────────────────────────────────────────────────────────────┐    │
│   │                      ACTIVE EXECUTION PAGE                             │    │
│   │  ┌─────────────────────────────────────────────────────────────────┐  │    │
│   │  │                                                                  │  │    │
│   │  │    ⏱️ TIME REMAINING: 01:45:32                                   │  │    │
│   │  │    ═══════════════════════════════════▒▒▒▒▒                     │  │    │
│   │  │                                                                  │  │    │
│   │  │    📋 MISSION: Implement JWT Auth                                │  │    │
│   │  │                                                                  │  │    │
│   │  │    ┌───────────────────────────────────────────────────────┐    │  │    │
│   │  │    │  🔗 Resources:                                         │    │  │    │
│   │  │    │  github.com/devapp-corp/challenge-jwt-auth             │    │  │    │
│   │  │    └───────────────────────────────────────────────────────┘    │  │    │
│   │  │                                                                  │  │    │
│   │  │    ──────────────────────────────────────────────────────────   │  │    │
│   │  │    User works on the solution externally...                     │  │    │
│   │  │    ──────────────────────────────────────────────────────────   │  │    │
│   │  │                                                                  │  │    │
│   │  │    ┌───────────────────────────────────────────────────────┐    │  │    │
│   │  │    │  📤 Submit Solution                                    │    │  │    │
│   │  │    │                                                        │    │  │    │
│   │  │    │  GitHub URL: [github.com/user/jwt-solution_______]    │    │  │    │
│   │  │    │  Docs URL:   [________________] (optional)            │    │  │    │
│   │  │    │                                                        │    │  │    │
│   │  │    │         [🚀 SUBMIT]                                    │    │  │    │
│   │  │    └───────────────────────────────────────────────────────┘    │  │    │
│   │  │                                                                  │  │    │
│   │  └─────────────────────────────────────────────────────────────────┘  │    │
│   └───────────────────────────────────────────────────────────────────────┘    │
│           │                                                                     │
│           │ User submits solution                                               │
│           ▼                                                                     │
│                                                                                 │
│  PHASE 4: EVALUATION & REWARD                                                   │
│  ────────────────────────────                                                   │
│                                                                                 │
│   ┌───────────────────────────────────────────────────────────────────────┐    │
│   │                      SUBMISSION FLOW                                   │    │
│   │                                                                        │    │
│   │   POST /submit                                                         │    │
│   │   ──────────────                                                       │    │
│   │                                                                        │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │  1. Validate drop exists                                     │     │    │
│   │   │  2. Create Submission record (status: EVALUATING)            │     │    │
│   │   │  3. Trigger background evaluation task                       │     │    │
│   │   │  4. Return submission ID immediately                         │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   │                         │                                              │    │
│   │                         ▼                                              │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │              BACKGROUND EVALUATION                           │     │    │
│   │   │  ─────────────────────────────────                           │     │    │
│   │   │                                                              │     │    │
│   │   │  evaluation_service.py                                       │     │    │
│   │   │                                                              │     │    │
│   │   │  For GitHub submissions:                                     │     │    │
│   │   │  ┌────────────────────────────────────────────────────────┐ │     │    │
│   │   │  │  1. Parse GitHub URL → extract owner/repo              │ │     │    │
│   │   │  │  2. Call GitHub API to verify repo exists              │ │     │    │
│   │   │  │  3. Score based on:                                    │ │     │    │
│   │   │  │     • Base: 60 pts (repo exists)                       │ │     │    │
│   │   │  │     • +10 pts: Recent activity (2024-2026)             │ │     │    │
│   │   │  │     • +5 pts: Has description                          │ │     │    │
│   │   │  │     • +10 pts: Has code content                        │ │     │    │
│   │   │  │     • +15 pts: Has README.md                           │ │     │    │
│   │   │  │  4. Pass if score >= 50                                │ │     │    │
│   │   │  └────────────────────────────────────────────────────────┘ │     │    │
│   │   │                                                              │     │    │
│   │   │  For other submissions (Figma, Links):                       │     │    │
│   │   │  ┌────────────────────────────────────────────────────────┐ │     │    │
│   │   │  │  • Valid URL present: 70 pts                           │ │     │    │
│   │   │  │  • "Manual review pending for higher score"            │ │     │    │
│   │   │  └────────────────────────────────────────────────────────┘ │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   │                         │                                              │    │
│   │                         ▼                                              │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │              IF PASSED (score >= 50)                         │     │    │
│   │   │  ─────────────────────────────────                           │     │    │
│   │   │                                                              │     │    │
│   │   │  ┌────────────────────────────────────────────────────────┐ │     │    │
│   │   │  │  GAMIFICATION UPDATE:                                  │ │     │    │
│   │   │  │                                                        │ │     │    │
│   │   │  │  user.total_xp += drop.reward_xp                       │ │     │    │
│   │   │  │                                                        │ │     │    │
│   │   │  │  # Domain-specific XP                                  │ │     │    │
│   │   │  │  xp_breakdown[drop.domain] += drop.reward_xp           │ │     │    │
│   │   │  │                                                        │ │     │    │
│   │   │  │  # Level up (1000 XP per level)                        │ │     │    │
│   │   │  │  user.level = (total_xp / 1000) + 1                    │ │     │    │
│   │   │  └────────────────────────────────────────────────────────┘ │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   │                         │                                              │    │
│   │                         ▼                                              │    │
│   │   ┌─────────────────────────────────────────────────────────────┐     │    │
│   │   │              WEBSOCKET NOTIFICATION                          │     │    │
│   │   │  ─────────────────────────────────                           │     │    │
│   │   │                                                              │     │    │
│   │   │  Real-time push to user's device:                            │     │    │
│   │   │  {                                                           │     │    │
│   │   │    "type": "submission_update",                              │     │    │
│   │   │    "data": {                                                 │     │    │
│   │   │      "id": 42,                                               │     │    │
│   │   │      "status": "completed",                                  │     │    │
│   │   │      "score": 85,                                            │     │    │
│   │   │      "drop_title": "Implement JWT Auth"                      │     │    │
│   │   │    }                                                         │     │    │
│   │   │  }                                                           │     │    │
│   │   └─────────────────────────────────────────────────────────────┘     │    │
│   └───────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🗃️ Data Models Reference

### Drop Model (Backend)

```python
class Drop(Base):
    __tablename__ = "drops"
    
    id = Column(Integer, primary_key=True)
    title = Column(String)                          # "Implement JWT Auth"
    description = Column(Text)                      # Full challenge description
    domain = Column(String)                         # "backend", "frontend", "mobile", "ai"
    difficulty = Column(Enum(DifficultyLevel))      # EASY, MEDIUM, HARD
    submission_type = Column(Enum(SubmissionType))  # CODE, LINK, IMAGE, FILE
    time_limit_minutes = Column(Integer)            # 60, 120, 180
    reward_xp = Column(Integer)                     # 50, 100, 500
    inputs_url = Column(String)                     # Link to starter resources
    source_url = Column(String)                     # GitHub issue URL (for Source B)
    source_type = Column(String)                    # "A" (Internal) or "B" (GitHub)
    created_at = Column(DateTime)                   # Timestamp
```

### Drop Model (Flutter/Mobile)

```dart
@freezed
class Drop with _$Drop {
  const factory Drop({
    required int id,
    required String title,
    required String description,
    required String domain,
    required String difficulty,
    @JsonKey(name: 'time_limit_minutes') required int timeLimitMinutes,
    @JsonKey(name: 'reward_xp') required int rewardXp,
    @JsonKey(name: 'inputs_url') String? inputsUrl,
    @JsonKey(name: 'source_url') String? sourceUrl,
    @JsonKey(name: 'source_type') @Default('A') String sourceType,
    @JsonKey(name: 'submission_type') @Default('code') String submissionType,
  }) = _Drop;
}
```

---

## 🔧 GitHub Sync Algorithm Details

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│  GITHUB SYNC WORKFLOW                                                           │
│  ════════════════════                                                           │
│                                                                                 │
│  TRIGGER: POST /drops/sync-github                                               │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  STEP 1: BUILD SEARCH QUERIES                                            │   │
│  │  ───────────────────────────                                              │   │
│  │                                                                           │   │
│  │  Base Query:                                                              │   │
│  │  is:issue is:open label:"good first issue" no:assignee stars:>1000       │   │
│  │  -docs -documentation -readme -translation -typo -localization           │   │
│  │                                                                           │   │
│  │  Language Variants:                                                       │   │
│  │  ┌──────────────────────────────────────────────────────────────────┐    │   │
│  │  │  query + language:python                                          │    │   │
│  │  │  query + language:javascript                                      │    │   │
│  │  │  query + language:typescript                                      │    │   │
│  │  │  query + language:java                                            │    │   │
│  │  │  query + language:cpp                                             │    │   │
│  │  │  query + language:c                                               │    │   │
│  │  │  query + language:go                                              │    │   │
│  │  │  query + language:kotlin                                          │    │   │
│  │  │  query + language:swift                                           │    │   │
│  │  │  query + language:rust                                            │    │   │
│  │  │  query + language:dart                                            │    │   │
│  │  └──────────────────────────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                            │
│                                    ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  STEP 2: FETCH & DEDUPLICATE                                             │   │
│  │  ──────────────────────────                                               │   │
│  │                                                                           │   │
│  │  • Call GitHub API for each query (10 results per language)              │   │
│  │  • Merge all results                                                      │   │
│  │  • Deduplicate by URL (same issue may match multiple queries)            │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                            │
│                                    ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  STEP 3: FILTER & TRANSFORM                                               │   │
│  │  ─────────────────────────                                                │   │
│  │                                                                           │   │
│  │  For each issue:                                                          │   │
│  │  ┌────────────────────────────────────────────────────────────────────┐  │   │
│  │  │                                                                     │  │   │
│  │  │  ✅ CHECK 1: Not already in DB (by source_url)                     │  │   │
│  │  │                                                                     │  │   │
│  │  │  ✅ CHECK 2: Title doesn't contain:                                 │  │   │
│  │  │     readme, typo, translation, docs, documentation                 │  │   │
│  │  │                                                                     │  │   │
│  │  │  ✅ CHECK 3: Description length >= 50 characters                    │  │   │
│  │  │                                                                     │  │   │
│  │  │  🔄 TRANSFORM: Map language → domain                                │  │   │
│  │  │     javascript/typescript → frontend                               │  │   │
│  │  │     dart/kotlin/swift     → mobile                                 │  │   │
│  │  │     python/java/go/rust   → backend                                │  │   │
│  │  │     ml/ai                 → ai                                     │  │   │
│  │  │                                                                     │  │   │
│  │  │  🧹 CLEAN: Remove HTML comments from body                           │  │   │
│  │  │                                                                     │  │   │
│  │  │  📎 APPEND: Source attribution link                                 │  │   │
│  │  │                                                                     │  │   │
│  │  └────────────────────────────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                            │
│                                    ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  STEP 4: SAVE TO DATABASE                                                 │   │
│  │  ───────────────────────                                                  │   │
│  │                                                                           │   │
│  │  Create Drop with:                                                        │   │
│  │  ┌───────────────────────────────────────────────────────────────────┐   │   │
│  │  │  title = issue.title                                               │   │   │
│  │  │  description = cleaned_body + source_link                          │   │   │
│  │  │  domain = mapped_domain                                            │   │   │
│  │  │  difficulty = EASY (default for beginner issues)                   │   │   │
│  │  │  time_limit = 120 minutes                                          │   │   │
│  │  │  reward_xp = 50                                                    │   │   │
│  │  │  source_url = issue.html_url                                       │   │   │
│  │  │  source_type = "B"                                                 │   │   │
│  │  │  submission_type = CODE                                            │   │   │
│  │  └───────────────────────────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                    │                                            │
│                                    ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  STEP 5: CLEANUP EXPIRED                                                  │   │
│  │  ──────────────────────                                                   │   │
│  │                                                                           │   │
│  │  DELETE FROM drops                                                        │   │
│  │  WHERE source_type = 'B'                                                  │   │
│  │  AND created_at < NOW() - 7 DAYS                                          │   │
│  │                                                                           │   │
│  │  (Keeps the feed fresh with current issues)                               │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 📱 Personalization Features

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                 │
│  PERSONALIZATION LAYERS                                                         │
│  ══════════════════════                                                         │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  1. DOMAIN FILTERING (User Selected)                                     │   │
│  │  ─────────────────────────────────                                        │   │
│  │                                                                           │   │
│  │  • User taps filter chips: [Frontend] [Backend] [Mobile] [AI]            │   │
│  │  • Client-side filtering of drop list                                     │   │
│  │  • Persisted preference possible in local storage                         │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  2. DIFFICULTY FILTERING                                                  │   │
│  │  ───────────────────────                                                  │   │
│  │                                                                           │   │
│  │  • Filter by Easy / Medium / Hard                                         │   │
│  │  • Beginners can focus on Easy drops                                      │   │
│  │  • Advanced users can seek Hard challenges for more XP                    │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  3. SEARCH                                                                │   │
│  │  ──────                                                                   │   │
│  │                                                                           │   │
│  │  • Full-text search on title and description                              │   │
│  │  • Find specific technologies: "JWT", "React", "PostgreSQL"              │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  4. CLASS-BASED PROGRESSION (XP Breakdown)                                │   │
│  │  ─────────────────────────────────────────                                │   │
│  │                                                                           │   │
│  │  User XP is tracked per domain:                                           │   │
│  │  {                                                                        │   │
│  │    "backend": 1500,                                                       │   │
│  │    "frontend": 800,                                                       │   │
│  │    "mobile": 200,                                                         │   │
│  │    "design": 0                                                            │   │
│  │  }                                                                        │   │
│  │                                                                           │   │
│  │  Future: Smart feed prioritization based on user's strongest domains     │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │  5. SOURCE TYPE FILTER                                                    │   │
│  │  ────────────────────                                                     │   │
│  │                                                                           │   │
│  │  • Source A: Curated internal challenges                                  │   │
│  │  • Source B: GitHub Open Source issues                                    │   │
│  │  • Users can filter to see only real-world OSS issues                     │   │
│  │                                                                           │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Summary: The Complete Pipeline

```
╔═════════════════════════════════════════════════════════════════════════════════╗
║                                                                                 ║
║  📥 SOURCES                                                                     ║
║  ─────────                                                                      ║
║  • Admin creates curated drops (Source A)                                       ║
║  • Sync job fetches GitHub "good first issues" (Source B)                       ║
║                                                                                 ║
║                              ⬇️                                                  ║
╠═════════════════════════════════════════════════════════════════════════════════╣
║                                                                                 ║
║  🔄 PROCESSING                                                                  ║
║  ────────────                                                                   ║
║  • Filter low-quality issues (docs, typos, short descriptions)                  ║
║  • Map languages to domains (JS→Frontend, Python→Backend)                       ║
║  • Clean content (remove HTML comments)                                         ║
║  • Auto-expire old issues (7 days)                                              ║
║                                                                                 ║
║                              ⬇️                                                  ║
╠═════════════════════════════════════════════════════════════════════════════════╣
║                                                                                 ║
║  💾 STORAGE                                                                     ║
║  ──────────                                                                     ║
║  • PostgreSQL database                                                          ║
║  • Drops table with all metadata                                                ║
║                                                                                 ║
║                              ⬇️                                                  ║
╠═════════════════════════════════════════════════════════════════════════════════╣
║                                                                                 ║
║  🌐 API                                                                         ║
║  ──────                                                                         ║
║  • GET /drops → Return all drops                                                ║
║  • POST /submit → Accept user solutions                                         ║
║                                                                                 ║
║                              ⬇️                                                  ║
╠═════════════════════════════════════════════════════════════════════════════════╣
║                                                                                 ║
║  📱 MOBILE APP                                                                  ║
║  ─────────────                                                                  ║
║  • Fetch drops via DropsRepository                                              ║
║  • Apply filters: Domain, Difficulty, Search                                    ║
║  • Display in beautiful DropCard UI                                             ║
║                                                                                 ║
║                              ⬇️                                                  ║
╠═════════════════════════════════════════════════════════════════════════════════╣
║                                                                                 ║
║  🎮 GAMIFICATION                                                                ║
║  ──────────────                                                                 ║
║  • User completes drop → Submission evaluated                                   ║
║  • Score >= 50 → XP awarded (total + domain-specific)                           ║
║  • Level up every 1000 XP                                                       ║
║  • Real-time WebSocket notification                                             ║
║                                                                                 ║
╚═════════════════════════════════════════════════════════════════════════════════╝
```

---

## 📚 API Endpoints Reference

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/drops` | GET | Fetch all available drops |
| `/drops/{id}/deploy` | POST | Send mission intel via email |
| `/drops/sync-github` | POST | Trigger GitHub sync (background) |
| `/drops/seed` | POST | Seed database with initial drops |
| `/submit` | POST | Submit a solution for evaluation |
| `/submissions/{id}` | GET | Get submission status |
| `/users/me/stats` | GET | Get user's gamification stats |
| `/users/leaderboard` | GET | Get leaderboard (optional domain filter) |

---

*Last Updated: January 2026*
*DevApp v2.0 - Drops Feature Documentation*
