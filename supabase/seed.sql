INSERT INTO username_words (type, word) VALUES
  ('verb', 'absorbing'),
  ('verb', 'analyzing'),
  ('verb', 'brainstorming'),
  ('verb', 'concentrating'),
  ('verb', 'visualizing'),
  ('animal', 'panda'),
  ('animal', 'koala'),
  ('animal', 'otter'),
  ('animal', 'giraffe'),
  ('animal', 'penguin');


INSERT INTO levels (level, xp_required, name, icon) VALUES
(1, 0, 'Daydreamer', '💭'),
(2, 25, 'Note Taker', '📝'),
(3, 30, 'Fresh Starter', '🌱'),
(4, 35, 'Focus Finder', '🔍'),
(5, 40, 'Pomodoro Pupil', '⏱️'),
(6, 45, 'Task Tackler', '✅'),
(7, 50, 'Study Sprinter', '🏃‍♂️'),
(8, 55, 'Time Tracker', '⌛'),
(9, 60, 'Desk Dweller', '🪑'),
(10, 65, 'Momentum Builder', '🔄');

INSERT INTO challenges (name, description, icon, category, condition_amount, reward_xp, is_repeatable, difficulty) VALUES
('First Focus', 'Complete 1 study session in a day', '📍', 'daily_sessions', 1, 10, true, 1),
('Getting Started', 'Complete 2 study sessions in a day', '🚀', 'daily_sessions', 2, 15, true, 2),
('Daily Routine', 'Complete 3 study sessions in a day', '🛠️', 'daily_sessions', 3, 20, true, 3),
('First Flame', 'Reach a study streak of 2 days', '🔥', 'streak_days', 2, 10, false, 1),
('Getting Warm', 'Reach a study streak of 3 days', '🌤️', 'streak_days', 3, 15, false, 2),
('Focus Spark', 'Reach a study streak of 5 days', '✨', 'streak_days', 5, 20, false, 3),
('Hour One', 'Accumulate 1 total study hours', '⏱️', 'total_hours', 60, 10, false, 1),
('Getting Into It', 'Accumulate 3 total study hours', '🏃', 'total_hours', 180, 15, false, 2),
('Finding Flow', 'Accumulate 5 total study hours', '💧', 'total_hours', 300, 20, false, 3),
('First Session', 'Complete 1 total study sessions', '🎬', 'total_sessions', 1, 10, false, 1),
('Getting the Hang', 'Complete 5 total study sessions', '👟', 'total_sessions', 5, 15, false, 2),
('Session Seeker', 'Complete 10 total study sessions', '🕵️', 'total_sessions', 10, 25, false, 3);


INSERT INTO auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  confirmation_sent_at,
  is_sso_user,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
VALUES (
  '00000000-0000-0000-0000-000000000000',  -- 👈 your test user id
  '00000000-0000-0000-0000-000000000000',  -- default instance
  'authenticated',
  'authenticated',
  'test@example.com',
  '$2b$10$2b2OtqkxKx9bEmJpZL/NfOWmBMO/YZzZgxBSsZTLRkWq9UbLrmrrG', -- password: `password`
  now(),
  now(),
  false,
  '{"provider": "email", "providers": ["email"]}',
  '{}',
  now(),
  now()
);


