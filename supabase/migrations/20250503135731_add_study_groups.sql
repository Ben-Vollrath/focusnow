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

ALTER TABLE goals
ADD COLUMN study_group_id UUID REFERENCES study_groups(id) ON DELETE CASCADE,
ADD COLUMN description TEXT DEFAULT '-';

create unique index one_goal_template_per_group
on goals(study_group_id)
where user_id is null;

create unique index one_goal_per_user_per_group
on goals(study_group_id, user_id)
where user_id is not null;

ALTER TABLE goals DROP CONSTRAINT one_goal_per_user;
DROP POLICY IF EXISTS "Users can read their own goals" ON goals;
DROP POLICY IF EXISTS "Users can read delete their goals" ON goals;
CREATE POLICY "Authenticated users can read all goals"
  ON goals
  FOR SELECT
  TO authenticated
  USING (true);


create or replace view  study_group_stats as
select
  sg.id,
  sg.name,
  sg.description,
  sg.created_at,
  sg.isPublic,
  sg.owner_id,
  count(distinct sgm.user_id) as member_count,
  coalesce((
    select g.target_minutes
    from goals g
    where g.study_group_id = sg.id
      and g.user_id is null
    limit 1
  )) as total_goal_minutes,
  (
    select g.target_date
    from goals g
    where g.study_group_id = sg.id
      and g.user_id is null
    limit 1
  ) as goal_date
from study_groups sg
left join study_group_members sgm on sgm.study_group_id = sg.id
group by sg.id;



create or replace view goal_progress_leaderboard 
with (security_barrier = true) as
select
  g.study_group_id,
  u.id as user_id,
  u.username,
  g.current_minutes,
  g.target_minutes
from goals g
join users u on g.user_id = u.id
where g.study_group_id is not null and g.user_id is not null;



ALTER TABLE study_groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Read public study_groups"
  on study_groups
  FOR SELECT
  TO authenticated
  USING (true);


ALTER TABLE study_group_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated users can read study group memberships"
on study_group_members
  FOR SELECT
  TO authenticated
  USING (true);

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
$$ SECURITY DEFINER;


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
$$ SECURITY DEFINER;

--- TODO RLS

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
$$ SECURITY DEFINER;


create or replace function create_goal_template(
  name text,
  description text,
  study_group_id uuid,
  target_date date,
  target_minutes int
)
returns void
language plpgsql
as $$
declare
  new_goal_id uuid;
  current_user_id uuid := auth.uid();
  group_owner_id uuid;
begin
  -- Fetch the group's owner
  select owner_id
  into group_owner_id
  from study_groups
  where id = study_group_id;

  -- Check ownership
  if group_owner_id is null or group_owner_id != current_user_id then
    raise exception 'Only the study group owner can create a goal template.';
  end if;

  -- Insert the goal template
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
    target_minutes / 20,
    null
  )
  returning id into new_goal_id;

  -- Automatically join the goal if needed
  perform join_goals(study_group_id);
end;
$$ security definer;


create or replace function delete_goal_template(group_id uuid)
returns void
language plpgsql
as $$
declare
  current_user_id uuid := auth.uid();
  group_owner_id uuid;
begin
  -- Get the group's owner
  select owner_id
  into group_owner_id
  from study_groups
  where id = group_id;

  -- Authorization check
  if group_owner_id is null or group_owner_id != current_user_id then
    raise exception 'Only the study group owner can delete the goal template.';
  end if;

  -- Delete the template goal (where user_id is null)
  delete from goals
  where study_group_id = group_id;
end;
$$ security definer;



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

    delete from goals
    where study_group_id = p_study_group_id
      and user_id = auth.uid()
      and study_group_id is not null;
  end if;
end;
$$ SECURITY DEFINER;

