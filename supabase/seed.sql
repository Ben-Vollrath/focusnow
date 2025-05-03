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

INSERT INTO fake_users (user_id) VALUES
  ('1b7c5014-b164-4d03-9ac1-074edd086aed'),
  ('4b31b026-1793-47ed-897f-fdbc78a76a78'),
  ('bac294e7-4171-4f21-a98b-73b7dda5bdc6'),
  ('36cb4c62-5dcc-4726-bc7e-d708889d6874'),
  ('57cf3aef-6600-42dd-9c64-2ab240520e36');

SELECT update_fake_leaderboard_data();


INSERT INTO study_groups (id, name, description, owner_id, isPublic) VALUES ('695064a1-43c6-466e-b9d9-aa0ddb378c0f', 'Group of 1b7c5014', 'A test study group', '1b7c5014-b164-4d03-9ac1-074edd086aed', true);
INSERT INTO study_groups (id, name, description, owner_id, isPublic) VALUES ('b5570e48-cd0c-400f-b057-f16d0f888707', 'Group of 4b31b026', 'A test study group', '4b31b026-1793-47ed-897f-fdbc78a76a78', true);
INSERT INTO study_groups (id, name, description, owner_id, isPublic) VALUES ('24385dd3-14ac-40bd-9a2a-4e63df61411b', 'Group of bac294e7', 'A test study group', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6', true);
INSERT INTO study_groups (id, name, description, owner_id, isPublic) VALUES ('649b9b3e-36c1-496e-bb27-ba56447191f0', 'Group of 36cb4c62', 'A test study group', '36cb4c62-5dcc-4726-bc7e-d708889d6874', true);
INSERT INTO study_groups (id, name, description, owner_id, isPublic) VALUES ('be2f2a57-e048-4215-aeeb-7a24ad806c60', 'Group of 57cf3aef', 'A test study group', '57cf3aef-6600-42dd-9c64-2ab240520e36', true);
INSERT INTO study_group_members (study_group_id, user_id) VALUES ('695064a1-43c6-466e-b9d9-aa0ddb378c0f', '1b7c5014-b164-4d03-9ac1-074edd086aed');
INSERT INTO study_group_members (study_group_id, user_id) VALUES ('b5570e48-cd0c-400f-b057-f16d0f888707', '4b31b026-1793-47ed-897f-fdbc78a76a78');
INSERT INTO study_group_members (study_group_id, user_id) VALUES ('24385dd3-14ac-40bd-9a2a-4e63df61411b', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6');
INSERT INTO study_group_members (study_group_id, user_id) VALUES ('649b9b3e-36c1-496e-bb27-ba56447191f0', '36cb4c62-5dcc-4726-bc7e-d708889d6874');
INSERT INTO study_group_members (study_group_id, user_id) VALUES ('be2f2a57-e048-4215-aeeb-7a24ad806c60', '57cf3aef-6600-42dd-9c64-2ab240520e36');
INSERT INTO goals (id, name, description, target_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('fceb4338-0d12-4fc8-a2df-acbb89049fd2', 'Template Goal', 'Group challenge goal', 240, '2025-05-10', 30, '695064a1-43c6-466e-b9d9-aa0ddb378c0f', NULL);
INSERT INTO goals (id, name, description, target_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('d84aa432-e65f-401e-a8f5-82b2f8026aad', 'Template Goal', 'Group challenge goal', 120, '2025-05-10', 10, 'b5570e48-cd0c-400f-b057-f16d0f888707', NULL);
INSERT INTO goals (id, name, description, target_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('9868a63a-de87-4671-a5f1-1657ffaf10df', 'Template Goal', 'Group challenge goal', 240, '2025-05-10', 30, '24385dd3-14ac-40bd-9a2a-4e63df61411b', NULL);
INSERT INTO goals (id, name, description, target_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('08d21952-5f2d-4794-ac73-b918d051414e', 'Template Goal', 'Group challenge goal', 240, '2025-05-10', 30, '649b9b3e-36c1-496e-bb27-ba56447191f0', NULL);
INSERT INTO goals (id, name, description, target_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('195eabdc-a5e9-4d35-9930-40e037d4e7bd', 'Template Goal', 'Group challenge goal', 120, '2025-05-10', 20, 'be2f2a57-e048-4215-aeeb-7a24ad806c60', NULL);
INSERT INTO goals (id, name, description, target_minutes, current_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('e9a7b99c-ae46-4144-8e8b-6b60bf16e6b3', 'User Goal', 'User progress on group goal', 240, 88, '2025-05-10', 30, '695064a1-43c6-466e-b9d9-aa0ddb378c0f', '1b7c5014-b164-4d03-9ac1-074edd086aed');
INSERT INTO goals (id, name, description, target_minutes, current_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('830570ea-9b09-4de9-a52e-20326b7fd349', 'User Goal', 'User progress on group goal', 120, 49, '2025-05-10', 10, 'b5570e48-cd0c-400f-b057-f16d0f888707', '4b31b026-1793-47ed-897f-fdbc78a76a78');
INSERT INTO goals (id, name, description, target_minutes, current_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('c7a44131-5b6e-43f6-a9dc-315371bcbb80', 'User Goal', 'User progress on group goal', 240, 157, '2025-05-10', 30, '24385dd3-14ac-40bd-9a2a-4e63df61411b', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6');
INSERT INTO goals (id, name, description, target_minutes, current_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('ee5466b0-c12d-41e3-b31c-7e222873ee48', 'User Goal', 'User progress on group goal', 240, 156, '2025-05-10', 30, '649b9b3e-36c1-496e-bb27-ba56447191f0', '36cb4c62-5dcc-4726-bc7e-d708889d6874');
INSERT INTO goals (id, name, description, target_minutes, current_minutes, target_date, xp_reward, study_group_id, user_id) VALUES ('5fc2c66d-6b5a-4a05-8441-d3461f659f5d', 'User Goal', 'User progress on group goal', 120, 67, '2025-05-10', 20, 'be2f2a57-e048-4215-aeeb-7a24ad806c60', '57cf3aef-6600-42dd-9c64-2ab240520e36');