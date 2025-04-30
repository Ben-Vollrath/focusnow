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