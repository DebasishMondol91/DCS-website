-- Already applied to the Supabase project "DCS-website". Kept here for reference.
create table public.enquiries (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null check (char_length(name) between 1 and 120),
  phone text not null check (char_length(phone) between 5 and 30),
  email text not null check (char_length(email) between 5 and 160 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  service text check (service is null or char_length(service) <= 80),
  message text check (message is null or char_length(message) <= 3000),
  source_page text default 'contact',
  status text not null default 'new' check (status in ('new','contacted','closed'))
);
alter table public.enquiries enable row level security;
create policy "Anyone can submit an enquiry" on public.enquiries for insert to anon with check (status = 'new');
grant insert on public.enquiries to anon;
create index enquiries_created_at_idx on public.enquiries (created_at desc);
