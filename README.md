<div align="center">

# DevApp

**A proof-of-work marketplace connecting startups and developers
— because resumes don't show how someone actually builds.**

[![Live](https://img.shields.io/badge/Live-devapp--v02.vercel.app-black)](https://devapp-v02.vercel.app)
[![Next.js](https://img.shields.io/badge/Next.js-TypeScript-black?logo=next.js)](https://nextjs.org)
[![Flutter](https://img.shields.io/badge/Flutter-Mobile-blue?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green?logo=supabase)](https://supabase.com)

[Live Site](https://devapp-v02.vercel.app) ·
[Portfolio](https://harshmule.vercel.app) ·
[LinkedIn](https://linkedin.com/in/harshmule27)

</div>

---

## The Problem

Hiring is broken on both sides.

A developer can list 5 years of React experience on a resume
and still struggle to ship a feature under pressure.
A startup wastes 3 weeks interviewing the wrong people.
A developer applies to 50 jobs and gets ghosted by 48 of them.

The signal is broken. Resumes are a proxy for work,
not proof of it.

---

## What DevApp Does

DevApp flips the hiring model entirely.

**Startups** post real micro-challenges — actual problems
from their product or codebase, not toy exercises.

**Developers** browse challenges, submit real solutions,
and build a portfolio of proof-of-work across companies.

**Hiring decisions** are based on what you can actually build —
not what you claim on a PDF.

The result: startups find people who can do the job.
Developers get hired for demonstrated ability, not credentials.

---

## The Hard Product Problem

Marketplaces are coordination problems — not engineering problems.

Getting a startup to post a challenge requires believing
developers will show up and submit quality work.
Getting a developer to spend hours building requires
believing a startup will actually hire from it.

Neither side moves first without proof the other will.

That chicken-and-egg problem shaped every product decision
in DevApp — from how challenges are structured to how
submissions are reviewed to how reputation is built over time.

---

## Architecture

DevApp is a full-stack, multi-platform product:
devapp/

├── web/          # Next.js web app (primary platform)

├── mobile/       # Flutter mobile app

├── backend/      # API + business logic

├── doc/          # Product documentation + decisions

└── .agent/       # AI workflow configs
**Web:** Next.js + TypeScript + Tailwind CSS
Server-side rendering for fast load times and SEO.
Primary platform for startups posting challenges.

**Mobile:** Flutter + Dart
Developer-facing mobile experience.
Browse challenges, submit solutions, track reputation.

**Backend:** PostgreSQL + Supabase
Row-level security for multi-tenant data isolation.
Real-time subscriptions for live submission updates.

**Deployment:** Vercel (web) + Railway (backend)

---

## Core Features

| Feature | Description |
|---|---|
| Challenge Dashboard | Startups post real tasks with context, requirements, and evaluation criteria |
| Developer Submissions | Developers submit solutions and build a proof-of-work portfolio |
| Reputation System | Quality scores compound across submissions — a track record that travels |
| Talent Discovery | Startups filter by work quality, not years of experience |
| Direct Messaging | Founders and developers connect after submissions — no recruiter middleman |

---

## Key Technical Decisions

**Why Supabase over a custom backend?**
Real-time submission updates and row-level security
for multi-tenant isolation were table-stakes features.
Supabase gave both without building auth + websockets from scratch,
letting the product move faster in the early stages.

**Why both web and mobile?**
Startups post challenges from desktops — web first.
Developers browse and submit on the go — mobile matters.
One codebase serving both audiences required
intentional UX decisions for each context.

**Why PostgreSQL for a marketplace?**
Relational data is the right model for a marketplace.
Challenges, submissions, companies, developers, and
reputation scores all have real relationships that
need to be enforced at the database level — not in application code.

---

## Getting Started

### Prerequisites
```bash
Node.js 18+
Flutter SDK 3.x
Supabase account
```

### Clone and install
```bash
git clone https://github.com/codeharsh27/Devapp.git
cd Devapp

# Web
cd web && npm install

# Backend
cd backend && npm install
```

### Environment setup
```bash
cp .env.example .env
# Add your keys:
# SUPABASE_URL
# SUPABASE_ANON_KEY
# SUPABASE_SERVICE_ROLE_KEY
```

### Run locally
```bash
# Web app
cd web && npm run dev

# Backend
cd backend && npm run dev

# Mobile
cd mobile && flutter run
```

### Live deployment
Web app is live at: [devapp-v02.vercel.app](https://devapp-v02.vercel.app)

---

## What I Learned Building This

Marketplace products don't fail on technology.
They fail on trust, incentives, and timing.

The features were the easy part.
Getting both sides of the marketplace to show up,
believe in the system, and take the first action —
before the system had enough proof to justify that belief —
that was the actual product challenge.

It taught me that the coordination system IS the product.
Everything else is built on top of it.

---

## Built By

**Harsh Mule** — Product Engineer

[harshmule.vercel.app](https://harshmule.vercel.app) ·
[harshux27@gmail.com](mailto:harshux27@gmail.com)
