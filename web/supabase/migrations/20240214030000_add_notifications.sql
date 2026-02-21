-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. Notifications Table
-- ==========================================
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    type TEXT CHECK (type IN ('system', 'submission_update', 'payment_received', 'new_task')),
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    action_link TEXT, -- Optional URL to redirect
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users view own notifications" ON public.notifications;
CREATE POLICY "Users view own notifications" ON public.notifications
    FOR SELECT USING (auth.uid() = user_id);

-- ==========================================
-- 2. Realtime Enablement
-- ==========================================
-- Add table to publication to enable Realtime
-- Note: 'supabase_realtime' publication usually exists by default on Supabase for 'postgres' role
-- We need to ensure it includes this table.
-- Locally we can't easily check publication content, but we can try to add it safely.

BEGIN;
  -- Create publication if not exists (Standard Supabase setup usually has it)
  -- ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
  -- If this fails (e.g. publication doesn't exist), you can create it:
  -- CREATE PUBLICATION supabase_realtime FOR TABLE public.notifications;
COMMIT;

-- Enable Realtime for notifications table
DO $$
BEGIN
  -- Check if publication exists first (standard Supabase setup)
  IF EXISTS (SELECT 1 FROM pg_publication WHERE pubname = 'supabase_realtime') THEN
    -- Check if table is not already in publication
    IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'notifications') THEN
      ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
    END IF;
  END IF;
END $$;
