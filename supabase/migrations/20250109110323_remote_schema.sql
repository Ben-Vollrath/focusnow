drop function if exists "public"."refund_credits"(user_id uuid, increment_by integer, column_name text);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.decrement_credits(user_id uuid, decrement_by integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  current_credits int;
  current_purchased_credits int;
begin
  -- Lock the row for update
  select credits, purchased_credits 
  into current_credits, current_purchased_credits
  from users 
  where id = user_id 
  for update;

  -- Check and decrement from credits first
  if current_credits >= decrement_by then
    update users
    set credits = credits - decrement_by
    where id = user_id;
    return 'credits';
  
  -- If credits are insufficient, check purchased_credits
  elsif current_purchased_credits >= decrement_by then
    update users
    set purchased_credits = purchased_credits - decrement_by
    where id = user_id;
    return 'purchased_credits';
  
  -- If both are insufficient, raise an error
  else
    raise exception 'Not enough credits in both credits and purchased_credits';
  end if;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.decrement_user_credits(user_id uuid, decrement_by integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
  current_credits int;
  current_purchased_credits int;
begin
  -- Lock the row for update
  select credits, purchased_credits 
  into current_credits, current_purchased_credits
  from users 
  where id = user_id 
  for update;

  -- Check and decrement from credits first
  if current_credits >= decrement_by then
    update users
    set credits = credits - decrement_by
    where id = user_id;
    return 'credits';
  
  -- If credits are insufficient, check purchased_credits
  elsif current_purchased_credits >= decrement_by then
    update users
    set purchased_credits = purchased_credits - decrement_by
    where id = user_id;
    return 'purchased_credits';
  
  -- If both are insufficient, raise an error
  else
    raise exception 'Not enough credits in both credits and purchased_credits';
  end if;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.increment_purchased_credits(user_id uuid, increment_value integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Update the purchased_credits field
    UPDATE users
    SET purchased_credits = purchased_credits + increment_value
    WHERE id = user_id;
    
    -- Ensure the function raises an exception if no rows were updated
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User with id % does not exist', user_id;
    END IF;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.refund_credits(user_id uuid, increment_by integer, column_name text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
begin
  if column_name = 'credits' then
    -- Increment the credits column
    update users
    set credits = credits + increment_by
    where id = user_id;
  elsif column_name = 'purchased_credits' then
    -- Increment the purchased_credits column
    update users
    set purchased_credits = purchased_credits + increment_by
    where id = user_id;
  else
    raise exception 'Invalid column name: %', column_name;
  end if;
end;
$function$
;


