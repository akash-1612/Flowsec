# Flowsec - Complete Setup Guide

This guide will walk you through setting up the Flowsec project with your own GitHub account and Supabase instance.

## Prerequisites

- A GitHub account
- A Supabase account (free tier is sufficient)
- Git installed on your machine

## Step 1: Fork and Clone the Project

1. **Fork the repository** from your teammate's GitHub account:
   - Go to your teammate's Flowsec repository
   - Click the "Fork" button in the top right
   - This creates a copy in your GitHub account

2. **Clone to your local machine**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Flowsec.git
   cd Flowsec
   ```

3. **Set up remote (optional - to pull updates from original repo)**:
   ```bash
   git remote add upstream https://github.com/TEAMMATE_USERNAME/Flowsec.git
   ```

## Step 2: Create a New Supabase Project

1. Go to [https://supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Fill in the details:
   - **Name**: Flowsec (or your preferred name)
   - **Database Password**: Choose a strong password (save this!)
   - **Region**: Choose closest to your users
   - **Plan**: Free tier is fine for development

4. Wait for the project to be created (takes ~2 minutes)

## Step 3: Set Up the Database Schema

1. In your Supabase dashboard, click on the **SQL Editor** in the left sidebar

2. Click **"New Query"**

3. Copy and paste the complete schema from `database_schema.sql` file

4. Click **"Run"** to execute the SQL

5. Verify the tables were created:
   - Go to **Table Editor** in the left sidebar
   - You should see: `profiles`, `messages`, `files`, `backup_keys`

## Step 4: Configure Row Level Security (RLS)

The schema includes RLS policies, but verify they're enabled:

1. Go to **Authentication** > **Policies**
2. Check each table has the appropriate policies enabled
3. Policies should allow:
   - Users to read/write their own profile
   - Users to read/write messages in conversations they're part of
   - Users to manage their own files
   - Users to manage their own backup keys

## Step 5: Set Up Authentication

1. In Supabase dashboard, go to **Authentication** > **Settings**

2. **Enable Email Auth**:
   - Go to **Providers** tab
   - Ensure **Email** is enabled
   - Enable **"Confirm email"** (recommended)

3. **Configure Email Templates** (optional but recommended):
   - Go to **Email Templates** tab
   - Customize the magic link email template
   - Set **Site URL**: `https://YOUR_USERNAME.github.io/Flowsec/`

4. **Set up URL Configuration**:
   - Go to **Authentication** > **URL Configuration**
   - Add your GitHub Pages URL to **Redirect URLs**:
     ```
     https://YOUR_USERNAME.github.io/Flowsec/pages/chat.html
     https://YOUR_USERNAME.github.io/Flowsec/pages/otp.html
     ```

## Step 6: Get Your Supabase Credentials

1. Go to **Settings** > **API** in your Supabase dashboard

2. Copy the following values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: Long JWT token starting with `eyJ...`

3. Keep these handy for the next step

## Step 7: Configure the Application

1. Open `js/config.js` in your code editor

2. Replace the Supabase credentials:
   ```javascript
   const SUPABASE_URL = 'YOUR_PROJECT_URL';
   const SUPABASE_KEY = 'YOUR_ANON_KEY';
   ```

3. **Generate an encryption key** (for client-side encryption):
   
   **On Windows (PowerShell):**
   ```powershell
   [Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
   ```
   
   **On Mac/Linux:**
   ```bash
   openssl rand -base64 32
   ```

4. Add the encryption key to `config.js`:
   ```javascript
   const SUPABASE_APP_KEY = 'YOUR_GENERATED_KEY_HERE';
   ```

5. **VirusTotal API Key** (optional - for file scanning):
   - Get a free API key from [VirusTotal](https://www.virustotal.com/gui/join-us)
   - Replace the key in `config.js`:
     ```javascript
     const VIRUSTOTAL_API_KEY = 'YOUR_VIRUSTOTAL_KEY';
     ```

## Step 8: Set Up Supabase Edge Functions (Optional - Can Skip)

> **ℹ️ Note**: This step is **completely optional**. The app works perfectly without Edge Functions because encryption happens client-side in your browser. You can skip to Step 9 and come back to this later if needed.

> **⚠️ Windows Users**: `npm install -g supabase` does NOT work on Windows. See [SUPABASE_CLI_WINDOWS.md](SUPABASE_CLI_WINDOWS.md) for proper installation methods (Scoop, Chocolatey, or direct download).

### If You Want to Set Up Edge Functions:

1. **Install Supabase CLI**:
   
   **Windows (using Scoop - recommended):**
   ```powershell
   scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
   scoop install supabase
   ```
   
   **Mac/Linux:**
   ```bash
   brew install supabase/tap/supabase
   ```
   
   **Or use NPX (no installation):**
   ```bash
   npx supabase login
   ```
   
   📖 **Full Windows instructions**: See [SUPABASE_CLI_WINDOWS.md](SUPABASE_CLI_WINDOWS.md)

2. **Login to Supabase**:
   ```bash
   supabase login
   # Or: npx supabase login
   ```

3. **Link your project**:
   ```bash
   supabase link --project-ref YOUR_PROJECT_REF
   # Or: npx supabase link --project-ref YOUR_PROJECT_REF
   ```
   (Find PROJECT_REF in Supabase Settings > General)

4. **Deploy the encrypt/decrypt functions**:
   ```bash
   supabase functions deploy encrypt
   supabase functions deploy decrypt
   # Or: npx supabase functions deploy encrypt
   ```

5. **Set the encryption key as a secret**:
   ```bash
   supabase secrets set SUPABASE_APP_KEY=YOUR_GENERATED_KEY_HERE
   # Or: npx supabase secrets set SUPABASE_APP_KEY=YOUR_GENERATED_KEY_HERE
   ```

### Why Edge Functions Are Optional:

- ✅ Client-side encryption works without them
- ✅ All core features function normally
- ✅ Messages are still encrypted end-to-end
- ✅ You can add them later without any issues

**Recommendation**: Skip this step for now and proceed to Step 9. You can always come back and add Edge Functions later if needed.

## Step 9: Deploy to GitHub Pages

1. **Commit your changes** (DON'T commit sensitive keys!):
   ```bash
   git add js/config.js
   git commit -m "Configure Supabase for my account"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your GitHub repository
   - Click **Settings** > **Pages**
   - Under "Source", select **GitHub Actions**
   - The workflow is already configured in `.github/workflows/deploy.yml`

3. **Wait for deployment**:
   - Go to **Actions** tab in your repository
   - You should see a workflow running
   - Once complete (green checkmark), your site is live!

4. **Access your site**:
   ```
   https://YOUR_USERNAME.github.io/Flowsec/
   ```

## Step 10: Test the Application

1. Open your GitHub Pages URL
2. Click **Sign Up**
3. Enter your email
4. Check your email for the OTP code
5. Complete your profile
6. Start chatting!

## Important Security Notes

⚠️ **NEVER commit these to GitHub:**
- Your Supabase anon key is safe to commit (it's client-side)
- Your Supabase service_role key (if you have one) - NEVER commit this
- Your encryption key (`SUPABASE_APP_KEY`) - Consider using environment variables for production
- VirusTotal API key - Consider moving to backend

## Troubleshooting

### Issue: "Invalid API key" error
- Double-check your Supabase credentials in `js/config.js`
- Ensure you copied the full anon key (it's very long)

### Issue: "Email not sent"
- Check Supabase Authentication settings
- Verify email auth is enabled
- Check your spam folder

### Issue: "Cannot insert into table" error
- Verify the database schema is set up correctly
- Check RLS policies are enabled
- Ensure you're authenticated

### Issue: GitHub Pages shows 404
- Wait a few minutes after the first deployment
- Check Actions tab for deployment errors
- Verify GitHub Pages is enabled in Settings

### Issue: "CORS error" with VirusTotal
- See `VIRUSTOTAL_CORS_ISSUE.md` for solutions
- Consider setting up a proxy server

## Updating from Upstream

To pull updates from your teammate's repository:

```bash
git fetch upstream
git merge upstream/main
git push origin main
```

## Environment Variables for Production

For production deployments, consider using environment variables instead of hardcoding:

1. Use GitHub Secrets for sensitive values
2. Create a build script that injects values at deploy time
3. Or use a backend service to store configuration

## Support

If you encounter issues:
1. Check the browser console for errors (F12)
2. Check Supabase logs in the dashboard
3. Review the GitHub Actions logs for deployment issues

## Next Steps

- Customize the UI/UX
- Add more features
- Set up analytics
- Configure custom domain
- Add more authentication providers (Google, GitHub, etc.)

---

**Project Repository**: https://github.com/YOUR_USERNAME/Flowsec
**Live Demo**: https://YOUR_USERNAME.github.io/Flowsec/

Enjoy building with Flowsec! 🚀
