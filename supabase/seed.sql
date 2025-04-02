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


INSERT INTO levels (level, exp_required, name, icon) VALUES
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


