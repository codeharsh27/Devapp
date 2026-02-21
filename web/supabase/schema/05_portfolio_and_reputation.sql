-- ==========================================
-- 5. PORTFOLIO & REPUTATION
-- ==========================================

-- PORTFOLIO ITEMS TABLE
CREATE TABLE IF NOT EXISTS public.portfolio_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ADD COLUMNS SAFELY
ALTER TABLE public.portfolio_items ADD COLUMN IF NOT EXISTS description TEXT;
ALTER TABLE public.portfolio_items ADD COLUMN IF NOT EXISTS repo_url TEXT;
ALTER TABLE public.portfolio_items ADD COLUMN IF NOT EXISTS demo_url TEXT;
ALTER TABLE public.portfolio_items ADD COLUMN IF NOT EXISTS is_private BOOLEAN DEFAULT FALSE;
ALTER TABLE public.portfolio_items ADD COLUMN IF NOT EXISTS bounty_amount DECIMAL(10,2);
ALTER TABLE public.portfolio_items ADD COLUMN IF NOT EXISTS category TEXT;

-- RLS POLICIES FOR PORTFOLIO
ALTER TABLE public.portfolio_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public view portfolio" ON public.portfolio_items;
CREATE POLICY "Public view portfolio" 
ON public.portfolio_items FOR SELECT USING (true);

DROP POLICY IF EXISTS "Users manage own portfolio" ON public.portfolio_items;
CREATE POLICY "Users manage own portfolio" 
ON public.portfolio_items FOR ALL USING (auth.uid() = user_id);
