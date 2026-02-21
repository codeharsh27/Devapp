# 🚀 Production Roadmap: Talent & Startup Dashboard

This document analyzes the current state of the application and outlines the steps required to make it production-ready, with a specific focus on the AI-driven candidate shortlisting feature.

## 📊 Current Status Analysis

| Feature Area | Current State | Production Ready? | Gaps |
| :--- | :--- | :--- | :--- |
| **Startup: Create Mission** | Partial Impl | ❌ No | Uses `supabase.insert` but table schema unverified. |
| **Startup: View Candidates** | **Mock Only** | ❌ No | `DropDetailView` uses hardcoded data. |
| **Talent: Explore Missions** | **Mock Only** | ❌ No | `ExploreDropsView` uses hardcoded data. |
| **Talent: Submit Work** | UI Ready | ❌ No | `SubmitWorkModal` exists but updates local state only. |
| **Talent: Profile/Reputation** | Mock Only | ❌ No | No real XP or history tracking. |
| **AI Shortlisting** | **Concept Only** | ❌ No | No backend logic exists yet. |

---

## 🗓️ Implementation Phases

### Phase 1: The Backbone (Data & Auth)
**Goal:** Replace all "Mock Data" with real database connections.
1.  **Database Design**:
    *   Create `missions` table (id, title, bounty, description, requirements, etc.).
    *   Create `submissions` table (id, mission_id, talent_id, repo_link, doc_link, status).
2.  **Startup Side Integration**:
    *   Verify `CreateMissionView` successfully inserts into Supabase.
    *   Update `DropDetailView` to fetch real submissions for a mission.
3.  **Talent Side Integration**:
    *   Update `ExploreDropsView` to fetch `select * from missions`.
    *   Wire up `SubmitWorkModal` to `insert into submissions`.

### Phase 2: The Intelligence (AI Candidate Shortlisting) 🧠
**Goal:** Automatically rank and summarize developer work.
1.  **The Trigger**:
    *   Set up a Supabase Edge Function (or backend webhook) that listens for **new rows** in the `submissions` table.
2.  **The AI Generic Analyst**:
    *   **Input**: Repo URL + Mission Description.
    *   **Process**:
        *   Fetch code/README from GitHub.
        *   Prompt LLM: *"Analyze this code against these requirements. return { score: 0-100, summary: '...' }"*.
    *   **Output**: Update the `submissions` row with `ai_score` and `ai_summary`.
3.  **The UI Update**:
    *   Frontend automatically displays the new score in `DropDetailView` once the analysis is done.

### Phase 3: The Polish (Real-time & feedback)
1.  **Notifications**: Alert the Startup when a submission is ready.
2.  **Messaging**: Allow Founder to chat with Top 3 candidates (using existing `MessagesView`).
3.  **Payments**: Integrate payout logic (Stripe/Crypto) - *Future Scope*.

---

## 🛠️ Immediate Next Step: Phase 1 & 2 Setup

We should start by creating the database tables. This is the blocker for everything else.

### Proposed Schema (Supabase)

```sql
-- Missions Table
create table missions (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  title text not null,
  description text not null,
  bounty numeric not null,
  status text default 'open', -- open, in_progress, completed
  requirements text[],
  founder_id uuid references auth.users
);

-- Submissions Table
create table submissions (
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  mission_id uuid references missions,
  talent_id uuid references auth.users,
  repo_link text not null,
  doc_link text,
  status text default 'pending', -- pending, reviewing, accepted, rejected
  -- AI Fields
  ai_score int, 
  ai_summary text
);
```
