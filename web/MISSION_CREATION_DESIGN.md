# Mission Creation Flow: Design Proposal

## Core Philosophy
**"Dispatching a Special Ops Team"** vs. *Posting a Job Listing*.
The experience should feel operational, precise, and high-stakes. The founder is the Commander; the developer is the Specialist.

---

## Proposed Workflow: "The Mission Briefing"

We transform the current simple form into a focused **5-Step Command Center**.

### 1. Identify (The Objective)
*   **Input**: High-impact one-liner (e.g., *"Fix Stripe Webhook Latency"*).
*   **Micro-Interaction**: As you type, the system auto-suggests the **Mission Type** (Bug Fix, New Feature, Audit, Optimization).
*   **Vibe**: Fast. Like entering a command.

### 2. Intel (The Context)
*   **The Problem**: A dedicated simplified editor (markdown support) to explain *exactly* what is wrong or needed.
*   **Secure Assets**: A "Drop Zone" for screenshots, logs, or private repo links.
    *   *Feature*: "One-click NDA" checkbox for private assets.
*   **Success Criteria**: A specific list of "Definition of Done" checkboxes (e.g., "Latency < 200ms", "Tests passed").

### 3. Parameters (The Constraints)
*   **Stack**: Select critical skills (e.g., Node.js, Redis).
*   **Urgency Selector**: 
    *   🟢 **Standard**: 3-5 days.
    *   🟡 **High Priority**: 24-48 hours.
    *   🔴 **Critical Protocol**: ASAP (Boosts visual prominence).

### 4. Bounty (The Invoice)
*   **Cash**: Dollar amount.
*   **Smart Suggest**: "Missions like this usually clear for $500." (Mocked for now).
*   **Bonus Unlocks**: "Interview Fast-Track" or "Verified Badge" for the solver.

### 5. Dispatch (The Launch)
*   **Visual**: A high-tech "Dossier" summary card.
*   **Interaction**: **"Hold to Dispatch"** button (adds weight to the action) instead of a simple click.
*   **Animation**: A "Broadcasting to Network..." loading state before success.

---

## UI/UX Choices

### A. The Container
*   **Full-Screen Overlay**: When you hit "Create", the rest of the dashboard fades back. You are now in "Mission Mode".
*   **Focus Mode**: No navbar, no distractions. Just the mission.

### B. "Smart" Features (To Implement)
*   **Template Library**: Buttons for "Quick Fix", "Feature Ship", "Optimization".
*   **AI Assist (Mocked)**: A "Refine Brief" button that takes a messy description and formats it into bullet points.

---

## Question for You
**Which direction do you prefer?**
1.  **Guided Wizard (Current Style)**: Step-by-step, focused. Good for ensuring detail.
2.  **Power Sheet**: A single tall page where you can see everything at once. Faster for power users.

*I recommend the **Guided Wizard** but with fewer, denser steps to keep it feeling fast but professional.*
