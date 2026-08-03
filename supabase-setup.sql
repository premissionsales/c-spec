-- C-SPEC: single-table shared-workspace storage (no login required)
-- Stores the entire specs list and products list as two JSON blobs,
-- mirroring how the app already stores them in browser localStorage.

create table if not exists app_data (
  id text primary key,
  data jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table app_data enable row level security;

-- No login: allow anyone with the anon key (i.e. anyone with the site URL)
-- to read and write. This matches the "shared workspace, no login" choice.
create policy "public read" on app_data for select using (true);
create policy "public write" on app_data for insert with check (true);
create policy "public update" on app_data for update using (true);

insert into app_data (id, data) values ('specs', '[]'::jsonb) on conflict (id) do nothing;
insert into app_data (id, data) values ('products', '[]'::jsonb) on conflict (id) do nothing;
