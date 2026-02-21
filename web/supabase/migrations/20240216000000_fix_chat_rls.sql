-- Create tables if not exist
CREATE TABLE IF NOT EXISTS public.conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.conversation_participants (
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (conversation_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES public.conversations(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    is_read BOOLEAN DEFAULT FALSE
);

-- Ensure correct foreign key for participants to allow joining with profiles
DO $$ BEGIN
    ALTER TABLE public.conversation_participants
    DROP CONSTRAINT IF EXISTS conversation_participants_user_id_fkey;

    ALTER TABLE public.conversation_participants
    ADD CONSTRAINT conversation_participants_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
EXCEPTION
    WHEN undefined_table THEN
        -- If profiles table doesn't exist yet, we can't add the constraint. 
        -- Assume it exists or will be created.
        NULL;
    WHEN others THEN
        RAISE NOTICE 'Error altering constraint: %', SQLERRM;
END $$;

-- Enable RLS
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- 1. Policies for CONVERSATIONS
DROP POLICY IF EXISTS "Users can view their conversations" ON public.conversations;
CREATE POLICY "Users can view their conversations" ON public.conversations
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.conversation_participants cp
        WHERE cp.conversation_id = id
        AND cp.user_id = auth.uid()
    )
);

-- 2. Policies for PARTICIPANTS
DROP POLICY IF EXISTS "Users view their participations" ON public.conversation_participants;
DROP POLICY IF EXISTS "Users can view conversation participants" ON public.conversation_participants;

CREATE POLICY "Users can view conversation participants" ON public.conversation_participants
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.conversation_participants cp
        WHERE cp.conversation_id = conversation_participants.conversation_id
        AND cp.user_id = auth.uid()
    )
);

-- 3. Policies for MESSAGES
DROP POLICY IF EXISTS "Users view messages" ON public.messages;
CREATE POLICY "Users view messages" ON public.messages
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.conversation_participants cp
        WHERE cp.conversation_id = conversation_id
        AND cp.user_id = auth.uid()
    )
);

DROP POLICY IF EXISTS "Users insert messages" ON public.messages;
CREATE POLICY "Users insert messages" ON public.messages
FOR INSERT WITH CHECK (
    auth.uid() = sender_id AND
    EXISTS (
        SELECT 1 FROM public.conversation_participants cp
        WHERE cp.conversation_id = conversation_id
        AND cp.user_id = auth.uid()
    )
);

-- 4. RPC Function to create conversation atomically
-- This bypasses RLS to allow creating the conversation and participants simultaneously
CREATE OR REPLACE FUNCTION create_new_conversation(other_user_id UUID)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_id UUID;
BEGIN
  -- Check if conversation already exists between these two
  SELECT cp1.conversation_id INTO new_id
  FROM conversation_participants cp1
  JOIN conversation_participants cp2 ON cp1.conversation_id = cp2.conversation_id
  WHERE cp1.user_id = auth.uid()
  AND cp2.user_id = other_user_id
  LIMIT 1;

  IF new_id IS NOT NULL THEN
    RETURN new_id;
  END IF;

  -- Create new conversation
  INSERT INTO conversations DEFAULT VALUES
  RETURNING id INTO new_id;

  -- Add participants
  INSERT INTO conversation_participants (conversation_id, user_id)
  VALUES
    (new_id, auth.uid()),
    (new_id, other_user_id);

  RETURN new_id;
END;
$$;
