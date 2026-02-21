# Founder Dashboard Implementation Plan

## Objective
TRANSFORM the current Startup Dashboard into a high-signal, zero-noise control center for founders.
**Core Philosophy**: Minimal surface area. Maximum control. Zero noise.

## Architecture & Layout

### Left Sidebar (4 items only)
1. **Overview** (`/dashboard/startup`)
2. **Drops** (`/dashboard/startup/drops`) - Active & Archived
3. **Talent** (`/dashboard/startup/talent`) - Private CRM
4. **Messages** (`/dashboard/startup/messages`) - Targeted communication

### Design Language
- **Background**: White (#FFFFFF)
- **Containers**: Soft Grey (e.g., #F9FAFB) with subtle borders
- **Typography**: Clean, professional (Inter/Geist)
- **Status Colors**: Green (Live/Action), Orange (Review), Grey (Archived)
- **Visuals**: No charts, no gamification badges.

## Implementation Phases

### Phase 1: Foundation & Layout
1.  **Refactor Sidebar**: Modify `StartupSidebar.tsx` to strictly show the 4 core items. Remove extra links.
2.  **Create Dashboard Layout**: Ensure a persistent layout wrapper for the startup section if not already present, or update the existing page structure to support the 4-page split.
3.  **Clean Up**: Identify and deprecate/archive unused components from the "marketplace" style dashboard (`DiscoverView`?, `NotificationView`?).

### Phase 2: Overview Page (Home)
1.  **Active Drops Section**: Create `ActiveDropCard` component (Title, Status, Submissions, "Top Executions Ready" badge).
2.  **Action Required Box**: Simple text-based summary of pending items (e.g., "2 Drops ready for review").
3.  **Quick Create**: Sticky "Create Drop" button in top-right.

### Phase 3: Drops Engine
1.  **Drops Listing Page**:
    *   Two tabs: Active / Archived.
    *   Minimal List View of Drops.
2.  **Drop Detail Page**:
    *   **Top**: Title, Criteria (collapsible), Edit.
    *   **Middle (Execution Panel)**: 
        *   If reviewing: Show Top 3-5 Executions only. 
        *   `ExecutionCard`: Preview, Summary, "Review/Message" buttons.
    *   **Bottom**: Close/Archive actions.
    *   **Security**: Add "Never share production credentials" warning.
3.  **Create Drop Wizard**:
    *   Implement 3-step Modal: 1. Define Task, 2. Define Criteria, 3. Visibility.
    *   Remove current complex forms if they exist.

### Phase 4: Talent & Messages
1.  **Talent Page**:
    *   Grid view of `TalentCard` (Name, Domain, Worked with you tag).
    *   Filters: Domain, Drop type.
2.  **Messages Page**:
    *   Restrict access: Only for shortlisted/saved talent.
    *   Simple chat interface with attachment support.

### Phase 5: Final Polish
1.  **Efficiency Check**: Verify the "3-minute workflow".
2.  **Security UI**: Ensure lock icons on private drops and security warnings are visible.

## User Approval Required
Please confirm if this plan aligns with your vision. Once approved, I will begin with Phase 1.
