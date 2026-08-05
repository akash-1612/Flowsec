// Supabase configuration - update to point at your Supabase project
// NOTE: These are public/anon values for the client; do NOT commit service_role key here.
const SUPABASE_URL = 'https://ljlvmspberjuxokdxmdl.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqbHZtc3BiZXJqdXhva2R4bWRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0MTEyNjYsImV4cCI6MjA3Njk4NzI2Nn0.ou2ig8VytRHThHYBUKECWEvpM76mljElLRdV3PVnTaw';

// VirusTotal API Configuration
// SECURITY: The API key is now stored in Supabase Edge Function environment variables
// and accessed through the virustotal-scan proxy endpoint.
// No need to expose the API key in client-side code anymore!

// Application-level encryption key (Base64-encoded 32 bytes).
// WARNING: For production, do NOT store this in client-side code. Move to a secure server / environment.
const SUPABASE_APP_KEY = 'EVDTfkF5bbwb2MkMMcD6JYG5yc5wn8+yZmME4+d2Qc0='; // Generate using: openssl rand -base64 32


