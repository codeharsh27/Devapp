
# 🧠 AI Ranking & Filtering Implementation Plan

This document outlines the phased implementation plan for the AI-driven Candidate Ranking System on the platform.

## 📋 Phase 1: Database & Backend Foundation (The "Plumbing")
**Goal:** Enable real data flow so we aren't relying on mock data. Without this, AI has nothing to analyze.

### Tasks:
1.  **Database Schema Update**
    *   Create `submissions` table:
        *   `id` (UUID)
        *   `mission_id` (FK)
        *   `talent_id` (FK)
        *   `repo_link` (Text)
        *   `demo_link` (Text, optional)
        *   `doc_link` (Text, optional)
        *   `ai_score` (Integer, 0-100)
        *   `ai_analysis` (Text/JSON - to store the summary)
        *   `status` (Enum: 'pending', 'analyzing', 'reviewed', 'shortlisted', 'rejected')
    *   Create `talents` table (if not exists) to store reputation/XP.

2.  **API Endpoints**
    *   `POST /api/submissions`: Endpoint for Talent to submit work (triggers the AI analysis).
    *   `GET /api/missions/:id/submissions`: Endpoint for Founders to fetch ranked candidates.

3.  **Supabase Integration**
    *   Connect the frontend `SubmitWorkModal` to the `POST` endpoint.
    *   Connect the frontend `DropDetailView` to the `GET` endpoint.

---

## 🤖 Phase 2: The AI Analyst (The "Brain")
**Goal:** Automate the scoring and summarization of new submissions.

### Tasks:
1.  **Edge Function (or Backend Service)**
    *   Create a function `analyze-submission` that runs on new database inserts.
    *   **Input:** `repo_link`, `mission_description`, `mission_criteria`.
    *   **Process:**
        1.  Fetch README/Code snippets from the GitHub link (using GitHub API).
        2.  Construct a Prompt for the LLM (Gemini 2.0 Flash).
        3.  **Prompt:** "Analyze this code against these criteria. Give a score (0-100) and a 1-sentence summary."
    *   **Output:** Update the `submissions` row with `ai_score` and `ai_analysis`.

2.  **Automated Checks (The "Gatekeeper")**
    *   *Basic:* Check if the `repo_link` is valid and public.
    *   *Advanced (Later):* Run a CI pipeline (e.g., GitHub Actions) to verify build status.

---

## 🎨 Phase 3: Founder UI Experience (The "Lens")
**Goal:** Visualize the AI data for the Founder.

### Tasks:
1.  **Enhanced Submission Card**
    *   Update `DropDetailView.tsx` to display real `ai_score` and `ai_analysis`.
    *   Add visuals for "AI Match Score" (e.g., Green/Yellow/Red color coding).

2.  **Filtering & Sorting**
    *   Implement sorting by "Highest Score".
    *   Add filter toggles: "Top Matches Only", "Verified Talent".

---

## 🚀 Recommendation: What to Build First?

**Start with Phase 1 (Database & Backend).**

**Why?**
*   You currently have a beautiful frontend but it's powered by hardcoded mocks.
*   Building the AI logic (Phase 2) is useless if there's no real data being submitted.
*   Once the database is ready, enabling the AI analysis is just a matter of hooking up an API call.

### Immediate Action Items:
1.  [ ] Setup the `submissions` table in Supabase.
2.  [ ] Write the `submitMission` function in your API client.
3.  [ ] Replace the `handleStartMission` mock in `ExploreDropsView` with a real DB insert.
