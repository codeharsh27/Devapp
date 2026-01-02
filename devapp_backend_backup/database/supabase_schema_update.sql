-- Run these commands in your Supabase SQL Editor to add the missing columns to your 'profiles' table.
-- This ensures that Bio, Social Links, and other profile details can be saved correctly.

ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS email text,
ADD COLUMN IF NOT EXISTS bio text,
ADD COLUMN IF NOT EXISTS phone text,
ADD COLUMN IF NOT EXISTS location text,
ADD COLUMN IF NOT EXISTS linkedin_url text,
ADD COLUMN IF NOT EXISTS github_url text,
ADD COLUMN IF NOT EXISTS x_url text,
ADD COLUMN IF NOT EXISTS skills text[],
ADD COLUMN IF NOT EXISTS interests text[],
ADD COLUMN IF NOT EXISTS preferred_roles text[],
ADD COLUMN IF NOT EXISTS preferred_locations text[],
ADD COLUMN IF NOT EXISTS learning_goals text,
ADD COLUMN IF NOT EXISTS experience_level text,
ADD COLUMN IF NOT EXISTS job_type text,
ADD COLUMN IF NOT EXISTS role text,
ADD COLUMN IF NOT EXISTS resume_url text;
