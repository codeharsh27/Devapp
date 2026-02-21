-- ==========================================
-- 99. FUNCTIONS & REALTIME
-- ==========================================

-- HELPER: GET OR CREATE CONVERSATION
-- Ensures atomic creation of chat rooms between two users.
CREATE OR REPLACE FUNCTION get_or_create_conversation(other_user_id UUID)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    conv_id UUID;
BEGIN
    -- Check if a conversation already exists between these two users
    SELECT cp1.conversation_id INTO conv_id
    FROM conversation_participants cp1
    JOIN conversation_participants cp2 ON cp1.conversation_id = cp2.conversation_id
    WHERE cp1.user_id = auth.uid() AND cp2.user_id = other_user_id
    LIMIT 1;

    IF conv_id IS NOT NULL THEN
        RETURN conv_id;
    END IF;

    -- Create new conversation
    INSERT INTO conversations DEFAULT VALUES RETURNING id INTO conv_id;
    
    -- Add participants
    INSERT INTO conversation_participants (conversation_id, user_id) VALUES (conv_id, auth.uid());
    INSERT INTO conversation_participants (conversation_id, user_id) VALUES (conv_id, other_user_id);

    RETURN conv_id;
END;
$$;

-- REALTIME CONFIGURATION
-- Enables Supabase Realtime for critical tables (Chat, Notifications).
BEGIN;
  -- Drop existing publication to avoid conflicts/errors
  DROP PUBLICATION IF EXISTS supabase_realtime;
  
  -- Create publication
  CREATE PUBLICATION supabase_realtime;
COMMIT;

-- Add tables to publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE public.tasks; -- For live updates on task status
ALTER PUBLICATION supabase_realtime ADD TABLE public.submissions; -- For live updates on status changes (Evaluated/Hired)
