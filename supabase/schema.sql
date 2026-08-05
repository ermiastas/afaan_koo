-- Run this in the Supabase SQL editor before enabling adult dashboards.
create table if not exists public.progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  completed_lessons jsonb not null default '{}'::jsonb,
  stars integer not null default 0 check (stars >= 0),
  updated_at timestamptz not null default now()
);

alter table public.progress enable row level security;

create policy "Adults can read their own progress"
on public.progress for select to authenticated
using (auth.uid() = user_id);

create policy "Adults can create their own progress"
on public.progress for insert to authenticated
with check (auth.uid() = user_id);

create policy "Adults can update their own progress"
on public.progress for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Create a private `media` bucket in Storage. Add upload/download policies only
-- for authenticated teachers/admins after you introduce server-controlled roles.
