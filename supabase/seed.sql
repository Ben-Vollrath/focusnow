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


