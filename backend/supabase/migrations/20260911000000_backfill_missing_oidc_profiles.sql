insert into public.profiles (id, email, username, is_username_configured)
select
  auth_user.id,
  auth_user.email,
  case
    when auth_user.raw_app_meta_data->>'provider' = 'email'
      and nullif(auth_user.raw_user_meta_data->>'username', '') is not null
      then auth_user.raw_user_meta_data->>'username'
    else 'user_' || replace(auth_user.id::text, '-', '')
  end,
  auth_user.raw_app_meta_data->>'provider' = 'email'
    and nullif(auth_user.raw_user_meta_data->>'username', '') is not null
from auth.users auth_user
where auth_user.email is not null
  and not exists (
    select 1
    from public.profiles profile
    where profile.id = auth_user.id
  );
