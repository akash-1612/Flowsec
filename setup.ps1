# Flowsec Setup Helper Script for Windows
# This script helps you set up Flowsec with your own GitHub and Supabase accounts

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Flowsec Setup Helper for Windows" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "js\config.js")) {
    Write-Host "ERROR: Please run this script from the Flowsec project root directory!" -ForegroundColor Red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "Step 1: Git Configuration" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "Current git remote:" -ForegroundColor Yellow
git remote -v

Write-Host ""
$changeRemote = Read-Host "Do you want to change the remote to your forked repository? (y/n)"
if ($changeRemote -eq 'y') {
    $username = Read-Host "Enter your GitHub username"
    $repoName = Read-Host "Enter the repository name (default: Flowsec)"
    if ([string]::IsNullOrWhiteSpace($repoName)) {
        $repoName = "Flowsec"
    }
    
    git remote set-url origin "https://github.com/$username/$repoName.git"
    Write-Host "✓ Remote updated to: https://github.com/$username/$repoName.git" -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 2: Generate Encryption Key" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "Generating a secure encryption key..." -ForegroundColor Yellow

# Generate random 32 bytes and convert to Base64
$bytes = New-Object byte[] 32
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($bytes)
$encryptionKey = [Convert]::ToBase64String($bytes)

Write-Host "✓ Encryption key generated:" -ForegroundColor Green
Write-Host $encryptionKey -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANT: Save this key securely! You'll need it for the next step." -ForegroundColor Yellow
Write-Host ""

# Copy to clipboard if possible
try {
    Set-Clipboard -Value $encryptionKey
    Write-Host "✓ Key copied to clipboard!" -ForegroundColor Green
} catch {
    Write-Host "Note: Could not copy to clipboard. Please copy the key manually." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 3: Supabase Configuration" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host "Please provide your Supabase project details:" -ForegroundColor Yellow
Write-Host "(You can find these in: Supabase Dashboard > Settings > API)" -ForegroundColor Gray
Write-Host ""

$supabaseUrl = Read-Host "Enter your Supabase URL (e.g., https://xxxxx.supabase.co)"
$supabaseKey = Read-Host "Enter your Supabase anon key (long JWT token)"

Write-Host ""
$useVirusTotal = Read-Host "Do you have a VirusTotal API key? (y/n)"
$virusTotalKey = ""
if ($useVirusTotal -eq 'y') {
    $virusTotalKey = Read-Host "Enter your VirusTotal API key"
}

Write-Host ""
Write-Host "Step 4: Update Configuration File" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray

# Read the current config file
$configPath = "js\config.js"
$configContent = Get-Content $configPath -Raw

# Create backup
$backupPath = "js\config.js.backup"
Copy-Item $configPath $backupPath
Write-Host "✓ Backup created: $backupPath" -ForegroundColor Green

# Update the configuration
$configContent = $configContent -replace "const SUPABASE_URL = '[^']*';", "const SUPABASE_URL = '$supabaseUrl';"
$configContent = $configContent -replace "const SUPABASE_KEY = '[^']*';", "const SUPABASE_KEY = '$supabaseKey';"
$configContent = $configContent -replace "const SUPABASE_APP_KEY = '[^']*';", "const SUPABASE_APP_KEY = '$encryptionKey';"

if ($virusTotalKey) {
    $configContent = $configContent -replace "const VIRUSTOTAL_API_KEY = '[^']*';", "const VIRUSTOTAL_API_KEY = '$virusTotalKey';"
}

# Save the updated config
Set-Content -Path $configPath -Value $configContent
Write-Host "✓ Configuration file updated!" -ForegroundColor Green

Write-Host ""
Write-Host "Step 5: Git Commit" -ForegroundColor Green
Write-Host "----------------------------------------" -ForegroundColor Gray

$commitChanges = Read-Host "Do you want to commit these changes? (y/n)"
if ($commitChanges -eq 'y') {
    git add js\config.js .gitignore README.md SETUP_GUIDE.md DEPLOYMENT_CHECKLIST.md database_schema.sql storage_setup.sql
    git commit -m "Configure Flowsec with my Supabase account"
    Write-Host "✓ Changes committed!" -ForegroundColor Green
    
    Write-Host ""
    $pushChanges = Read-Host "Do you want to push to GitHub now? (y/n)"
    if ($pushChanges -eq 'y') {
        git push origin main
        Write-Host "✓ Changes pushed to GitHub!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Set up Supabase Database:" -ForegroundColor White
Write-Host "   - Go to your Supabase project > SQL Editor" -ForegroundColor Gray
Write-Host "   - Copy and paste the contents of 'database_schema.sql'" -ForegroundColor Gray
Write-Host "   - Click 'Run' to create all tables" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Configure Authentication:" -ForegroundColor White
Write-Host "   - Go to Authentication > Providers" -ForegroundColor Gray
Write-Host "   - Enable 'Email' provider" -ForegroundColor Gray
Write-Host "   - Go to URL Configuration" -ForegroundColor Gray
Write-Host "   - Add your GitHub Pages URL to Redirect URLs" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Enable GitHub Pages:" -ForegroundColor White
Write-Host "   - Go to your GitHub repository > Settings > Pages" -ForegroundColor Gray
Write-Host "   - Set Source to 'GitHub Actions'" -ForegroundColor Gray
Write-Host "   - Wait for deployment to complete" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Test Your Deployment:" -ForegroundColor White
Write-Host "   - Visit: https://YOUR_USERNAME.github.io/Flowsec/" -ForegroundColor Gray
Write-Host ""
Write-Host "For detailed instructions, see:" -ForegroundColor Yellow
Write-Host "   - SETUP_GUIDE.md (complete setup guide)" -ForegroundColor Cyan
Write-Host "   - DEPLOYMENT_CHECKLIST.md (step-by-step checklist)" -ForegroundColor Cyan
Write-Host ""
Write-Host "Good luck with your Flowsec deployment! 🚀" -ForegroundColor Green
Write-Host ""
