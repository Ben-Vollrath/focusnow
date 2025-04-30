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
  '1b7c5014-b164-4d03-9ac1-074edd086aed',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'testuser3@example.com',
  '$2b$10$2b2OtqkxKx9bEmJpZL/NfOWmBMO/YZzZgxBSsZTLRkWq9UbLrmrrG',
  now(),
  now(),
  false,
  '{"provider": "email", "providers": ["email"]}',
  '{}',
  now(),
  now()
);

UPDATE users
SET level = 9, xp = 639, total_study_time = 348, total_study_sessions = 7
WHERE id = '1b7c5014-b164-4d03-9ac1-074edd086aed';

INSERT INTO study_days (user_id, study_date, total_study_time, total_study_sessions, streak_day)
VALUES (
  '1b7c5014-b164-4d03-9ac1-074edd086aed', CURRENT_DATE,
  348, 7, 5
);


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
  '4b31b026-1793-47ed-897f-fdbc78a76a78',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'testuser4@example.com',
  '$2b$10$2b2OtqkxKx9bEmJpZL/NfOWmBMO/YZzZgxBSsZTLRkWq9UbLrmrrG',
  now(),
  now(),
  false,
  '{"provider": "email", "providers": ["email"]}',
  '{}',
  now(),
  now()
);

UPDATE users
SET level = 10, xp = 592, total_study_time = 490, total_study_sessions = 13
WHERE id = '4b31b026-1793-47ed-897f-fdbc78a76a78';

INSERT INTO study_days (user_id, study_date, total_study_time, total_study_sessions, streak_day)
VALUES (
  '4b31b026-1793-47ed-897f-fdbc78a76a78', CURRENT_DATE,
  490, 13, 6
);


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
  'bac294e7-4171-4f21-a98b-73b7dda5bdc6',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'testuser5@example.com',
  '$2b$10$2b2OtqkxKx9bEmJpZL/NfOWmBMO/YZzZgxBSsZTLRkWq9UbLrmrrG',
  now(),
  now(),
  false,
  '{"provider": "email", "providers": ["email"]}',
  '{}',
  now(),
  now()
);

UPDATE users
SET level = 9, xp = 770, total_study_time = 290, total_study_sessions = 9
WHERE id = 'bac294e7-4171-4f21-a98b-73b7dda5bdc6';

INSERT INTO study_days (user_id, study_date, total_study_time, total_study_sessions, streak_day)
VALUES (
  'bac294e7-4171-4f21-a98b-73b7dda5bdc6', CURRENT_DATE,
  290, 9, 5
);


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
  '36cb4c62-5dcc-4726-bc7e-d708889d6874',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'testuser6@example.com',
  '$2b$10$2b2OtqkxKx9bEmJpZL/NfOWmBMO/YZzZgxBSsZTLRkWq9UbLrmrrG',
  now(),
  now(),
  false,
  '{"provider": "email", "providers": ["email"]}',
  '{}',
  now(),
  now()
);

UPDATE users
SET level = 3, xp = 166, total_study_time = 413, total_study_sessions = 14
WHERE id = '36cb4c62-5dcc-4726-bc7e-d708889d6874';

INSERT INTO study_days (user_id, study_date, total_study_time, total_study_sessions, streak_day)
VALUES (
  '36cb4c62-5dcc-4726-bc7e-d708889d6874', CURRENT_DATE,
  413, 14, 2
);


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
  '57cf3aef-6600-42dd-9c64-2ab240520e36',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'testuser7@example.com',
  '$2b$10$2b2OtqkxKx9bEmJpZL/NfOWmBMO/YZzZgxBSsZTLRkWq9UbLrmrrG',
  now(),
  now(),
  false,
  '{"provider": "email", "providers": ["email"]}',
  '{}',
  now(),
  now()
);

UPDATE users
SET level = 3, xp = 432, total_study_time = 80, total_study_sessions = 20
WHERE id = '57cf3aef-6600-42dd-9c64-2ab240520e36';

INSERT INTO study_days (user_id, study_date, total_study_time, total_study_sessions, streak_day)
VALUES (
  '57cf3aef-6600-42dd-9c64-2ab240520e36', CURRENT_DATE,
  80, 20, 1
);
