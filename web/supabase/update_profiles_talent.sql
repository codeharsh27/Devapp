-- Add columns for Talent Profile
alter table public.profiles 
add column if not exists full_name text,
add column if not exists job_title text,
add column if not exists portfolio_url text,
add column if not exists resume_url text,
add column if not exists skills text[]; -- Array of strings for skills

-- Add a column to distinguish if the profile is fully onboarded or not
add column if not exists onboarded boolean default false;
