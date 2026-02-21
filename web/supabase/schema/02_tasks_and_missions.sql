-- ==========================================
-- 2. TASKS & MISSIONS
-- ==========================================

-- TASKS TABLE (DROPS)
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    startup_id UUID REFERENCES public.profiles(id) NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ADD COLUMNS SAFELY (Idempotent)
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS bounty_amount DECIMAL(10,2) DEFAULT 0;
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS category TEXT CHECK (category IN ('frontend', 'backend', 'fullstack', 'mobile', 'ai', 'design', 'other'));
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5);
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS estimated_hours INTEGER;
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS status TEXT CHECK (status IN ('open', 'in_progress', 'review', 'completed', 'cancelled')) DEFAULT 'open';
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS repo_url TEXT;
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS requirements TEXT[];
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS is_promoted BOOLEAN DEFAULT FALSE;

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_tasks_promoted ON public.tasks(is_promoted) WHERE is_promoted = TRUE;
CREATE INDEX IF NOT EXISTS idx_tasks_open ON public.tasks(status) WHERE status = 'open';

-- RLS POLICIES FOR TASKS
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Tasks are viewable by everyone" ON public.tasks;
CREATE POLICY "Tasks are viewable by everyone" 
ON public.tasks FOR SELECT USING (true);

DROP POLICY IF EXISTS "Startups can insert tasks" ON public.tasks;
CREATE POLICY "Startups can insert tasks" 
ON public.tasks FOR INSERT WITH CHECK (auth.uid() = startup_id);

DROP POLICY IF EXISTS "Startups can update own tasks" ON public.tasks;
CREATE POLICY "Startups can update own tasks" 
ON public.tasks FOR UPDATE USING (auth.uid() = startup_id);

DROP POLICY IF EXISTS "Startups can delete own tasks" ON public.tasks;
CREATE POLICY "Startups can delete own tasks" 
ON public.tasks FOR DELETE USING (auth.uid() = startup_id);
