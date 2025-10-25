# Quick Deployment Checklist

Use this checklist to ensure you've completed all steps for deploying Flowsec to GitHub Pages with your own accounts.

## ✅ Pre-Deployment Checklist

### GitHub Setup
- [ ] Fork the Flowsec repository from your teammate's account
- [ ] Clone the forked repository to your local machine
- [ ] Verify you can push to your forked repository

### Supabase Setup
- [ ] Create a new Supabase project
- [ ] Copy the Project URL from Settings > API
- [ ] Copy the anon public key from Settings > API
- [ ] Execute `database_schema.sql` in SQL Editor
- [ ] Verify all tables are created (profiles, messages, files, backup_keys)
- [ ] Enable email authentication in Authentication > Providers
- [ ] Configure redirect URLs in Authentication > URL Configuration

### Application Configuration
- [ ] Update `js/config.js` with your Supabase URL
- [ ] Update `js/config.js` with your Supabase anon key
- [ ] Generate and add encryption key (SUPABASE_APP_KEY) to `js/config.js`
- [ ] (Optional) Add VirusTotal API key to `js/config.js`

### Storage Setup (Optional but Recommended)
- [ ] Create a storage bucket named `user-files` in Supabase Storage
- [ ] Set bucket to private (not public)
- [ ] Configure storage policies (see database_schema.sql comments)

### Edge Functions Setup (Optional)
- [ ] Install Supabase CLI: `npm install -g supabase`
- [ ] Login to Supabase CLI: `supabase login`
- [ ] Link project: `supabase link --project-ref YOUR_PROJECT_REF`
- [ ] Deploy encrypt function: `supabase functions deploy encrypt`
- [ ] Deploy decrypt function: `supabase functions deploy decrypt`
- [ ] Set encryption key secret: `supabase secrets set SUPABASE_APP_KEY=YOUR_KEY`

## 🚀 Deployment Steps

### Commit and Push
- [ ] Stage your changes: `git add js/config.js .gitignore`
- [ ] Commit: `git commit -m "Configure for my Supabase account"`
- [ ] Push to GitHub: `git push origin main`

### Enable GitHub Pages
- [ ] Go to GitHub repository Settings > Pages
- [ ] Under "Source", select "GitHub Actions"
- [ ] Wait for the workflow to complete (check Actions tab)
- [ ] Verify deployment succeeded (green checkmark)

### Post-Deployment
- [ ] Access your site: `https://YOUR_USERNAME.github.io/Flowsec/`
- [ ] Test signup flow
- [ ] Test login with OTP
- [ ] Test profile completion
- [ ] Test sending a message
- [ ] Test file upload (if storage configured)

## ⚠️ Security Reminders

### ✅ Safe to Commit
- Supabase Project URL
- Supabase anon public key
- VirusTotal API key (though consider moving to backend)

### ❌ NEVER Commit
- Supabase service_role key (if you have one)
- Database passwords
- Private keys or secrets
- `.env` files with sensitive data

### 🔒 Best Practices
- [ ] Encryption key is generated and unique to your project
- [ ] Email confirmation is enabled in Supabase
- [ ] RLS policies are enabled on all tables
- [ ] Storage bucket is set to private
- [ ] Redirect URLs are properly configured

## 🐛 Troubleshooting

### Issue: Changes not showing on GitHub Pages
- Clear browser cache or use incognito mode
- Wait 5-10 minutes for GitHub Pages to update
- Check Actions tab for deployment errors

### Issue: "Invalid API key"
- Verify you copied the complete anon key from Supabase
- Check for extra spaces or line breaks in config.js
- Ensure you're using the correct project URL

### Issue: Can't sign up/login
- Check browser console for errors (F12)
- Verify email auth is enabled in Supabase
- Check spam folder for OTP email
- Verify redirect URLs include your GitHub Pages domain

### Issue: Database errors
- Verify database_schema.sql was executed successfully
- Check that RLS policies are enabled
- Ensure you're authenticated when testing

## 📝 Next Steps After Deployment

- [ ] Share your live URL with others
- [ ] Consider adding custom domain
- [ ] Monitor usage in Supabase dashboard
- [ ] Set up analytics (optional)
- [ ] Customize branding and colors
- [ ] Add more features!

## 🔄 Updating from Upstream

To pull updates from your teammate's repository:

```bash
# Add upstream remote (one time only)
git remote add upstream https://github.com/TEAMMATE_USERNAME/Flowsec.git

# Fetch and merge updates
git fetch upstream
git merge upstream/main

# Resolve any conflicts, then push
git push origin main
```

## 📚 Resources

- [Supabase Documentation](https://supabase.com/docs)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- See `SETUP_GUIDE.md` for detailed instructions

---

**Last Updated**: Check the timestamp of this file in git history
**Your GitHub Pages URL**: `https://YOUR_USERNAME.github.io/Flowsec/`
**Your Supabase Project**: `https://app.supabase.com/project/YOUR_PROJECT_REF`
