set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public."deleteUser"()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  delete from auth.users where id = auth.uid();
END;$function$
;


