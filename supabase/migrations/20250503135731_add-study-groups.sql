CREATE TABLE study_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    isPublic BOOLEAN DEFAULT FALSE
);

CREATE TABLE study_group_members (
    study_group_id UUID REFERENCES study_groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT now(),
    PRIMARY KEY (study_group_id, user_id)
);


ALTER TABLE study_groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Read public study_groups"
  ON study_groups
  FOR SELECT
  TO authenticated
  USING (isPublic = true);

CREATE POLICY "Read private study_groups if member"
  ON study_groups
  FOR SELECT
  TO authenticated
  USING (
    isPublic = false AND
    EXISTS (
      SELECT 1 FROM study_group_members
      WHERE study_group_id = study_groups.id
        AND user_id = auth.uid()
    )
  );


ALTER TABLE study_group_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Read study_group_members if group is public or user is member"
  ON study_group_members
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM study_groups
      WHERE study_groups.id = study_group_members.study_group_id
        AND (
          study_groups.isPublic = true OR
          EXISTS (
            SELECT 1 FROM study_group_members AS sgm
            WHERE sgm.study_group_id = study_groups.id
              AND sgm.user_id = auth.uid()
          )
        )
    )
  );


ALTER TABLE goals
ADD COLUMN study_group_id UUID REFERENCES study_groups(id) ON DELETE CASCADE,
ADD COLUMN description TEXT DEFAULT '-';


create unique index one_goal_template_per_group
on goals(study_group_id)
where user_id is null;


create or replace function create_study_group(
  group_name text,
  group_description text,
  is_public boolean
)
returns void
language plpgsql
as $$
declare
  new_group_id uuid;
begin
  insert into study_groups (name, description, isPublic, owner_id)
  values (group_name, group_description, is_public, auth.uid())
  returning id into new_group_id;

  perform join_study_group(new_group_id);
end;
$$;


create or replace function join_study_group(
  p_study_group_id uuid
)
returns void
language plpgsql
as $$
begin
  insert into study_group_members (study_group_id, user_id)
  values (p_study_group_id, auth.uid())
  on conflict do nothing;

  perform join_goals(p_study_group_id);
end;
$$;


create or replace function join_goals(
  p_study_group_id uuid
)
returns void
language sql
as $$
  insert into goals (name, description, target_minutes, target_date, xp_reward, study_group_id, user_id)
  select
    g.name,
    g.description,
    g.target_minutes,
    g.target_date,
    g.xp_reward,
    g.study_group_id,
    auth.uid()
  from goals g
  where g.study_group_id = p_study_group_id
    and g.user_id is null;
$$;


create or replace function create_goal_template(
  name text,
  description text,
  study_group_id uuid,
  target_minutes int,
  target_date date,
  xp_reward int
)
returns void
language plpgsql
as $$
declare
  new_goal_id uuid;
begin
  insert into goals (
    name,
    description,
    study_group_id,
    target_minutes,
    target_date,
    xp_reward,
    user_id
  )
  values (
    name,
    description,
    study_group_id,
    target_minutes,
    target_date,
    xp_reward,
    null
  )
  returning id into new_goal_id;

  perform join_goals(study_group_id);
end;
$$;


create or replace function leave_or_delete_study_group(
  p_study_group_id uuid
)
returns void
language plpgsql
as $$
begin
  if exists (
    select 1
    from study_groups
    where id = p_study_group_id and owner_id = auth.uid()
  ) then
    -- Current user is the owner -> delete the group (cascades to members & goals)
    delete from study_groups where id = p_study_group_id;
  else
    -- Current user is a member -> just remove from membership
    delete from study_group_members
    where study_group_id = p_study_group_id
      and user_id = auth.uid();
  end if;
end;
$$;
