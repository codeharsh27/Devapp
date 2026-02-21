-- ==========================================
-- 3. SUBMISSIONS & WORKFLOW
-- ==========================================

-- SUBMISSIONS TABLE
CREATE TABLE IF NOT EXISTS public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
    developer_id UUID REFERENCES public.profiles(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ADD COLUMNS SAFELY
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS repo_url TEXT;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS demo_url TEXT;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS notes TEXT;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS status TEXT CHECK (status IN ('enrolled', 'pending', 'processing', 'evaluated', 'failed', 'hired')) DEFAULT 'enrolled';
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS ai_score INTEGER;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS final_score INTEGER;
ALTER TABLE public.submissions ADD COLUMN IF NOT EXISTS feedback TEXT;

-- RLS POLICIES FOR SUBMISSIONS
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

-- 1. Startups can view submissions ONLY for their own tasks
DROP POLICY IF EXISTS "Startups view submissions for their tasks" ON public.submissions;
CREATE POLICY "Startups view submissions for their tasks" 
ON public.submissions FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.tasks 
        WHERE public.tasks.id = submissions.task_id 
        AND public.tasks.startup_id = auth.uid()
    )
);

-- 2. Developers can view ONLY their own submissions
DROP POLICY IF EXISTS "Developers view own submissions" ON public.submissions;
CREATE POLICY "Developers view own submissions" 
ON public.submissions FOR SELECT USING (auth.uid() = developer_id);

-- 3. Developers can create submissions (Enroll)
DROP POLICY IF EXISTS "Developers can insert submissions" ON public.submissions;
CREATE POLICY "Developers can insert submissions" 
ON public.submissions FOR INSERT WITH CHECK (auth.uid() = developer_id);

-- 4. Developers can update their own submissions (Submit work)
DROP POLICY IF EXISTS "Developers can update own submissions" ON public.submissions;
CREATE POLICY "Developers can update own submissions" 
ON public.submissions FOR UPDATE USING (auth.uid() = developer_id);

-- 5. Startups can update submissions (Evaluate/Hire) for their tasks
DROP POLICY IF EXISTS "Startups can update submissions (evaluate)" ON public.submissions;
CREATE POLICY "Startups can update submissions (evaluate)" 
ON public.submissions FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM public.tasks 
        WHERE public.tasks.id = submissions.task_id 
        AND public.tasks.startup_id = auth.uid()
    )
);
