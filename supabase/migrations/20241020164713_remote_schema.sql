create type "public"."subscriptions" as enum ('free', 'starter', 'premium');

create table "public"."purchases" (
    "user_id" uuid not null default gen_random_uuid(),
    "purchase_token" text,
    "purchase_date" date,
    "subscription_type" subscriptions
);


alter table "public"."purchases" enable row level security;

alter table "public"."users" add column "subscription_expiration_date" date;

alter table "public"."users" add column "subscription_start_date" date;

alter table "public"."users" alter column "subscription_type" set default 'free'::subscriptions;

alter table "public"."users" alter column "subscription_type" drop not null;

alter table "public"."users" alter column "subscription_type" set data type subscriptions using "subscription_type"::subscriptions;

CREATE UNIQUE INDEX purchases_pkey ON public.purchases USING btree (user_id);

alter table "public"."purchases" add constraint "purchases_pkey" PRIMARY KEY using index "purchases_pkey";

alter table "public"."purchases" add constraint "purchases_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."purchases" validate constraint "purchases_user_id_fkey";

grant delete on table "public"."purchases" to "anon";

grant insert on table "public"."purchases" to "anon";

grant references on table "public"."purchases" to "anon";

grant select on table "public"."purchases" to "anon";

grant trigger on table "public"."purchases" to "anon";

grant truncate on table "public"."purchases" to "anon";

grant update on table "public"."purchases" to "anon";

grant delete on table "public"."purchases" to "authenticated";

grant insert on table "public"."purchases" to "authenticated";

grant references on table "public"."purchases" to "authenticated";

grant select on table "public"."purchases" to "authenticated";

grant trigger on table "public"."purchases" to "authenticated";

grant truncate on table "public"."purchases" to "authenticated";

grant update on table "public"."purchases" to "authenticated";

grant delete on table "public"."purchases" to "service_role";

grant insert on table "public"."purchases" to "service_role";

grant references on table "public"."purchases" to "service_role";

grant select on table "public"."purchases" to "service_role";

grant trigger on table "public"."purchases" to "service_role";

grant truncate on table "public"."purchases" to "service_role";

grant update on table "public"."purchases" to "service_role";


