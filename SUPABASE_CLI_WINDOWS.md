# Installing Supabase CLI on Windows

The Supabase CLI cannot be installed via `npm install -g supabase` on Windows. Here are the working alternatives:

## ✅ Recommended Methods for Windows

### Method 1: Using Scoop (Recommended)

1. **Install Scoop** (if not already installed):
   ```powershell
   # Run in PowerShell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
   ```

2. **Install Supabase CLI**:
   ```powershell
   scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
   scoop install supabase
   ```

3. **Verify Installation**:
   ```powershell
   supabase --version
   ```

---

### Method 2: Using Chocolatey

1. **Install Chocolatey** (if not already installed):
   ```powershell
   # Run in PowerShell as Administrator
   Set-ExecutionPolicy Bypass -Scope Process -Force
   [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
   iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   ```

2. **Install Supabase CLI**:
   ```powershell
   choco install supabase
   ```

3. **Verify Installation**:
   ```powershell
   supabase --version
   ```

---

### Method 3: Direct Binary Download (Easiest)

1. **Download the Windows binary**:
   - Go to: https://github.com/supabase/cli/releases
   - Download the latest `supabase_windows_amd64.zip`

2. **Extract and Add to PATH**:
   ```powershell
   # Extract to a folder, e.g., C:\supabase
   # Add to PATH:
   $env:Path += ";C:\supabase"
   
   # Or add permanently via System Properties > Environment Variables
   ```

3. **Verify Installation**:
   ```powershell
   supabase --version
   ```

---

### Method 4: Using NPX (No Installation Required)

If you just need to run Supabase commands occasionally, use `npx`:

```bash
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase functions deploy encrypt
npx supabase functions deploy decrypt
```

**Note**: This will be slower as it downloads the CLI each time, but requires no installation.

---

## 🎯 Quick Setup Without Supabase CLI

**Good news**: The Supabase CLI is **optional** for basic setup! You can skip it if:

- ✅ You set up the database via SQL Editor (which you're already doing)
- ✅ You configure authentication via Supabase dashboard
- ✅ You don't need Edge Functions immediately

### What You'll Miss Without CLI:
- Server-side encrypt/decrypt functions (Edge Functions)
- Local development environment
- Database migrations via CLI

### What You Can Still Do:
- ✅ Set up complete database with SQL Editor
- ✅ Configure authentication
- ✅ Deploy to GitHub Pages
- ✅ Use all core features (messaging, file upload, etc.)
- ✅ Everything in the browser works perfectly

---

## 💡 Recommended Path for You

Since you're getting started, I recommend:

1. **Skip Supabase CLI for now** - It's optional
2. **Focus on core setup**:
   - Run `database_schema.sql` in Supabase SQL Editor ✅
   - Configure authentication in dashboard ✅
   - Update `js/config.js` ✅
   - Deploy to GitHub Pages ✅

3. **Install CLI later** (if needed):
   - Use **Method 1 (Scoop)** - cleanest for Windows
   - Or **Method 3 (Direct Download)** - fastest

---

## 🚀 Continue Your Setup

You can proceed with the rest of the setup without the CLI:

1. ✅ Database is set up via SQL Editor
2. ✅ Authentication configured via dashboard
3. ✅ Application configured in `js/config.js`
4. ✅ Deploy to GitHub Pages

**Next step**: Go to Step 9 in SETUP_GUIDE.md (Deploy to GitHub Pages)

---

## 🔧 If You Really Need Edge Functions

Edge Functions (encrypt/decrypt) are optional. The app works without them because:
- Encryption happens client-side in the browser
- JavaScript handles encryption/decryption
- Edge Functions are just an extra security layer

If you want them later:
1. Install CLI using Scoop (Method 1)
2. Deploy functions
3. Update your config to use them

---

## ✅ Your Current Status

You can continue without Supabase CLI. Here's what you have:

- ✅ Database schema ready (`database_schema.sql`)
- ✅ Application configured
- ✅ Ready to deploy to GitHub Pages

**Just skip Step 8** in the setup guide and go straight to **Step 9: Deploy to GitHub Pages**!

---

## 📞 Quick Commands Reference

### If you install via Scoop:
```powershell
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
supabase --version
```

### If you skip CLI (recommended for now):
```powershell
# Just continue with:
git add .
git commit -m "Configure for my account"
git push origin main
# Then enable GitHub Pages
```

---

**Bottom Line**: The Supabase CLI is optional. You can deploy and use Flowsec without it! Continue with Step 9 (Deploy to GitHub Pages).
