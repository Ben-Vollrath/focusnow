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
(1, 25, 'Daydreamer', '💭'),
(2, 30, 'Note Taker', '📝'),
(3, 35, 'Fresh Starter', '🌱'),
(4, 40, 'Focus Finder', '🔍'),
(5, 45, 'Pomodoro Pupil', '⏱️'),
(6, 50, 'Task Tackler', '✅'),
(7, 55, 'Study Sprinter', '🏃‍♂️'),
(8, 60, 'Time Tracker', '⌛'),
(9, 65, 'Desk Dweller', '🪑'),
(10, null, 'Momentum Builder', '🔄');

INSERT INTO challenges (name, description, icon, category, condition_amount, reward_xp, is_repeatable, difficulty) VALUES
('First Focus', 'Complete 1 study session in a day', '📍', 'daily_sessions', 1, 10, true, 1),
('Daily Routine', 'Complete 3 study sessions in a day', '🛠️', 'daily_sessions', 3, 15, true, 2),
('Power Day', 'Complete 5 study sessions in a day', '⚡', 'daily_sessions', 5, 20, true, 3),
('Getting Warm', 'Reach a study streak of 3 days', '🌤️', 'streak_days', 3, 15, false, 1),
('Focus Spark', 'Reach a study streak of 5 days', '✨', 'streak_days', 5, 20, false, 2),
('One Week Warrior', 'Reach a study streak of 7 days', '🗓️', 'streak_days', 7, 30, false, 3),
('Hour One', 'Accumulate 1 total study hour', '⏱️', 'total_hours', 60, 10, false, 1),
('Getting Into It', 'Accumulate 3 total study hours', '🏃', 'total_hours', 180, 15, false, 2),
('Finding Flow', 'Accumulate 5 total study hours', '💧', 'total_hours', 300, 20, false, 3),
('Getting the Hang', 'Complete 5 total study sessions', '👟', 'total_sessions', 5, 15, false, 1),
('Session Seeker', 'Complete 10 total study sessions', '🕵️', 'total_sessions', 10, 25, false, 2),
('Routine Builder', 'Complete 20 total study sessions', '🧱', 'total_sessions', 20, 35, false, 3);


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


