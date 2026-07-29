alter table public.profiles
add column email text;

update public.profiles profile
set email = auth_user.email
from auth.users auth_user
where profile.id = auth_user.id
  and profile.email is null;

create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (new.id, new.email, new.raw_user_meta_data->>'display_name')
  on conflict (id) do update set
    email = excluded.email;

  return new;
end;
$$;

revoke execute on function public.create_profile_for_new_user() from public, anon, authenticated;
