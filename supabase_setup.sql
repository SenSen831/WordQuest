create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  section text not null,
  hearts int not null default 0,
  coins int not null default 0,
  keys int not null default 3,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
create index if not exists profiles_hearts_idx on public.profiles (hearts desc);
alter table public.profiles enable row level security;
create policy "Signed-in players can read profiles" on public.profiles for
select to authenticated using (true);
create policy "Players insert their own profile" on public.profiles for
insert to authenticated with check (auth.uid() = id);
create policy "Players update their own profile" on public.profiles for
update to authenticated using (auth.uid() = id) with check (auth.uid() = id);