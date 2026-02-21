-- Add Bounty Amount to Tasks
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS bounty_amount DECIMAL(10,2) DEFAULT 0;
