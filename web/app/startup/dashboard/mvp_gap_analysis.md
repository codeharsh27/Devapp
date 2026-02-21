# Dashboard Feature Gap Analysis - Founders' Review

As we prepare for our MVP launch, we need to address several critical gaps in our functionality. While the UI is looking polished, the "engine" that powers hiring and payments is incomplete.

## 🚨 Critical L1: Must-Have for MVP (Launch Blockers)

These features are non-negotiable. Without them, the core loop of "Post Mission -> Hire Talent -> Pay" is broken.

### 1. The Missing "Candidates" View (Inbound Hiring)
**Current Status:** We have a sidebar link for "Candidates", but it renders... nothing!
**The Gap:** When a startup posts a mission, where do the applications go? We have `Discover` (outbound search), but we have zero visibility on *inbound* interest.
**Requirement:**
- A dedicated **"Candidates Pipeline" view**.
- Columns/Stages: "New Applicants", "Interviewing", "Offer Sent", "Hired".
- Ability to view a candidate's proposal/cover letter (not just their profile).
- **Action Buttons:** "Accept", "Reject", "Message".

### 2. Startup Identity & Trust (Settings)
**Current Status:** We have authentication, but no company profile management.
**The Gap:** Candidates need to trust who they are working for. "Alex Founder" is not enough. We need a company entity.
**Requirement:**
- **Settings Page**:
  - Company Logo upload.
  - "About Us" / Mission statement.
  - Website & Social links (LinkedIn/Twitter).
  - Billing/Invoice details (even if manual for now).

### 3. Mission "Go Live" Connection
**Current Status:** The "Post Mission" wizard is beautiful but ends with a browser `alert("Mission Posted!")`.
**The Gap:** It doesn't actually go anywhere.
**Requirement:**
- **Backend Integration**: Connect the wizard `onSubmit` to Supabase `missions` table.
- **Validation**: Ensure all fields (Bounty, Description, Title) are valid before submission.
- **Success State**: Redirect to "Active Missions" view with the new mission at the top.

### 4. Wallet & Payments (The Financial Layer)
**Current Status:** We mention "Bounty" in the wizard, but have no way to collect or payout.
**The Gap:** This is a fintech/hiring platform. Money needs to move, or at least be verified.
**Requirement:**
- **"Connect Wallet" (Solana/Phantom)**: Even if we don't do full escrow yet, we need to let them connect a wallet to their profile.
- **Funds Verification**: A simple check or visual indicator that they have the funds to pay the bounty.

---

## ⚠️ High Priority L2: "Day 2" Feaures (Fast Follows)

These are important for retention but won't stop the first transaction.

### 5. Notification Interactivity
**Current Status:** We have a list of notifications, but clicking "Review Application" does nothing.
**Requirement:** Deep linking. Clicking "New Applicant" should take you directly to that specific candidate in the pipeline.

### 6. Chat Realism
**Current Status:** Chat is local state only. Refresh the page = messages gone.
**Requirement:** Persist chat messages to Supabase. Even simple threading.

### 7. Analytics Dashboard
**Current Status:** We have "Recent Activity" and some stats, but they are mocked.
**Requirement:** Real numbers based on actual DB queries (Total Spent, Missions Posted, Avg Time to Hire).

---

## 🔮 Future L3: Growth & Scale

- **Team Access**: Invite co-founders/recruiters.
- **Automated Payouts**: Escrow accounts that auto-release funds upon mission completion.
- **AI Matching**: Automatically suggesting candidates for a new mission.

**Recommendation:**
We should immediately start building the **Candidates View**. It is the biggest missing piece of the hiring puzzle.
