CREATE OR REPLACE VIEW daily_study_leaderboard AS
SELECT
  sd.user_id,
  u.username,
  sd.total_study_time,
  sd.total_study_sessions,
  RANK() OVER (ORDER BY sd.total_study_time DESC) AS rank
FROM study_days sd
JOIN users u ON sd.user_id = u.id
WHERE sd.total_study_time > 0
  AND sd.study_date = CURRENT_DATE;

CREATE OR REPLACE VIEW top_5_daily_study_leaderboard AS
SELECT *
FROM daily_study_leaderboard
WHERE rank <= 5;



CREATE OR REPLACE VIEW total_study_leaderboard AS
SELECT
  u.id AS user_id,
  u.username,
  u.total_study_time,
  u.total_study_sessions,
  RANK() OVER (ORDER BY u.total_study_time DESC) AS rank
FROM users u
WHERE u.total_study_time > 0;

CREATE OR REPLACE VIEW top_5_total_study_leaderboard AS
SELECT *
FROM total_study_leaderboard
WHERE rank <= 5;


CREATE TABLE IF NOT EXISTS fake_users (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE
);


CREATE OR REPLACE FUNCTION update_fake_leaderboard_data()
RETURNS void AS $$
DECLARE
  fake RECORD;
  study_minutes INT;
  study_sessions INT;
BEGIN
  FOR fake IN SELECT user_id FROM fake_users LOOP
    -- Generate random study time and sessions
    study_minutes := FLOOR(random() * 30 + 20); -- 20–50 mins
    study_sessions := ROUND(study_minutes / 25.0);

    -- Insert or update study_days for today
    INSERT INTO study_days (
      user_id,
      study_date,
      total_study_time,
      total_study_sessions,
      streak_day
    )
    VALUES (
      fake.user_id,
      CURRENT_DATE,
      study_minutes,
      study_sessions,
      0  -- Optional: you can make this random if desired
    )
    ON CONFLICT (user_id, study_date)
    DO UPDATE SET
      total_study_time = study_days.total_study_time + EXCLUDED.total_study_time,
      total_study_sessions = study_days.total_study_sessions + EXCLUDED.total_study_sessions;

    -- Also update cumulative totals in users table
    UPDATE users
    SET
      total_study_time = users.total_study_time + study_minutes,
      total_study_sessions = users.total_study_sessions + study_sessions
    WHERE id = fake.user_id;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule(
  'update_fake_leaderboard',      -- unique job name
  '0 */3 * * *',                  -- every 3 hours at :00
  $$SELECT update_fake_leaderboard_data();$$
);



SELECT cron.schedule(
  'update_fake_leaderboard',      -- unique job name
  '0 */6 * * *',                  -- every 3 hours at :00
  $$SELECT update_fake_leaderboard_data();$$
);

