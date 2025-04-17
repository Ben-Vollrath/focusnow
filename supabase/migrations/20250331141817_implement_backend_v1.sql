-- challenge_category enum
CREATE TYPE challenge_category AS ENUM ('daily_sessions', 'streak_days', 'total_hours', 'total_sessions');

-- levels table
CREATE TABLE levels (
  level INT PRIMARY KEY,
  xp_required INT NOT NULL,
  name TEXT NOT NULL,
  icon TEXT
);
ALTER TABLE levels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated read access"
  ON levels
  FOR SELECT
  TO authenticated
  USING (true);

-- challenges table
CREATE TABLE challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT NOT NULL,
  category challenge_category NOT NULL,
  condition_amount INT NOT NULL,
  reward_xp INT NOT NULL,
  is_repeatable BOOLEAN DEFAULT FALSE NOT NULL,
  difficulty INT NOT NULL
);
CREATE UNIQUE INDEX unique_challenge_type_difficulty
ON challenges (category, difficulty);
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated read access"
  ON challenges
  FOR SELECT
  TO authenticated
  USING (true);

-- users table
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT NOT NULL,
  level INT REFERENCES levels(level) DEFAULT 1,
  xp INT DEFAULT 0,
  total_study_time INT DEFAULT 0,
  total_study_sessions INT DEFAULT 0

);
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read their own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (id = auth.uid());


-- goals table
CREATE TABLE goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  target_minutes INT NOT NULL,
  current_minutes INT DEFAULT 0,
  target_date DATE,
  created_at TIMESTAMPTZ DEFAULT now(),
  xp_reward INT,
  completed BOOLEAN DEFAULT FALSE
);

ALTER TABLE goals
ADD CONSTRAINT one_goal_per_user UNIQUE (user_id);

ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read their own goals"
  ON goals
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read delete their goals"
  ON goals
  FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());

-- study_sessions table
CREATE TABLE study_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  duration INT
);
ALTER TABLE study_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read their own study sessions"
  ON study_sessions
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- study_days table
CREATE TABLE study_days (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  study_date DATE NOT NULL,
  total_study_time INT DEFAULT 0,
  total_study_sessions INT DEFAULT 1,
  streak_day INT DEFAULT 0,
  UNIQUE(user_id, study_date)  -- ensures one entry per day per user
);

ALTER TABLE study_days ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read their own study days"
  ON study_days
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- challenge_progress table
CREATE TABLE challenge_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES challenges(id) ON DELETE CASCADE,
  completed BOOLEAN DEFAULT FALSE,
  progress INT DEFAULT 0,
  last_updated TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE challenge_progress
ADD CONSTRAINT unique_user_challenger
UNIQUE (user_id, challenge_id);

ALTER TABLE challenge_progress ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can read their own challenge progress"
  ON challenge_progress
  FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

--- Create new user on auth signup

CREATE OR REPLACE FUNCTION handle_new_auth_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id)
  VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION handle_new_auth_user();

--- Username Generator

CREATE TABLE username_words (
  word TEXT,
  type TEXT, 
  PRIMARY KEY (type, word)
);


CREATE OR REPLACE FUNCTION assign_structured_username()
RETURNS TRIGGER AS $$
DECLARE
  verb TEXT;
  animal TEXT;
BEGIN
  -- Pick a random verb
  SELECT word INTO verb
  FROM public.username_words
  WHERE type = 'verb'
  ORDER BY random()
  LIMIT 1;

  -- Pick a random animal
  SELECT word INTO animal
  FROM public.username_words
  WHERE type = 'animal'
  ORDER BY random()
  LIMIT 1;

  -- Combine into username
  NEW.username := LOWER(verb || ' ' || animal);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;



CREATE TRIGGER structured_username_trigger
  BEFORE INSERT ON users
  FOR EACH ROW
  WHEN (NEW.username IS NULL)
  EXECUTE FUNCTION assign_structured_username();



CREATE OR REPLACE FUNCTION increment_user_xp(p_user_id UUID, amount INT)
RETURNS VOID AS $$
DECLARE
  current_level INT;
  current_xp INT;
  next_level_xp INT;
BEGIN
  UPDATE users
  SET xp = xp + amount
  WHERE id = p_user_id;

  --- Level up user when needed
  LOOP
    -- Get the user's current level and xp
    SELECT level, xp INTO current_level, current_xp
    FROM users
    WHERE id = p_user_id;

    -- Get the XP required for the next level
    SELECT xp_required INTO next_level_xp
    FROM levels
    WHERE level = current_level + 1;

    -- Stop if no next level (user is at max level)
    EXIT WHEN next_level_xp IS NULL;

    -- Stop if user doesn't have enough XP
    EXIT WHEN current_xp < next_level_xp;

    -- Level up: subtract xp and increment level
    UPDATE users
    SET
      level = level + 1,
      xp = xp - next_level_xp
    WHERE id = p_user_id;
  END LOOP;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_study_day(
  p_user_id UUID,
  p_study_date DATE,
  p_yesterday DATE,
  p_duration_minutes INT
)
RETURNS VOID AS $$
DECLARE
  previous_streak INT := 0;
BEGIN
  -- Get yesterday's streak_day if it exists
  SELECT streak_day INTO previous_streak
  FROM study_days
  WHERE user_id = p_user_id AND study_date = p_yesterday;

  -- Upsert today's row with updated time and calculated streak
  INSERT INTO study_days (
    user_id,
    study_date,
    total_study_time,
    total_study_sessions,
    streak_day
  )
  VALUES (
    p_user_id,
    p_study_date,
    p_duration_minutes,
    1,
    CASE
      WHEN previous_streak > 0 THEN previous_streak + 1
      ELSE 1
    END
  )
  ON CONFLICT (user_id, study_date)
  DO UPDATE SET
    total_study_time = study_days.total_study_time + EXCLUDED.total_study_time,
    total_study_sessions = study_days.total_study_sessions + 1,
    streak_day = CASE
      WHEN previous_streak > 0 THEN previous_streak + 1
      ELSE 1
    END;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION increment_user_total_information(
  p_user_id UUID,
  p_duration_minutes INT
)
RETURNS VOID AS $$
BEGIN
  UPDATE users
  SET
    total_study_time = total_study_time + p_duration_minutes,
    total_study_sessions = total_study_sessions + 1
  WHERE id = p_user_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_goal_progress(
  p_user_id UUID,
  p_session_date DATE,
  p_duration_minutes INT
)
RETURNS INT AS $$
DECLARE
  goal_xp_to_add INT := 0;
BEGIN
  -- Update active (uncompleted) goals with new progress
  UPDATE goals
  SET current_minutes = current_minutes + p_duration_minutes
  WHERE user_id = p_user_id
    AND completed = FALSE
    AND (target_date IS NULL OR target_date >= p_session_date);

  -- Calculate XP to be granted for newly completed goals
  SELECT COALESCE(SUM(xp_reward), 0) INTO goal_xp_to_add
  FROM goals
  WHERE user_id = p_user_id
    AND completed = FALSE
    AND current_minutes >= target_minutes
    AND (target_date IS NULL OR target_date >= p_session_date);

  -- Mark completed goals
  UPDATE goals
  SET completed = TRUE
  WHERE user_id = p_user_id
    AND completed = FALSE
    AND current_minutes >= target_minutes
    AND (target_date IS NULL OR target_date >= p_session_date);

  RETURN goal_xp_to_add;
END;
$$ LANGUAGE plpgsql;


create extension if not exists pg_cron;

SELECT cron.schedule(
  'daily_repeatable_cleanup',
  '0 3 * * *',
  $$
  DELETE FROM challenge_progress
  WHERE challenge_id IN (
    SELECT id FROM challenges WHERE repeatable = true
  );
  $$
);
