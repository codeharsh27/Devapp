-- ==========================================
-- PHASE 4: SECURITY HARDENING & RLS UPDATES
-- ==========================================

-- 1. Secure tasks table
-- Ensure only startups can create tasks
DROP POLICY IF EXISTS "Startups can insert their own tasks" ON public.tasks;
CREATE POLICY "Startups can insert their own tasks" ON public.tasks
    FOR INSERT WITH CHECK (
        auth.uid() = startup_id 
        AND EXISTS (
             SELECT 1 FROM public.profiles 
             WHERE profiles.id = auth.uid() 
             AND profiles.role IN ('Founder', 'Co-Founder', 'CTO', 'VP of Engineering', 'Head of Product', 'Product Manager', 'Engineering Lead')
        )
    );

-- 2. Create Task Secrets Table for Sensitive Data
CREATE TABLE IF NOT EXISTS public.task_secrets (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
    
    test_file_path TEXT,
    answer_key TEXT,
    env_vars JSONB,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.task_secrets ENABLE ROW LEVEL SECURITY;

-- Only the startup owner can see secrets
CREATE POLICY "Startup owner view secrets" ON public.task_secrets
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.tasks 
            WHERE tasks.id = task_secrets.task_id 
            AND tasks.startup_id = auth.uid()
        )
    );

-- Only startup owner can insert secrets
CREATE POLICY "Startup owner insert secrets" ON public.task_secrets
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.tasks 
            WHERE tasks.id = task_secrets.task_id 
            AND tasks.startup_id = auth.uid()
        )
    );

-- 3. Migrate sensitive data from task_criteria (cleanup)
-- (Assuming we want to move `test_file_path` from task_criteria to task_secrets)
-- Check if column exists first
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'task_criteria' AND column_name = 'test_file_path') THEN
        INSERT INTO public.task_secrets (task_id, test_file_path)
        SELECT task_id, test_file_path FROM public.task_criteria WHERE test_file_path IS NOT NULL;
        
        -- We won't drop the column yet to avoid breaking existing code immediately, 
        -- but we should update RLS for task_criteria if we keep it.
    END IF;
END $$;

-- 4. Tighten Submissions RLS
-- Ensure users cannot "update" their submission status to "evaluated" manually
DROP POLICY IF EXISTS "Devs can view own submissions" ON public.submissions;
DROP POLICY IF EXISTS "Devs can insert submissions" ON public.submissions;

CREATE POLICY "Devs can view own submissions" ON public.submissions
    FOR SELECT USING (auth.uid() = developer_id);

CREATE POLICY "Devs can insert submissions" ON public.submissions
    FOR INSERT WITH CHECK (
        auth.uid() = developer_id 
        -- Can only insert pending/open submissions?
    );

DROP POLICY IF EXISTS "Devs update own submissions" ON public.submissions;
CREATE POLICY "Devs update own submissions" ON public.submissions
    FOR UPDATE USING (auth.uid() = developer_id)
    WITH CHECK (
        auth.uid() = developer_id 
        AND (
           status IS NOT DISTINCT FROM 'pending' -- Can only update if pending (e.g. fix repo url)
           -- Cannot change status to 'evaluated'
        )
    );

-- 5. Internal Worker / Service Role Access
-- Supabase Service Role bypasses RLS, so no specific policy needed for the internal API worker 
-- as long as it uses the Service Key if running externally, OR if running in NextJS API 
-- it needs to be careful if it uses the USER client. 
-- Our Internal API Routes should use `createClient` (server) which uses the cookie (User) 
-- OR use a Service Client.
-- The `createClient` from `@supabase/ssr` typically uses the user's session.
-- IF the internal API is called via `fetch` from the server, it might not have the user session 
-- if we don't pass cookies. 
-- Ideally for "Internal Worker", we should use a Service Client. 
