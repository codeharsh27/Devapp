-- Add Bio and Skills to Profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS skills TEXT[];

-- Create Portfolio Items Table
CREATE TABLE IF NOT EXISTS public.portfolio_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    
    title TEXT NOT NULL,
    description TEXT,
    category TEXT, -- 'Backend', 'Database', etc.
    repo_url TEXT,
    demo_url TEXT,
    
    status TEXT DEFAULT 'completed', 
    bounty_amount DECIMAL(10,2),
    
    is_private BOOLEAN DEFAULT FALSE,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS
ALTER TABLE public.portfolio_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public view portfolio" ON public.portfolio_items
    FOR SELECT USING (true);

CREATE POLICY "Users manage own portfolio" ON public.portfolio_items
    FOR ALL USING (auth.uid() = user_id);
