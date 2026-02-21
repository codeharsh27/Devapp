-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. Conversations (Chat Rooms)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id), -- Optional: context
    
    -- Using Array for participants simplified (Supabase supports ANY query)
    -- Ideally, a junction table `conversation_participants` is cleaner for many-to-many,
    -- but for 1:1 or small group, array is fine for MVP. Let's use junction for proper SQL.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Junction Table for Participants
CREATE TABLE IF NOT EXISTS public.conversation_participants (
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    last_read_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (conversation_id, user_id)
);

-- RLS for Conversations: User must be a participant
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users view their conversations" ON public.conversations;
CREATE POLICY "Users view their conversations" ON public.conversations
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.conversation_participants cp 
            WHERE cp.conversation_id = id AND cp.user_id = auth.uid()
        )
    );

ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users view their participations" ON public.conversation_participants;
CREATE POLICY "Users view their participations" ON public.conversation_participants
    FOR SELECT USING (user_id = auth.uid());


-- ==========================================
-- 2. Messages
-- ==========================================
CREATE TABLE IF NOT EXISTS public.messages (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES public.profiles(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS for Messages: Must be participant of conversation
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Participants view messages" ON public.messages;
CREATE POLICY "Participants view messages" ON public.messages
    FOR SELECT USING (
         EXISTS (
            SELECT 1 FROM public.conversation_participants cp 
            WHERE cp.conversation_id = messages.conversation_id AND cp.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Participants insert messages" ON public.messages;
CREATE POLICY "Participants insert messages" ON public.messages
    FOR INSERT WITH CHECK (
         EXISTS (
            SELECT 1 FROM public.conversation_participants cp 
            WHERE cp.conversation_id = messages.conversation_id AND cp.user_id = auth.uid()
        )
    );

-- ==========================================
-- 3. Realtime Enablement
-- ==========================================
-- Enable Realtime for messages table
DO $$
BEGIN
  -- Check if publication exists first (standard Supabase setup)
  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    -- Check if table is not already in publication
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'messages') THEN
      ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
    END IF;
  END IF;
END $$;
