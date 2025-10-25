# ⚡ Quick Command Reference

This is a quick reference for all the commands you'll need to set up and deploy Flowsec.

## 🪟 Windows Commands

### Generate Encryption Key (PowerShell)
```powershell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
```

### Run Automated Setup
```cmd
setup.bat
```

Or directly in PowerShell:
```powershell
.\setup.ps1
```

## 🐙 Git Commands

### Fork and Clone (One-Time Setup)
```bash
# Clone your forked repository
git clone https://github.com/YOUR_USERNAME/Flowsec.git
cd Flowsec

# Add upstream remote (to get teammate's updates)
git remote add upstream https://github.com/TEAMMATE_USERNAME/Flowsec.git
```

### Configure Git Remote
```bash
# Check current remotes
git remote -v

# Change origin to your fork
git remote set-url origin https://github.com/YOUR_USERNAME/Flowsec.git

# Verify
git remote -v
```

### Commit and Push Changes
```bash
# Stage all changes
git add .

# Or stage specific files
git add js/config.js database_schema.sql README.md

# Commit with message
git commit -m "Configure for my Supabase account"

# Push to your GitHub
git push origin main
```

### Update from Teammate's Repository
```bash
# Fetch updates from upstream
git fetch upstream

# Merge updates into your main branch
git merge upstream/main

# Resolve any conflicts if they occur
# Then push to your fork
git push origin main
```

### View Git Status
```bash
# See what files have changed
git status

# See actual changes in files
git diff

# See commit history
git log --oneline
```

## 📦 Supabase CLI Commands (Optional)

### Install Supabase CLI
```bash
npm install -g supabase
```

### Login to Supabase
```bash
supabase login
```

### Link Your Project
```bash
# Find PROJECT_REF in Supabase Settings > General
supabase link --project-ref YOUR_PROJECT_REF
```

### Deploy Edge Functions
```bash
# Deploy encrypt function
supabase functions deploy encrypt

# Deploy decrypt function
supabase functions deploy decrypt

# Deploy all functions
supabase functions deploy
```

### Set Environment Secrets
```bash
# Set encryption key for edge functions
supabase secrets set SUPABASE_APP_KEY=YOUR_ENCRYPTION_KEY_HERE

# View all secrets (names only, not values)
supabase secrets list
```

### Test Functions Locally (Optional)
```bash
# Start local Supabase
supabase start

# Test function locally
supabase functions serve encrypt --env-file .env.local
```

## 🗄️ SQL Commands (Run in Supabase SQL Editor)

### Set Up Database
```sql
-- Copy and paste entire database_schema.sql file
-- Then click "Run" in Supabase SQL Editor
```

### Verify Tables Were Created
```sql
-- List all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
```

### Check RLS is Enabled
```sql
-- Verify Row Level Security is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

### View RLS Policies
```sql
-- List all policies
SELECT tablename, policyname, cmd 
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename;
```

### Count Records (Testing)
```sql
-- Count users
SELECT COUNT(*) FROM profiles;

-- Count messages
SELECT COUNT(*) FROM messages;

-- Count files
SELECT COUNT(*) FROM files;
```

## 🔧 Useful PowerShell Commands

### Navigate to Project Directory
```powershell
# Change to Flowsec directory
cd C:\Users\akash\Downloads\Flowsec

# View current directory contents
dir

# Or use ls (Linux-style)
ls
```

### Check if Git is Installed
```powershell
git --version
```

### Open Config File in Notepad
```powershell
notepad js\config.js
```

### View File Contents
```powershell
# View config file
Get-Content js\config.js

# View with line numbers
Get-Content js\config.js | Select-Object -First 20
```

## 🌐 GitHub Pages Commands

### Enable GitHub Pages (Web UI)
```
1. Go to: https://github.com/YOUR_USERNAME/Flowsec/settings/pages
2. Under "Source", select "GitHub Actions"
3. Save
```

### Check Deployment Status
```
Visit: https://github.com/YOUR_USERNAME/Flowsec/actions
```

### View Live Site
```
https://YOUR_USERNAME.github.io/Flowsec/
```

## 🔍 Debugging Commands

### Check Browser Console
```
Press F12 in your browser
Click "Console" tab
Look for errors (red text)
```

### View Supabase Logs
```
Go to: Supabase Dashboard > Logs > Select service
- API Logs - API requests
- Database Logs - SQL queries
- Auth Logs - Authentication events
```

### Test API Connection
```javascript
// Open browser console and run:
console.log(SUPABASE_URL);
console.log(SUPABASE_KEY.substring(0, 20) + '...');
```

## 📝 File Edit Commands

### Edit Configuration (Windows)
```powershell
# Open in Notepad
notepad js\config.js

# Or use VS Code
code js\config.js

# Or use default editor
start js\config.js
```

### Backup a File
```powershell
# Create backup before editing
Copy-Item js\config.js js\config.js.backup
```

### Restore from Backup
```powershell
# Restore if you made a mistake
Copy-Item js\config.js.backup js\config.js
```

## 🧪 Testing Commands

### Test Supabase Connection (Browser Console)
```javascript
// Check if Supabase client is initialized
console.log(supabaseClient);

// Test a simple query
const { data, error } = await supabaseClient
  .from('profiles')
  .select('*')
  .limit(1);
console.log(data, error);
```

### Generate Test Encryption Key
```powershell
# Generate and display
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))

# Generate and copy to clipboard
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 })) | Set-Clipboard
```

## 📊 Repository Management

### View Repository Info
```bash
# Show repository information
git remote show origin

# Show all branches
git branch -a

# Show current branch
git branch --show-current
```

### Clean Up (Use with Caution!)
```bash
# Discard all local changes (CAREFUL!)
git reset --hard HEAD

# Remove untracked files (CAREFUL!)
git clean -fd

# Discard changes to specific file
git checkout -- js/config.js
```

## 🚀 Deployment Checklist Commands

### Pre-Deployment Check
```bash
# Ensure you're on main branch
git branch --show-current

# Ensure working directory is clean
git status

# Ensure you're up to date
git pull origin main
```

### Deploy
```bash
# Stage all changes
git add .

# Commit
git commit -m "Deploy to GitHub Pages"

# Push (triggers GitHub Actions)
git push origin main

# Check deployment status
# Visit: https://github.com/YOUR_USERNAME/Flowsec/actions
```

## 🔑 Environment Variables

### Create .env File (for local development)
```bash
# Create .env file (DO NOT COMMIT THIS!)
echo "SUPABASE_URL=https://your-project.supabase.co" > .env
echo "SUPABASE_ANON_KEY=your-anon-key" >> .env
echo "SUPABASE_APP_KEY=your-encryption-key" >> .env
```

### Load .env in PowerShell
```powershell
# Read .env file
Get-Content .env | ForEach-Object {
    $key, $value = $_ -split '=', 2
    [Environment]::SetEnvironmentVariable($key, $value, 'Process')
}
```

## 🆘 Emergency Commands

### Revert Last Commit (Not Pushed)
```bash
# Undo last commit but keep changes
git reset --soft HEAD~1

# Undo last commit and discard changes
git reset --hard HEAD~1
```

### Revert Last Commit (Already Pushed)
```bash
# Create a new commit that undoes changes
git revert HEAD

# Push the revert
git push origin main
```

### Force Push (Use with EXTREME Caution!)
```bash
# Only use if you know what you're doing
git push --force origin main
```

## 📚 Help Commands

### Git Help
```bash
# General help
git help

# Help for specific command
git help commit
git help push
```

### Supabase Help
```bash
# General help
supabase help

# Help for specific command
supabase functions help
supabase link help
```

## 🎯 Quick Setup Flow (Copy-Paste Ready)

```powershell
# 1. Navigate to project
cd C:\Users\akash\Downloads\Flowsec

# 2. Check git status
git status

# 3. Run setup script
.\setup.ps1

# 4. OR manually configure:
# Edit js/config.js with your Supabase credentials

# 5. Commit changes
git add .
git commit -m "Configure for my Supabase account"

# 6. Push to GitHub
git push origin main

# 7. Enable GitHub Pages
# Visit: https://github.com/YOUR_USERNAME/Flowsec/settings/pages
# Set Source to "GitHub Actions"

# 8. Wait for deployment
# Check: https://github.com/YOUR_USERNAME/Flowsec/actions

# 9. Visit your live site
# https://YOUR_USERNAME.github.io/Flowsec/
```

---

## 💡 Pro Tips

### Copy Command Output
```powershell
# Pipe output to clipboard
git remote -v | Set-Clipboard
```

### Run Multiple Commands
```bash
# Chain commands with &&
git add . && git commit -m "Update" && git push origin main
```

### Create Alias (Git Shortcuts)
```bash
# Create shortcuts for common commands
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.cm commit

# Now you can use:
git st  # instead of git status
git co  # instead of git checkout
git cm  # instead of git commit
```

### View Pretty Git Log
```bash
# Beautiful one-line log
git log --oneline --graph --decorate --all

# Create alias for it
git config --global alias.lg "log --oneline --graph --decorate --all"
```

---

**Need more help?** Check the detailed guides:
- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Complete setup instructions
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Step-by-step checklist
- [WORKFLOW.md](WORKFLOW.md) - Visual workflow diagrams
