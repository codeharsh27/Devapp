-- Migration to support platform monetization features

-- 1. Add promotion status to tasks
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS is_promoted BOOLEAN DEFAULT FALSE;

-- 2. Add verification and subscription status to profiles
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS subscription_tier TEXT CHECK (subscription_tier IN ('free', 'pro')) DEFAULT 'free';
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT FALSE;

-- 3. Add hiring status to submissions
-- 'hired' status indicates the startup has accepted the submission for employment/contract
ALTER TABLE submissions DROP CONSTRAINT IF EXISTS submissions_status_check;
ALTER TABLE submissions ADD CONSTRAINT submissions_status_check 
    CHECK (status IN ('enrolled', 'pending', 'processing', 'evaluated', 'failed', 'hired'));

-- 4. Create an index for faster querying of promoted tasks
CREATE INDEX IF NOT EXISTS idx_tasks_promoted ON tasks(is_promoted) WHERE is_promoted = TRUE;
