revoke delete on table "public"."purchases" from "anon";

revoke insert on table "public"."purchases" from "anon";

revoke references on table "public"."purchases" from "anon";

revoke select on table "public"."purchases" from "anon";

revoke trigger on table "public"."purchases" from "anon";

revoke truncate on table "public"."purchases" from "anon";

revoke update on table "public"."purchases" from "anon";

revoke delete on table "public"."purchases" from "authenticated";

revoke insert on table "public"."purchases" from "authenticated";

revoke references on table "public"."purchases" from "authenticated";

revoke select on table "public"."purchases" from "authenticated";

revoke trigger on table "public"."purchases" from "authenticated";

revoke truncate on table "public"."purchases" from "authenticated";

revoke update on table "public"."purchases" from "authenticated";

revoke delete on table "public"."purchases" from "service_role";

revoke insert on table "public"."purchases" from "service_role";

revoke references on table "public"."purchases" from "service_role";

revoke select on table "public"."purchases" from "service_role";

revoke trigger on table "public"."purchases" from "service_role";

revoke truncate on table "public"."purchases" from "service_role";

revoke update on table "public"."purchases" from "service_role";

alter table "public"."purchases" drop constraint "purchases_user_id_fkey";

alter table "public"."purchases" drop constraint "purchases_pkey";

drop index if exists "public"."purchases_pkey";

drop table "public"."purchases";

alter type "public"."subscriptions" rename to "subscriptions__old_version_to_be_dropped";

create type "public"."subscriptions" as enum ('subscription_free', 'subscription_starter', 'subscription_premium');


alter table "public"."users" drop column "subscription_expiration_date";

alter table "public"."users" drop column "subscription_start_date";

alter table "public"."users" drop column "subscription_type";

alter table "public"."users" add column "isPremium" boolean not null default false;

alter table "public"."users" add column "transaction_id" text default ''::text;

alter table "public"."users" alter column "credits" set default 3;



drop type "public"."subscriptions__old_version_to_be_dropped";