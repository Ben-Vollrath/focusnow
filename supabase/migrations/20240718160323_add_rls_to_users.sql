create policy "Enable delete for users based on user_id"
on "public"."users"
as permissive
for delete
to public
using ((( SELECT auth.uid() AS uid) = id));


create policy "Enable insert for users based on user_id"
on "public"."users"
as permissive
for insert
to public
with check ((( SELECT auth.uid() AS uid) = id));


create policy "Enable select for users based on user_id"
on "public"."users"
as permissive
for select
to public
using ((( SELECT auth.uid() AS uid) = id));