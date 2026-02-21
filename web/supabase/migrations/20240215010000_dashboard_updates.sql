-- Allow 'enrolled' status and make repo_url nullable for initial enrollment
ALTER TABLE public.submissions 
DROP CONSTRAINT IF EXISTS submissions_status_check;

ALTER TABLE public.submissions
ADD CONSTRAINT submissions_status_check 
CHECK (status IN ('enrolled', 'pending', 'processing', 'evaluated', 'failed'));

ALTER TABLE public.submissions
ALTER COLUMN repo_url DROP NOT NULL;

-- Add index for faster stats counting
CREATE INDEX IF NOT EXISTS idx_submissions_developer_status ON public.submissions(developer_id, status);
CREATE INDEX IF NOT EXISTS idx_messages_unread ON public.messages(receiver_id, is_read) WHERE is_read = false;
