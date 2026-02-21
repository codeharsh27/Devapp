# Backend Architecture: Execution-First Marketplace

## 1. Architecture Overview

To support a strict, signal-based execution platform, we move away from simple CRUD and adopt an **Event-Driven, Worker-Based Architecture**.

### Core Services

1.  **API Gateway (Next.js / Node.js)**
    *   Handles client requests (Startups/Talent).
    *   Authentication & Authorization (Supabase Auth).
    *   Input validation and request routing.
    *   **Role:** The "Receptionist".

2.  **Task Service (Supabase + Postgres Functions)**
    *   Manages task lifecycles (Creation, Open, Evaluation, Closed).
    *   Stores criteria and test cases secure from public view.
    *   **Role:** The "Manager".

3.  **Submission Queue (Redis / BullMQ)**
    *   Buffers incoming submissions to prevent server overload.
    *   Ensures valid "First-Come-First-Serve" processing order.
    *   **Role:** The "Waiting Line".

4.  **Evaluation Engine (Python/Go Worker Nodes)**
    *   **Isolated Environment:** Runs untrusted developer code.
    *   **Auto-Tester:** Executes unit tests, performance benchmarks, and lint checks.
    *   **Scoring Agent:** Calculates raw scores based on pass/fail and metrics.
    *   **Technology:** Docker containers or Firecracker MicroVMs.
    *   **Role:** The "Examiner".

5.  **Ranking Engine (Postgres Views / Scheduled Jobs)**
    *   Aggregates scores (Auto + Manual + Signal).
    *   Normalizes scores across different difficulty levels.
    *   Auto-shortlists the top N candidates.
    *   **Role:** The "Judge".

### Communication Flow
*   **Synchronous (User -> API):** HTTP/REST.
*   **Asynchronous (API -> Evaluation):** Message Queue (Redis).
*   **State Updates (Evaluation -> DB):** Direct Database Connection.
*   **Notifications:** Webhooks / Supabase Realtime.

---

## 2. Database Design (PostgreSQL)

### Users & Profiles
```sql
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  role TEXT CHECK (role IN ('startup', 'talent')),
  
  -- Signal System
  reputation_score INT DEFAULT 0, -- Global XP
  signal_tier TEXT DEFAULT 'Iron', -- Iron, Bronze, Silver, Gold, Platinum
  rank_percentile DECIMAL(5,2), -- e.g. 98.5 (Top 1.5%)
  
  -- Metadata
  github_handle TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Tasks
```sql
CREATE TABLE tasks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  startup_id UUID REFERENCES profiles(id),
  
  -- Content
  title TEXT NOT NULL,
  description TEXT,
  repo_template_url TEXT, -- Base code for devs to clone
  
  -- Taxonomy
  category TEXT, -- 'backend', 'frontend', 'smart-contract'
  difficulty_level INT CHECK (difficulty_level BETWEEN 1 AND 5),
  
  -- Lifecycle
  status TEXT DEFAULT 'open', -- 'open', 'evaluating', 'delegated', 'closed'
  deadline TIMESTAMP WITH TIME ZONE,
  max_submissions INT DEFAULT 50,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Evaluation Criteria (The "Rubric")
```sql
CREATE TABLE task_criteria (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  task_id UUID REFERENCES tasks(id),
  
  type TEXT, -- 'auto-test', 'lint-check', 'performance', 'manual-review'
  weight DECIMAL(3,2), -- e.g. 0.6 for tests, 0.4 for style
  
  -- For Auto Tests
  test_file_path TEXT, -- location of secret test file
  timeout_ms INT DEFAULT 5000,
  memory_limit_mb INT DEFAULT 512
);
```

### Submissions
```sql
CREATE TABLE submissions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  task_id UUID REFERENCES tasks(id),
  developer_id UUID REFERENCES profiles(id),
  
  -- Content
  repo_url TEXT,         -- Dev's fork
  commit_hash TEXT,      -- Specific version
  
  -- Evaluation State
  status TEXT DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
  
  -- Scoring
  raw_auto_score DECIMAL(5,2),   -- 0-100 from tests
  raw_manual_score DECIMAL(5,2), -- 0-100 from startup
  
  -- Computed
  final_score DECIMAL(5,2),      -- Weighted aggregate
  is_shortlisted BOOLEAN DEFAULT FALSE,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Evaluation Logs (Audit Trail)
```sql
CREATE TABLE evaluation_logs (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  submission_id UUID REFERENCES submissions(id),
  
  step_name TEXT, -- 'npm install', 'run tests', 'lint'
  status TEXT,    -- 'success', 'failure'
  output_log TEXT, -- stdout/stderr capture
  duration_ms INT,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## 3. Task Flow (End-to-End)

1.  **Definition (Startup)**
    *   Startup uploads a `task.yml` or fills form.
    *   Defines: "Pass these 5 unit tests" (60%) + "Code Clarity" (40%).
    *   Uploads a **Secret Test Suite** (never shown to devs).

2.  **Execution (Developer)**
    *   Dev clones `repo_template_url`.
    *   Writes code locally.
    *   Pushes to their own private/public git repo.
    *   Clicks "Submit" -> API creates `submission` record.

3.  **Processing (System)**
    *   API pushes `submission_id` to Redis Queue.
    *   **Worker Node** pops job.
    *   **Sandbox:** Spins up Docker container.
    *   **Clone:** Clones Dev Repo + Injects Secret Test Suite.
    *   **Exec:** Runs `npm test` / `pytest`.
    *   **Report:** Captures JSON results (Passed/Total).
    *   **Store:** Updates `submissions` table with `raw_auto_score`.

4.  **Ranking (System)**
    *   Ranking Engine triggers on score update.
    *   Calculates `final_score`.
    *   Updates `is_shortlisted` for top N candidates.

5.  **Delegation (Startup)**
    *   Startup sees *only* shortlisted candidates (High Signal).
    *   Startup reviews code/manual criteria.
    *   Clicks "Delegate" -> Contracts generated / Payment locked.

---

## 4. Evaluation Engine Design (Auto-Test Mode)

The engine must be **adversarial-resistant**.

### Isolation Strategy
*   **Infrastructure:** AWS Fargate or specialized K8s nodes.
*   **Crucial Security:** No network access for containers (prevent exfiltration of secret tests or keys) *unless* whitelisted (e.g., npm registry).
*   **Resources:** Hard limits on CPU (0.5 vCPU), RAM (512MB), and Time (30s timeout).

### Execution Steps
1.  **Manifest Parse:** Read `devapp.config.json` to know runtime (Node/Python/Go).
2.  **Volume Mount:**
    *   `/app/src`: Developer Code (Read-only)
    *   `/app/tests`: Secret Tests (Read-only)
    *   `/app/output`: Writeable for test results.
3.  **Command Injection:**
    *   Run test runner pointing to Secret Tests.
    *   *Example:* `mocha /app/tests --reporter json > /app/output/result.json`
4.  **Score Normalization:**
    *   Convert `14/20 cases passed` -> `70.0 points`.

---

## 5. Ranking Logic

The goal is to find the **best executor**, not just the one who passed tests (speed/quality matters).

**Formula:**
```javascript
FinalScore = (
  (AutoTestPercentage * 0.50) +       // Functional Correctness
  (PerformanceScore * 0.20) +         // Efficiency (Execution Time/Memory)
  (ManualReview * 0.20) +             // Code Quality (Startup Input)
  (ReputationModifier * 0.10)         // Historical Reliability
)
```

**Tie-Breaking:**
1.  Higher Test Score.
2.  Lower Execution Time.
3.  Earlier Submission Time (Time-to-Market value).

**Anti-Gaming:**
*   **Hidden Tests:** 50% of tests are public (for dev debugging), 50% are hidden (for actual scoring). Prevents "coding to the test".
*   **Plagiarism Detection:** Hash AST (Abstract Syntax Tree) to compare against other submissions.

---

## 6. Developer Signal System (Reputation)

We replace "Stars" with **"Signal"**.

**Core Metrics:**
1.  **Completion Rate:** `(Submitted / Started)`. punish abandonment.
2.  **Accuracy:** `Avg(AutoTestScore)`. E.g., consistently scores 95%+.
3.  **Speed:** Percentile ranking of submission time relative to cohort.

**Reputation Classes:**
*   **0-100 XP (Candidate):** Can view public tasks.
*   **100-500 XP (Verified):** Can submit to standard tasks.
*   **500-2000 XP (Elite):** Can submit to High-Value/Private tasks.
*   **2000+ XP (Legend):** Auto-shortlisted often.

**Decay:**
*   XP decays by 5% every month of inactivity. "You are only as good as your last commit."

---

## 7. Scalability & Infrastructure

### Queue System
*   **Tech:** BullMQ (Node) or Celery (Python).
*   **Priority:**
    *   High Priority Queue: "Elite" devs / "Urgent" tasks.
    *   Standard Queue: Everyone else.

### Caching
*   **Redis:** Cache the "Leaderboard" for active tasks. Don't query Postgres for rankings on every page load.
*   **TTL:** Refresh rankings every 1 minute or on new submission event.

### Scaling
*   **Stateless API:** Horizontally scale Next.js/FastAPI pods.
*   **Stateful Workers:** Autoscale worker pods based on Queue Depth (Metric: `MessagesVisible`).

---

## 8. Security Considerations

1.  **The "While True" Attack:** Dev submits infinite loop code.
    *   *Defense:* Hard timeout (SIGKILL) after 30s.
2.  **The "Fork Bomb":** Dev code depletes PIDs.
    *   *Defense:* `ulimit -u` inside container.
3.  **The "Exfiltration":** Dev code uploads secret tests to their server.
    *   *Defense:* Container has **NO** outgoing internet access (`--network none` or strict egress firewall).
4.  **Auth Spoofing:**
    *   *Defense:* Row Level Security (RLS) on Supabase. Devs can only see their own submissions.

---

## 9. API Design

### Tasks
*   `POST /api/v1/tasks` (Startup only)
*   `GET /api/v1/tasks?category=backend&status=open`
*   `GET /api/v1/tasks/:id/details` (Requires Auth)

### Submissions
*   `POST /api/v1/tasks/:id/submit`
    *   Body: `{ repo_url: "...", commit: "..." }`
*   `GET /api/v1/submissions/:id/status` (Polling for evaluation result)

### Evaluation (Internal/Worker)
*   `POST /internal/evaluate`
    *   Body: `{ submission_id: "...", test_suite_id: "..." }`

### Ranking
*   `GET /api/v1/tasks/:id/leaderboard`
    *   Returns: Top N candidates (anonymized if needed).

---

## 10. MVP vs Phase 2

### MVP (Month 1)
*   **Scope:** Single language (Node.js/TypeScript only).
*   **Eval:** Auto-tests only using standard `npm test`. No hidden tests yet.
*   **Rank:** Purely based on test pass %.
*   **Infra:** Single worker node.

### Phase 2 (Month 3)
*   **Scope:** Polyglot (Python, Go, Rust).
*   **Eval:** Hidden Test Suites + Static Analysis (Linting).
*   **Signal:** Full XP/Decay system.
*   **Infra:** Kubernetes Autoscale.
