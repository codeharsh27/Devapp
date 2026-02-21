-- ==========================================
-- 0. CLEANUP (Force Reset for Development)
-- ==========================================
-- Safe to run repeatedly; drops constraints first
ALTER TABLE IF EXISTS public.submissions DROP CONSTRAINT IF EXISTS submissions_task_id_fkey;
ALTER TABLE IF EXISTS public.submissions DROP CONSTRAINT IF EXISTS submissions_developer_id_fkey;
ALTER TABLE IF EXISTS public.tasks DROP CONSTRAINT IF EXISTS tasks_startup_id_fkey;

-- ==========================================
-- 1. PROFILES & ROLES
-- ==========================================
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    role TEXT CHECK (role IN ('talent', 'startup', 'admin', 'Founder', 'Co-Founder')),
    bio TEXT,
    skills TEXT[],
    website TEXT,
    reputation_score INTEGER DEFAULT 100,
    wallet_balance DECIMAL(10,2) DEFAULT 0.00,
    subscription_tier TEXT CHECK (subscription_tier IN ('free', 'pro')) DEFAULT 'free',
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- ==========================================
-- 2. TASKS (Drops)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    startup_id UUID REFERENCES public.profiles(id) NOT NULL,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    bounty_amount DECIMAL(10,2) DEFAULT 0,
    category TEXT CHECK (category IN ('frontend', 'backend', 'fullstack', 'mobile', 'ai', 'design', 'other')),
    difficulty_level INTEGER CHECK (difficulty_level BETWEEN 1 AND 5), -- 1=Easy, 5=Hard
    estimated_hours INTEGER,
    status TEXT CHECK (status IN ('open', 'in_progress', 'review', 'completed', 'cancelled')) DEFAULT 'open',
    repo_url TEXT, -- Can be NULL initially
    requirements TEXT[],
    is_promoted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_tasks_promoted ON public.tasks(is_promoted) WHERE is_promoted = TRUE;
CREATE INDEX IF NOT EXISTS idx_tasks_open ON public.tasks(status) WHERE status = 'open';

-- RLS
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Tasks are viewable by everyone" ON public.tasks FOR SELECT USING (true);
CREATE POLICY "Startups can insert tasks" ON public.tasks FOR INSERT WITH CHECK (auth.uid() = startup_id);
CREATE POLICY "Startups can update own tasks" ON public.tasks FOR UPDATE USING (auth.uid() = startup_id);


-- ==========================================
-- 3. SUBMISSIONS (Work)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE,
    developer_id UUID REFERENCES public.profiles(id),
    repo_url TEXT, -- Nullable for 'enrolled' status
    demo_url TEXT,
    notes TEXT,
    status TEXT CHECK (status IN ('enrolled', 'pending', 'processing', 'evaluated', 'failed', 'hired')) DEFAULT 'enrolled',
    ai_score INTEGER,
    final_score INTEGER, -- The "Official" score
    feedback TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Startups view submissions for their tasks" ON public.submissions FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.tasks WHERE public.tasks.id = submissions.task_id AND public.tasks.startup_id = auth.uid())
);
CREATE POLICY "Developers view own submissions" ON public.submissions FOR SELECT USING (auth.uid() = developer_id);
CREATE POLICY "Developers can insert submissions" ON public.submissions FOR INSERT WITH CHECK (auth.uid() = developer_id);
CREATE POLICY "Developers can update own submissions" ON public.submissions FOR UPDATE USING (auth.uid() = developer_id);
CREATE POLICY "Startups can update submissions (evaluate)" ON public.submissions FOR UPDATE USING (
    EXISTS (SELECT 1 FROM public.tasks WHERE public.tasks.id = submissions.task_id AND public.tasks.startup_id = auth.uid())
);

-- ==========================================
-- 4. PORTFOLIO (Proof of Work)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.portfolio_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    repo_url TEXT,
    demo_url TEXT,
    is_private BOOLEAN DEFAULT FALSE,
    bounty_amount DECIMAL(10,2),
    category TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.portfolio_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public view portfolio" ON public.portfolio_items FOR SELECT USING (true);
CREATE POLICY "Users manage own portfolio" ON public.portfolio_items FOR ALL USING (auth.uid() = user_id);

-- ==========================================
-- 5. CHAT & CONVERSATIONS
-- ==========================================
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.conversation_participants (
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.profiles(id),
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS for Chat
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view their conversations" ON public.conversations FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.conversation_participants WHERE conversation_id = id AND user_id = auth.uid())
);

ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view participants in their chats" ON public.conversation_participants FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.conversation_participants cp WHERE cp.conversation_id = conversation_id AND cp.user_id = auth.uid())
);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view messages in their chats" ON public.messages FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.conversation_participants WHERE conversation_id = messages.conversation_id AND user_id = auth.uid())
);
CREATE POLICY "Users send messages to their chats" ON public.messages FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (SELECT 1 FROM public.conversation_participants WHERE conversation_id = messages.conversation_id AND user_id = auth.uid())
);

-- Helper Function: Create Chat
CREATE OR REPLACE FUNCTION get_or_create_conversation(other_user_id UUID)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    conv_id UUID;
BEGIN
    SELECT cp1.conversation_id INTO conv_id
    FROM conversation_participants cp1
    JOIN conversation_participants cp2 ON cp1.conversation_id = cp2.conversation_id
    WHERE cp1.user_id = auth.uid() AND cp2.user_id = other_user_id
    LIMIT 1;

    IF conv_id IS NOT NULL THEN
        RETURN conv_id;
    END IF;

    INSERT INTO conversations DEFAULT VALUES RETURNING id INTO conv_id;
    INSERT INTO conversation_participants (conversation_id, user_id) VALUES (conv_id, auth.uid());
    INSERT INTO conversation_participants (conversation_id, user_id) VALUES (conv_id, other_user_id);

    RETURN conv_id;
END;
$$;

-- ==========================================
-- 6. REALTIME ENABLEMENT
-- ==========================================
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime;
COMMIT;
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
