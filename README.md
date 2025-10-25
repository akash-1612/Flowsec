# 🔐 Flowsec - Secure Messaging Platform

A modern, end-to-end encrypted messaging platform built with vanilla JavaScript and Supabase. Features include secure messaging, file sharing with virus scanning, multi-account support, and passwordless authentication.

![Flowsec Banner](https://via.placeholder.com/1200x300/4F46E5/FFFFFF?text=Flowsec+-+Secure+Messaging)

## ✨ Features

- 🔒 **End-to-End Encryption** - All messages encrypted client-side
- 📧 **Passwordless Authentication** - Secure OTP-based login
- 📁 **Secure File Sharing** - Encrypted file uploads with virus scanning
- 👥 **Multi-Account Support** - Manage multiple accounts simultaneously
- 🎨 **Modern UI** - Clean, responsive design with dark mode
- ⚡ **Real-time Updates** - Instant message delivery
- 🔑 **Key Backup & Recovery** - Never lose access to your messages
- 🦠 **VirusTotal Integration** - Automatic file scanning for malware

## 🚀 Quick Start

### For Users

1. Visit the live demo: [https://YOUR_USERNAME.github.io/Flowsec/](https://YOUR_USERNAME.github.io/Flowsec/)
2. Click "Sign Up" and enter your email
3. Check your email for the OTP code
4. Complete your profile
5. Start chatting securely!

### For Developers

Want to deploy your own instance? Follow the [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete instructions.

**Quick Overview:**
1. Fork this repository
2. Create a Supabase project
3. Run `database_schema.sql` in Supabase SQL Editor
4. Update `js/config.js` with your credentials
5. Push to GitHub and enable GitHub Pages

See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) for a step-by-step checklist.

## 📋 Prerequisites

- A GitHub account (for hosting)
- A Supabase account (free tier works)
- Git installed locally
- A text editor

## 🏗️ Tech Stack

- **Frontend**: Vanilla JavaScript, HTML5, CSS3
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Edge Functions)
- **Hosting**: GitHub Pages
- **Encryption**: Web Crypto API (AES-GCM)
- **Security**: VirusTotal API for file scanning

## 📁 Project Structure

```
Flowsec/
├── index.html              # Landing page
├── pages/                  # Application pages
│   ├── login.html         # Login page
│   ├── signup.html        # Registration page
│   ├── otp.html           # OTP verification
│   ├── complete-profile.html
│   ├── chat.html          # Main chat interface
│   ├── file-manager.html  # File management
│   └── quick-check.html   # Quick file scanner
├── js/                    # JavaScript modules
│   ├── config.js          # Configuration
│   ├── supabase-client.js # Supabase client setup
│   ├── auth.js            # Authentication logic
│   ├── chat.js            # Chat functionality
│   ├── encryption.js      # Encryption utilities
│   ├── file-service.js    # File handling
│   ├── virustotal.js      # VirusTotal integration
│   └── theme-toggle.js    # Dark mode toggle
├── css/                   # Stylesheets
│   ├── auth.css
│   ├── chat.css
│   └── ...
├── supabase/              # Supabase Edge Functions
│   └── functions/
│       ├── encrypt/
│       └── decrypt/
├── database_schema.sql    # Database setup script
├── storage_setup.sql      # Storage bucket setup
├── SETUP_GUIDE.md         # Detailed setup guide
├── DEPLOYMENT_CHECKLIST.md # Quick deployment checklist
└── README.md              # This file
```

## 🔧 Configuration

### Environment Variables

The app uses `js/config.js` for configuration. You need to set:

```javascript
const SUPABASE_URL = 'your-project-url';
const SUPABASE_KEY = 'your-anon-key';
const SUPABASE_APP_KEY = 'your-encryption-key'; // Generate with: openssl rand -base64 32
const VIRUSTOTAL_API_KEY = 'your-virustotal-key'; // Optional
```

**⚠️ Security Note**: The `SUPABASE_KEY` (anon key) is safe to expose in client-side code. Never commit your service_role key!

## 🗄️ Database Schema

The application uses four main tables:

- **profiles** - User profile information
- **messages** - Encrypted messages
- **files** - File metadata
- **backup_keys** - Encrypted key backups

All tables have Row Level Security (RLS) enabled. See [database_schema.sql](database_schema.sql) for complete schema.

## 🔐 Security Features

### Encryption
- Client-side AES-GCM encryption
- Unique encryption keys per user
- Secure key derivation using PBKDF2
- Initialization vectors (IV) for each message

### Authentication
- Passwordless OTP via email
- Session management with Supabase Auth
- Multi-account support with session isolation
- Automatic token refresh

### File Security
- Encrypted file storage
- VirusTotal scanning before download
- Access control via RLS policies
- Secure file sharing

## 🎨 Customization

### Theming
The app supports dark and light modes. Modify `css/` files to customize:
- Colors and fonts
- Layout and spacing
- Component styles

### Features
Add new features by:
1. Creating new pages in `pages/`
2. Adding JavaScript modules in `js/`
3. Updating the database schema if needed
4. Deploying via GitHub Actions

## 📱 Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Opera 76+

Requires support for:
- Web Crypto API
- ES6+ JavaScript
- CSS Grid and Flexbox

## 🐛 Known Issues & Solutions

### CORS with VirusTotal
Direct API calls to VirusTotal may fail due to CORS. See [VIRUSTOTAL_CORS_ISSUE.md](VIRUSTOTAL_CORS_ISSUE.md) for solutions.

### Email Delivery
If OTP emails aren't arriving:
- Check spam folder
- Verify email auth is enabled in Supabase
- Configure custom SMTP in Supabase (recommended for production)

### File Upload Limits
- Supabase Storage: 50MB per file (free tier)
- Can be increased on paid plans
- Consider implementing chunked uploads for large files

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Supabase](https://supabase.com) - Backend infrastructure
- [VirusTotal](https://www.virustotal.com) - File scanning API
- [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API) - Client-side encryption

## 📞 Support

- **Documentation**: See [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Issues**: Open an issue on GitHub
- **Discussions**: Use GitHub Discussions for questions

## 🗺️ Roadmap

- [ ] Group chat support
- [ ] Voice/video calling
- [ ] Desktop app (Electron)
- [ ] Mobile apps (React Native)
- [ ] Message search functionality
- [ ] Advanced file previews
- [ ] Read receipts
- [ ] Typing indicators
- [ ] Push notifications
- [ ] Two-factor authentication

## 📊 Status

- **Build**: ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/YOUR_USERNAME/Flowsec/deploy.yml)
- **License**: ![License](https://img.shields.io/badge/license-MIT-blue.svg)
- **Version**: ![Version](https://img.shields.io/badge/version-1.0.0-green.svg)

## 🌟 Star History

If you find this project useful, please consider giving it a star! ⭐

---

**Made with ❤️ for secure communication**

**Live Demo**: [https://YOUR_USERNAME.github.io/Flowsec/](https://YOUR_USERNAME.github.io/Flowsec/)

**Repository**: [https://github.com/YOUR_USERNAME/Flowsec](https://github.com/YOUR_USERNAME/Flowsec)
