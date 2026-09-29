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

-- Downloadable lesson-content catalog. Content files are configured separately
-- in Storage; this table only exposes metadata needed to discover active packs.
create table if not exists public.content_packs (
  id text primary key,
  slug text not null unique,
  title text not null,
  description text not null,
  version integer not null check (version > 0),
  size_bytes bigint not null check (size_bytes >= 0),
  download_url text not null,
  checksum text not null check (checksum ~ '^[a-fA-F0-9]{64}$'),
  min_app_version text not null,
  lesson_count integer not null check (lesson_count >= 0),
  category text not null,
  language text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.content_packs enable row level security;

grant select on table public.content_packs to anon, authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'content_packs'
      and policyname = 'Anyone can read active content packs'
  ) then
    create policy "Anyone can read active content packs"
    on public.content_packs for select to anon, authenticated
    using (is_active = true);
  end if;
end
$$;

-- Create a private `media` bucket in Storage. Add upload/download policies only
-- for authenticated teachers/admins after you introduce server-controlled roles.
