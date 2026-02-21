-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. Reputation History (XP Audit)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.reputation_history (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount INT NOT NULL, -- e.g. +50, +300
    reason TEXT NOT NULL, -- 'task_completion', 'code_review', 'referral'
    reference_id UUID, -- e.g. task_id or submission_id
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.reputation_history ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users view own history" ON public.reputation_history;
CREATE POLICY "Users view own history" ON public.reputation_history
    FOR SELECT USING (auth.uid() = user_id);

-- ==========================================
-- 2. Transactions (Financial Ledger)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    sender_id UUID REFERENCES public.profiles(id), -- Startup
    receiver_id UUID REFERENCES public.profiles(id), -- Developer
    
    amount DECIMAL(10,2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    
    task_id UUID REFERENCES public.tasks(id),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed', 'refunded')),
    
    stripe_payment_id TEXT, -- Future real integration
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users view own transactions" ON public.transactions;
CREATE POLICY "Users view own transactions" ON public.transactions
    FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);


-- ==========================================
-- 3. Profile Enhancements (Wallet & XP)
-- ==========================================
-- Add columns if they don't exist (Idempotent)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'reputation_score') THEN
        ALTER TABLE public.profiles ADD COLUMN reputation_score INT DEFAULT 0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'profiles' AND column_name = 'wallet_balance') THEN
        ALTER TABLE public.profiles ADD COLUMN wallet_balance DECIMAL(10,2) DEFAULT 0.00;
    END IF;
END $$;
