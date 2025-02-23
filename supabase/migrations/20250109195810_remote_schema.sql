drop policy "Enable read access for auth users" on "public"."themes";

alter table "public"."image_generation_logs" drop constraint "image_generation_logs_theme_id_fkey";

alter table "public"."themes" add column "examples" text[] not null default '{}'::text[];

alter table "public"."themes" disable row level security;

alter table "public"."image_generation_logs" add constraint "image_generation_logs_theme_id_fkey" FOREIGN KEY (theme_id) REFERENCES themes(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."image_generation_logs" validate constraint "image_generation_logs_theme_id_fkey";

create or replace view "public"."theme_information" as  SELECT themes.id,
    themes.image_url,
    themes.name,
    themes."isFeatured",
    themes.tags,
    themes."order",
    themes.examples
   FROM themes;



