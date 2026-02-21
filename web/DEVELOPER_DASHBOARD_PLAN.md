# Developer (Talent) Dashboard Implementation Plan

## Objective
Build a "Growth + Clarity + Momentum" focused dashboard for developers.
**Core Philosophy**: "I'm progressing. My work matters. I'm getting closer to real opportunities."
**Design Principle**: No noise. No competition. No gamified points. Just clean metrics and opportunities.

## Architecture & Layout

### Left Sidebar (Information Architecture)
1.  **Overview** (Home)
2.  **Explore Drops** (Marketplace)
3.  **My Submissions** (Active Work)
4.  **Talent Ledger** (Profile/Resume)
5.  **Messages** (Opportunities)

### Design Language
-   **Theme**: Dark/High-Contrast (Consistent with "Developer" aesthetic) or Clean Light (if matching Founder). *Assuming Dark mode based on current `page.tsx` classes (`bg-black text-white`).*
-   **Accent**: Indigo/Violet (Growth, Tech) or simple Monochrome with Status Colors.
-   **Status Colors**:
    -   Blue/Indigo: Active/In Progress
    -   Yellow/Amber: Under Review / Needs Fix
    -   Green: Shortlisted / Completed
    -   Red: (Avoid explicit red rejection, use neutral terms)

## Implementation Phases

### Phase 1: Foundation & Navigation
1.  **Architecture Update**:
    -   Rename/Refactor existing `TalentSidebar` items to: Overview, Explore Drops, My Submissions, Talent Ledger, Messages.
    -   Ensure `currentView` state supports all these views.
2.  **Clean Up**:
    -   Remove `TalentWallet` if it doesn't fit "Talent Ledger" (or merge it).
    -   Remove "gamified" elements if present.

### Phase 2: Overview Page (Main Screen)
**Focus**: Motivation & Structure.
1.  **Progress Snapshot (Top Block)**:
    -   Create `ProgressStats` component.
    -   Metrics: Drops Completed, Shortlisted, In Review.
    -   Ledger Strength indicator.
2.  **Continue Working Section**:
    -   Show active submissions with status (Submitted, Needs Fix, Shortlisted).
    -   New/Explore CTA if empty.
3.  **Recommended Drops**:
    -   Algorithm placeholder: Show 3-5 drops based on skills.
    -   Card styling: Title, Domain, Time, "High Match" badge.
4.  **Messages/Opportunities Widget**:
    -   Small section for recent Founder messages.

### Phase 3: Explore Drops Page (Execution Start)
**Focus**: Intelligent filtering & Psychology ("Start Drop" vs "Apply").
1.  **Refactor MissionFeed**: Rename to `ExploreDropsView`.
2.  **Filters**:
    -   Domain, Time Estimate (2-4h, 4-6h), Public/Private, Match %.
3.  **Drop Card Update**:
    -   Title, 1-line build description, Time estimate.
    -   **Acceptance Criteria Preview**.
    -   **Button**: "Start Drop" (Crucial wording change).

### Phase 4: Drop Detail & Execution
**Focus**: Clean & Serious.
1.  **Drop Detail View**:
    -   Top: Title, Founder, Estimate, Deadline.
    -   Middle: Task Description, Acceptance Criteria (Checklist), Output Format.
    -   Bottom: "Start Working" button -> Changes status to "In Progress".
2.  **State Management**:
    -   Handle transition from "Explore" to "In Progress" (Active Drop).

### Phase 5: Submission Interface
**Focus**: Structured Professionalism.
1.  **Submission Form**:
    -   Fields: Repository Link, Branch Name, "How to test", "What did you change?", "Edge cases handled?".
    -   Action: "Submit Work" (No cover letters).

### Phase 6: My Submissions Page
**Focus**: Status Clarity.
1.  **Refactor MyMissions**: Rename to `SubmissionsView`.
2.  **Status Cards**:
    -   Under Review
    -   Needs Fix (with feedback bullets & Retry button)
    -   Shortlisted
    -   Completed (Added to Ledger)

### Phase 7: Talent Ledger (Profile)
**Focus**: Proof of Work.
1.  **Refactor TalentProfile**: Rename to `TalentLedgerView`.
2.  **Structure**:
    -   Sections: Backend Drops, Frontend Drops, Cloud Drops, Open Source.
    -   Entry Design: Drop Title, Deliverable, Skills, Verified Badge.
3.  **Shareability**: Ensure this view looks good as a public profile.

### Phase 8: Messages
**Focus**: Low Noise.
1.  **Refactor TalentMessages**:
    -   Logic: Only show if Shortlisted or Founder initiated.
    -   Simple chat with generic attachments.

## Strategic Notes
-   **Psychology**: Every click is "investing in profile", not "applying".
-   **Founder vs Developer**: Founder = Control (Dashboard). Developer = Growth (IDE-like focus).
