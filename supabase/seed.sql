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


-- 25 study groups (5 per user)
INSERT INTO study_groups (id, name, description, owner_id, isPublic) VALUES
  ('695064a1-43c6-466e-b9d9-aa0ddb378c0f', 'Group 1 of 1b7c5014', 'A test study group', '1b7c5014-b164-4d03-9ac1-074edd086aed', true),
  ('88dfc027-6c1f-4c8c-9e4f-715e44a348ef', 'Group 2 of 1b7c5014', 'A test study group', '1b7c5014-b164-4d03-9ac1-074edd086aed', true),
  ('4fcbcd70-198a-4b0c-8a32-7de5a3e951cf', 'Group 3 of 1b7c5014', 'A test study group', '1b7c5014-b164-4d03-9ac1-074edd086aed', true),
  ('28e1f4e4-4b92-43a6-a5c6-67d7b3ebea3f', 'Group 4 of 1b7c5014', 'A test study group', '1b7c5014-b164-4d03-9ac1-074edd086aed', true),
  ('c760bd11-f07f-4bc5-86bc-b617b80f7b87', 'Group 5 of 1b7c5014', 'A test study group', '1b7c5014-b164-4d03-9ac1-074edd086aed', true),

  ('b5570e48-cd0c-400f-b057-f16d0f888707', 'Group 1 of 4b31b026', 'A test study group', '4b31b026-1793-47ed-897f-fdbc78a76a78', true),
  ('3b9220cb-bdfb-4e77-8a65-b019d6811943', 'Group 2 of 4b31b026', 'A test study group', '4b31b026-1793-47ed-897f-fdbc78a76a78', true),
  ('f2b2823e-9a57-41df-88c3-6b2cf8e5a117', 'Group 3 of 4b31b026', 'A test study group', '4b31b026-1793-47ed-897f-fdbc78a76a78', true),
  ('96f8b6b0-23c1-4b17-910c-08d144da75a1', 'Group 4 of 4b31b026', 'A test study group', '4b31b026-1793-47ed-897f-fdbc78a76a78', true),
  ('a3f6c8cf-ff14-4fd3-88a7-bc57fdf02d35', 'Group 5 of 4b31b026', 'A test study group', '4b31b026-1793-47ed-897f-fdbc78a76a78', true),

  ('24385dd3-14ac-40bd-9a2a-4e63df61411b', 'Group 1 of bac294e7', 'A test study group', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6', true),
  ('0fc54f0e-6d58-4557-9f4f-3bc58f04a0b9', 'Group 2 of bac294e7', 'A test study group', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6', true),
  ('df41a153-7b99-4f3d-a6cb-9f6e4b6766c3', 'Group 3 of bac294e7', 'A test study group', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6', true),
  ('edcfd5dc-16a4-4063-89c7-e2f36c0f0f1a', 'Group 4 of bac294e7', 'A test study group', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6', true),
  ('bb2d9b96-1c7e-4974-b183-05bb5e478fc6', 'Group 5 of bac294e7', 'A test study group', 'bac294e7-4171-4f21-a98b-73b7dda5bdc6', true),

  ('649b9b3e-36c1-496e-bb27-ba56447191f0', 'Group 1 of 36cb4c62', 'A test study group', '36cb4c62-5dcc-4726-bc7e-d708889d6874', true),
  ('e8a3a124-d50e-4e03-ae8f-c3ea6c1cf57a', 'Group 2 of 36cb4c62', 'A test study group', '36cb4c62-5dcc-4726-bc7e-d708889d6874', true),
  ('742b7a36-d3ae-4489-8881-03fc21f9b0ee', 'Group 3 of 36cb4c62', 'A test study group', '36cb4c62-5dcc-4726-bc7e-d708889d6874', true),
  ('e7b53e1a-7a9b-4e3f-a8e4-5dfb278a7c61', 'Group 4 of 36cb4c62', 'A test study group', '36cb4c62-5dcc-4726-bc7e-d708889d6874', true),
  ('ad2b4295-43b1-4ee7-8bd0-3f4f73cb3f16', 'Group 5 of 36cb4c62', 'A test study group', '36cb4c62-5dcc-4726-bc7e-d708889d6874', true),

  ('be2f2a57-e048-4215-aeeb-7a24ad806c60', 'Group 1 of 57cf3aef', 'A test study group', '57cf3aef-6600-42dd-9c64-2ab240520e36', true),
  ('1b268870-d118-4b34-a145-ecb4919246be', 'Group 2 of 57cf3aef', 'A test study group', '57cf3aef-6600-42dd-9c64-2ab240520e36', true),
  ('7e22629e-3914-44e6-aac5-2620cf1b1b7b', 'Group 3 of 57cf3aef', 'A test study group', '57cf3aef-6600-42dd-9c64-2ab240520e36', true),
  ('f16c0172-1e34-4398-8ab2-e4ad94be97c8', 'Group 4 of 57cf3aef', 'A test study group', '57cf3aef-6600-42dd-9c64-2ab240520e36', true),
  ('18fc259c-4625-4683-b7eb-13575975b432', 'Group 5 of 57cf3aef', 'A test study group', '57cf3aef-6600-42dd-9c64-2ab240520e36', true);

-- Add owners as members
INSERT INTO study_group_members (study_group_id, user_id)
SELECT id, owner_id FROM study_groups;

-- Add group goals and user progress for half of the groups
INSERT INTO goals (name, description, target_minutes, target_date, xp_reward, study_group_id, user_id)
SELECT 'Template Goal', 'Group challenge goal', 240, '2025-05-10', 30, id, NULL
FROM study_groups
WHERE id IN (
  '695064a1-43c6-466e-b9d9-aa0ddb378c0f',
  'b5570e48-cd0c-400f-b057-f16d0f888707',
  '24385dd3-14ac-40bd-9a2a-4e63df61411b',
  '649b9b3e-36c1-496e-bb27-ba56447191f0',
  'be2f2a57-e048-4215-aeeb-7a24ad806c60'
);

INSERT INTO goals (name, description, target_minutes, current_minutes, target_date, xp_reward, study_group_id, user_id)
SELECT 'User Goal', 'User progress on group goal', 240, 100, '2025-05-10', 30, id, owner_id
FROM study_groups
WHERE id IN (
  '695064a1-43c6-466e-b9d9-aa0ddb378c0f',
  'b5570e48-cd0c-400f-b057-f16d0f888707',
  '24385dd3-14ac-40bd-9a2a-4e63df61411b',
  '649b9b3e-36c1-496e-bb27-ba56447191f0',
  'be2f2a57-e048-4215-aeeb-7a24ad806c60'
);