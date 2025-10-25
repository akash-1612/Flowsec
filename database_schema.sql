-- ============================================================================
-- Flowsec Database Schema
-- ============================================================================
-- This script creates all necessary tables, indexes, and Row Level Security
-- (RLS) policies for the Flowsec secure messaging application.
--
-- INSTRUCTIONS:
-- 1. Open your Supabase project dashboard
-- 2. Go to SQL Editor
-- 3. Create a new query
-- 4. Copy and paste this entire file
-- 5. Click "Run" to execute
-- ============================================================================

-- ============================================================================
-- ENABLE EXTENSIONS
-- ============================================================================
-- Enable UUID generation for primary keys
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- DROP EXISTING TABLES (if running this script multiple times)
-- ============================================================================
-- Uncomment these lines if you want to reset the database
-- DROP TABLE IF EXISTS backup_keys CASCADE;
-- DROP TABLE IF EXISTS files CASCADE;
-- DROP TABLE IF EXISTS messages CASCADE;
-- DROP TABLE IF EXISTS profiles CASCADE;

-- ============================================================================
-- TABLE: profiles
-- ============================================================================
-- Stores user profile information
-- Linked to Supabase auth.users via user_id
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  public_key TEXT, -- For end-to-end encryption (user's public key)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);

-- ============================================================================
-- TABLE: messages
-- ============================================================================
-- Stores encrypted messages between users
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  receiver_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  encrypted_content TEXT NOT NULL, -- Encrypted message content
  iv TEXT, -- Initialization vector for encryption
  salt TEXT, -- Salt for key derivation
  message_type TEXT DEFAULT 'text', -- 'text', 'file', 'image', etc.
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_messages_sender_id ON messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_receiver_id ON messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON messages(sender_id, receiver_id, created_at DESC);

-- ============================================================================
-- TABLE: files
-- ============================================================================
-- Stores metadata for uploaded files (actual files stored in Supabase Storage)
CREATE TABLE IF NOT EXISTS files (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  filename TEXT NOT NULL,
  file_path TEXT NOT NULL, -- Path in Supabase Storage
  file_size BIGINT, -- Size in bytes
  file_type TEXT, -- MIME type
  encrypted BOOLEAN DEFAULT TRUE,
  encryption_key TEXT, -- Encrypted file encryption key
  iv TEXT, -- Initialization vector
  virus_scan_status TEXT DEFAULT 'pending', -- 'pending', 'clean', 'infected', 'error'
  virus_scan_result JSONB, -- Full VirusTotal scan results
  is_public BOOLEAN DEFAULT FALSE,
  shared_with UUID[], -- Array of user IDs who can access the file
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_files_user_id ON files(user_id);
CREATE INDEX IF NOT EXISTS idx_files_created_at ON files(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_files_virus_status ON files(virus_scan_status);

-- ============================================================================
-- TABLE: backup_keys
-- ============================================================================
-- Stores encrypted backup of user encryption keys for key recovery
CREATE TABLE IF NOT EXISTS backup_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  encrypted_key TEXT NOT NULL, -- Encrypted backup of user's master key
  recovery_code_hash TEXT, -- Hashed recovery code (for key recovery)
  salt TEXT, -- Salt for key derivation
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_backup_keys_user_id ON backup_keys(user_id);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE files ENABLE ROW LEVEL SECURITY;
ALTER TABLE backup_keys ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- PROFILES POLICIES
-- ----------------------------------------------------------------------------

-- Users can view all profiles (for user discovery/search)
CREATE POLICY "Users can view all profiles"
  ON profiles FOR SELECT
  USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own profile
CREATE POLICY "Users can delete own profile"
  ON profiles FOR DELETE
  USING (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- MESSAGES POLICIES
-- ----------------------------------------------------------------------------

-- Users can view messages they sent or received
CREATE POLICY "Users can view their messages"
  ON messages FOR SELECT
  USING (
    auth.uid() = sender_id OR 
    auth.uid() = receiver_id
  );

-- Users can insert messages they are sending
CREATE POLICY "Users can send messages"
  ON messages FOR INSERT
  WITH CHECK (auth.uid() = sender_id);

-- Users can update messages they received (e.g., mark as read)
CREATE POLICY "Users can update received messages"
  ON messages FOR UPDATE
  USING (auth.uid() = receiver_id)
  WITH CHECK (auth.uid() = receiver_id);

-- Users can delete messages they sent or received
CREATE POLICY "Users can delete their messages"
  ON messages FOR DELETE
  USING (
    auth.uid() = sender_id OR 
    auth.uid() = receiver_id
  );

-- ----------------------------------------------------------------------------
-- FILES POLICIES
-- ----------------------------------------------------------------------------

-- Users can view their own files and files shared with them
CREATE POLICY "Users can view own and shared files"
  ON files FOR SELECT
  USING (
    auth.uid() = user_id OR 
    is_public = true OR
    auth.uid() = ANY(shared_with)
  );

-- Users can insert their own files
CREATE POLICY "Users can upload files"
  ON files FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own files
CREATE POLICY "Users can update own files"
  ON files FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own files
CREATE POLICY "Users can delete own files"
  ON files FOR DELETE
  USING (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- BACKUP_KEYS POLICIES
-- ----------------------------------------------------------------------------

-- Users can view only their own backup keys
CREATE POLICY "Users can view own backup keys"
  ON backup_keys FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own backup keys
CREATE POLICY "Users can create backup keys"
  ON backup_keys FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own backup keys
CREATE POLICY "Users can update own backup keys"
  ON backup_keys FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own backup keys
CREATE POLICY "Users can delete own backup keys"
  ON backup_keys FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- FUNCTIONS AND TRIGGERS
-- ============================================================================

-- Function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the update trigger to all tables
DROP TRIGGER IF EXISTS update_profiles_updated_at ON profiles;
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_messages_updated_at ON messages;
CREATE TRIGGER update_messages_updated_at
  BEFORE UPDATE ON messages
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_files_updated_at ON files;
CREATE TRIGGER update_files_updated_at
  BEFORE UPDATE ON files
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_backup_keys_updated_at ON backup_keys;
CREATE TRIGGER update_backup_keys_updated_at
  BEFORE UPDATE ON backup_keys
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STORAGE BUCKETS (Run this in Supabase Storage settings or via SQL)
-- ============================================================================
-- Note: You may need to create storage buckets manually in the Supabase dashboard
-- Go to Storage > Create a new bucket

-- Create storage bucket for user files
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('user-files', 'user-files', false)
-- ON CONFLICT (id) DO NOTHING;

-- Storage policies for user-files bucket
-- CREATE POLICY "Users can upload their own files"
--   ON storage.objects FOR INSERT
--   WITH CHECK (bucket_id = 'user-files' AND auth.uid()::text = (storage.foldername(name))[1]);

-- CREATE POLICY "Users can view their own files"
--   ON storage.objects FOR SELECT
--   USING (bucket_id = 'user-files' AND auth.uid()::text = (storage.foldername(name))[1]);

-- CREATE POLICY "Users can delete their own files"
--   ON storage.objects FOR DELETE
--   USING (bucket_id = 'user-files' AND auth.uid()::text = (storage.foldername(name))[1]);

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================
-- Uncomment to insert sample data for testing

-- Note: You'll need actual user IDs from auth.users to insert sample data
-- This is just a template

-- INSERT INTO profiles (user_id, email, full_name, bio) VALUES
--   ('user-uuid-1', 'alice@example.com', 'Alice Johnson', 'Security enthusiast'),
--   ('user-uuid-2', 'bob@example.com', 'Bob Smith', 'Privacy advocate');

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Run these queries after setup to verify everything is working

-- Check all tables exist
-- SELECT table_name FROM information_schema.tables 
-- WHERE table_schema = 'public' 
-- ORDER BY table_name;

-- Check RLS is enabled
-- SELECT tablename, rowsecurity FROM pg_tables 
-- WHERE schemaname = 'public';

-- Check policies exist
-- SELECT tablename, policyname FROM pg_policies 
-- WHERE schemaname = 'public';

-- ============================================================================
-- SETUP COMPLETE!
-- ============================================================================
-- Your Flowsec database is now ready to use.
-- Next steps:
-- 1. Configure authentication in Supabase dashboard
-- 2. Create storage bucket for files
-- 3. Update your app configuration with Supabase credentials
-- ============================================================================
