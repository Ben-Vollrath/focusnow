set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.decrement_credits(user_id uuid, decrement_by integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  current_credits int;
begin
  -- Lock the row for update
  select credits into current_credits from users where id = user_id for update;

  -- Ensure the user has enough credits
  if current_credits >= decrement_by then
    -- Decrement the credits
    update users
    set credits = credits - decrement_by
    where id = user_id;
  else
    raise exception 'Not enough credits';
  end if;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.refund_credits(user_id uuid, increment_by integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
  -- Increment the credits
  update users
  set credits = credits + increment_by
  where id = user_id;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  -- Add your custom logic here, for example:
  INSERT INTO public.users (id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$function$
;