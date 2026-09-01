alter table public.profiles
add column username text;

update public.profiles
set username = 'user_' || replace(id::text, '-', '')
where username is null;

alter table public.profiles
alter column username set not null;

alter table public.profiles
add constraint profiles_username_key unique (username);

alter table public.profiles
drop column display_name;

create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, username)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'username'
  )
  on conflict (id) do update set
    email = excluded.email;

  return new;
end;
$$;

revoke execute on function public.create_profile_for_new_user() from public, anon, authenticated;
