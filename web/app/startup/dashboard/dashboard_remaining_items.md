# Dashboard Remaining Items & Roadmap

Based on the current implementation of the Startup Dashboard, the following features and sections are recommended for completion to ensure a fully functional product.

## 1. Core Functionality (High Priority)

- **Wallet & Payments Integration**:
  - [ ] Connect Wallet functionality (Solana/Phantom integration).
  - [ ] Bounty Escrow system (deposit funds for missions).
  - [ ] Transaction history view.

- **Mission Creation & Management**:
  - [ ] Backend integration for "Post Mission" wizard (currently mocks).
  - [ ] "Edit Mission" functionality for open drops.
  - [ ] File upload integration (currently local state only).

- **Candidate Management**:
  - [ ] Dedicated "Candidates" view (currently a placeholder in Sidebar).
  - [ ] Application review flow (accept/reject candidates).
  - [ ] Interview scheduling or direct chat initiation from candidate list.

## 2. User Experience & Social

- **Settings & Profile**:
  - [ ] Startup Profile settings (Logo, Description, Social Links).
  - [ ] Team management (invite other members).
  - [ ] Notification preferences.

- **Messaging Enhancements**:
  - [ ] Real-time WebSocket integration for `ConnectView` (Supabase Realtime).
  - [ ] File attachments in chat.
  - [ ] Video/Audio call integration (or links to Huddle01/Zoom).

## 3. Analytics & Reporting

- **Dashboard Analytics**:
  - [ ] Visual charts for "Reputation" growth over time.
  - [ ] Spending reports (Bounty distribution).
  - [ ] Mission completion velocity metrics.

## 4. Mobile Responsiveness & Polish

- **Mobile View**:
  - [ ] Verify Sidebar behavior on mobile (hamburger menu).
  - [ ] Ensure `ConnectView` chat behaves correctly on soft keyboard open.

- **Search & Discovery**:
  - [ ] Advanced filters for `DiscoverView` (Rate, Timezone, Availability).
  - [ ] "Save/Favorite" talent functionality.
