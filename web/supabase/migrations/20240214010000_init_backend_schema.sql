-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 0. CLEANUP (Force Reset for Development)
-- ==========================================
DROP TABLE IF EXISTS public.evaluation_logs CASCADE;
DROP TABLE IF EXISTS public.submissions CASCADE;
DROP TABLE IF EXISTS public.task_criteria CASCADE;
DROP TABLE IF EXISTS public.tasks CASCADE;

-- ==========================================
-- 1. Tasks Table (Core of the Platform)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    startup_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    -- Content
    title TEXT NOT NULL,
    description TEXT,
    repo_template_url TEXT, -- Base code for devs to clone
    
    -- Taxonomy
    category TEXT CHECK (category IN ('backend', 'frontend', 'mobile', 'smart-contract', 'design', 'product')),
    difficulty_level INT CHECK (difficulty_level BETWEEN 1 AND 5),
    
    -- Lifecycle
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'evaluating', 'delegated', 'closed')),
    deadline TIMESTAMP WITH TIME ZONE,
    max_submissions INT DEFAULT 50,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS: Startups can CRUD their own tasks. Everyone can read open tasks.
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tasks are viewable by everyone" ON public.tasks
    FOR SELECT USING (true);

CREATE POLICY "Startups can insert their own tasks" ON public.tasks
    FOR INSERT WITH CHECK (auth.uid() = startup_id);

CREATE POLICY "Startups can update their own tasks" ON public.tasks
    FOR UPDATE USING (auth.uid() = startup_id);


-- ==========================================
-- 2. Task Criteria (The "Rubric")
-- ==========================================
CREATE TABLE IF NOT EXISTS public.task_criteria (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
    
    type TEXT CHECK (type IN ('auto-test', 'lint-check', 'performance', 'manual-review')),
    weight DECIMAL(3,2) NOT NULL, -- e.g. 0.60
    description TEXT,
    
    -- For Auto Tests (Hidden from public view usually)
    test_file_path TEXT, 
    timeout_ms INT DEFAULT 5000,
    memory_limit_mb INT DEFAULT 512,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS: Public can read criteria descriptions (rubric), but NOT hidden details like test_file_path if sensitive
ALTER TABLE public.task_criteria ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Criteria viewable by everyone" ON public.task_criteria
    FOR SELECT USING (true);

CREATE POLICY "Startups manage criteria" ON public.task_criteria
    FOR ALL USING (EXISTS (SELECT 1 FROM public.tasks WHERE tasks.id = task_criteria.task_id AND tasks.startup_id = auth.uid()));


-- ==========================================
-- 3. Submissions (The Work)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
    developer_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    -- Content
    repo_url TEXT NOT NULL,
    commit_hash TEXT,
    notes TEXT,
    
    -- Evaluation State
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'evaluated', 'failed')),
    
    -- Scoring
    raw_auto_score DECIMAL(5,2),   -- 0-100 from tests
    raw_manual_score DECIMAL(5,2), -- 0-100 from startup
    
    -- Computed
    final_score DECIMAL(5,2),      -- Weighted aggregate
    is_shortlisted BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS: Devs see their own submissions. Startup sees submissions for their tasks.
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Devs can view own submissions" ON public.submissions
    FOR SELECT USING (auth.uid() = developer_id);

CREATE POLICY "Startup sees submissions for their tasks" ON public.submissions
    FOR SELECT USING (EXISTS (SELECT 1 FROM public.tasks WHERE tasks.id = submissions.task_id AND tasks.startup_id = auth.uid()));

CREATE POLICY "Devs can insert submissions" ON public.submissions
    FOR INSERT WITH CHECK (auth.uid() = developer_id);


-- ==========================================
-- 4. Evaluation Logs (Audit Trail)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.evaluation_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    submission_id UUID REFERENCES public.submissions(id) ON DELETE CASCADE,
    
    step_name TEXT, -- 'npm install', 'run tests', 'lint'
    status TEXT CHECK (status IN ('success', 'failure')),
    output_log TEXT, -- stdout/stderr capture
    duration_ms INT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS: Only visible to the developer who owns the submission and the startup who owns the task
ALTER TABLE public.evaluation_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "View logs for own submission" ON public.evaluation_logs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.submissions 
            WHERE submissions.id = evaluation_logs.submission_id 
            AND submissions.developer_id = auth.uid()
        )
    );

CREATE POLICY "Startup view logs for task submissions" ON public.evaluation_logs
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.submissions 
            JOIN public.tasks ON submissions.task_id = tasks.id
            WHERE submissions.id = evaluation_logs.submission_id 
            AND tasks.startup_id = auth.uid()
        )
    );

-- ==========================================
-- 5. Helper Functions & Triggers
-- ==========================================

-- Function to update 'updated_at' timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_tasks_updated_at
BEFORE UPDATE ON public.tasks
FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();
