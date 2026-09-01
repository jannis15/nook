alter table public.profiles
add column is_username_configured boolean not null default true;

create or replace function public.create_profile_for_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, username, is_username_configured)
  values (
    new.id,
    new.email,
    case
      when new.raw_app_meta_data->>'provider' = 'email' then new.raw_user_meta_data->>'username'
      else 'user_' || replace(new.id::text, '-', '')
    end,
    new.raw_app_meta_data->>'provider' = 'email'
  )
  on conflict (id) do update set
    email = excluded.email;

  return new;
end;
$$;

revoke execute on function public.create_profile_for_new_user() from public, anon, authenticated;
