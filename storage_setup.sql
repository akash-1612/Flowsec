-- ============================================================================
-- Flowsec Storage Bucket Setup
-- ============================================================================
-- This script sets up the Supabase Storage bucket for file uploads
--
-- INSTRUCTIONS:
-- 1. First create the bucket manually in Supabase Dashboard:
--    - Go to Storage in your Supabase dashboard
--    - Click "Create a new bucket"
--    - Bucket name: user-files
--    - Set to: PRIVATE (not public)
--    - Click Create
--
-- 2. Then run this script in SQL Editor to set up storage policies
-- ============================================================================

-- ============================================================================
-- STORAGE POLICIES
-- ============================================================================
-- These policies control who can upload, view, and delete files

-- Policy: Users can upload files to their own folder
CREATE POLICY "Users can upload their own files"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'user-files' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Policy: Users can view files in their own folder
CREATE POLICY "Users can view their own files"
  ON storage.objects FOR SELECT
  TO authenticated
  USING (
    bucket_id = 'user-files' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Policy: Users can update files in their own folder
CREATE POLICY "Users can update their own files"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'user-files' AND
    auth.uid()::text = (storage.foldername(name))[1]
  )
  WITH CHECK (
    bucket_id = 'user-files' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Policy: Users can delete files in their own folder
CREATE POLICY "Users can delete their own files"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'user-files' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- ============================================================================
-- OPTIONAL: Public file access for shared files
-- ============================================================================
-- If you want to allow users to share files with specific links,
-- you can add additional policies here

-- Example: Allow public read access to files marked as public
-- (You would need to implement this logic in your application)

-- CREATE POLICY "Public files can be viewed by anyone"
--   ON storage.objects FOR SELECT
--   TO public
--   USING (
--     bucket_id = 'user-files' AND
--     -- Add your custom logic here to check if file is marked as public
--   );

-- ============================================================================
-- VERIFICATION
-- ============================================================================
-- Run this query to verify the policies were created:

-- SELECT policyname, cmd, qual, with_check
-- FROM pg_policies
-- WHERE schemaname = 'storage' AND tablename = 'objects'
-- AND policyname LIKE '%user-files%';

-- ============================================================================
-- FILE STRUCTURE
-- ============================================================================
-- Files will be stored with the following structure:
-- bucket: user-files
-- path: {user_id}/{filename}
--
-- Example: user-files/550e8400-e29b-41d4-a716-446655440000/document.pdf
-- ============================================================================
