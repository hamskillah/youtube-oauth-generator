# 🔑 YouTube OAuth TV Token Generator

> ⚠️ **Not fully automated** — Google requires manual approval via phone browser for each token.

Generate multiple YouTube OAuth TV refresh tokens interactively. Perfect for Discord bots, Lavalink, or any app that needs YouTube OAuth.

---

## 🚀 Quick Start

```bash
git clone https://github.com/hamskillah/youtube-oauth-generator.git
cd youtube-oauth-generator
bash generate.sh
📋 What You Need

· bash (Linux/Mac built-in)
· curl (built-in)
· python3 (apt install python3)
· Smartphone 📱 (for manual approval)

---

🔧 Step-by-Step

1. Get OAuth Client ID

1. Go to Google Cloud Console
2. Create a project (or select existing)
3. Enable YouTube Data API v3
4. Go to Credentials → + CREATE CREDENTIALS → OAuth client ID
5. Application type: TVs and Limited Input devices
6. Name: My Bot TV
7. Copy the Client ID and Client Secret

⚠️ IMPORTANT: Your OAuth app MUST be set to "Published" (Production), not "Testing".

Go to OAuth consent screen → click "Publish App" → Confirm.
If the app is in "Testing" mode, refresh tokens will be revoked after 7 days!

2. Run Generator

```bash
bash generate.sh
```

3. Enter Your Data

```
How many tokens? [1-10]: 2
─── ACCOUNT 1 ───
Client ID: YOUR_CLIENT_ID
Client Secret: YOUR_CLIENT_SECRET
```

4. Approve on Phone 📱

```
📱 Account 1:
│ 🔗 https://www.google.com/device
│ 📋 Code: ABC-DEF-GHI
│ ⏰ Open URL on your phone, enter the code
```

1. Open https://www.google.com/device on your phone
2. Enter the code shown
3. Tap Allow

5. Get Token

```
✅ ACCOUNT 1 SUCCESS!
ACCOUNT_1=1//03qVNgtWNLX1gCgYIARAAGAM...
```

6. Use Token

Lavalink config:

```yaml
plugins:
  youtube:
    oauth:
      enabled: true
      refreshToken: "YOUR_TOKEN_HERE"
```

---

⚠️ Important Notes

Note Detail
App must be Published Go to OAuth consent screen → Publish App
Testing mode = 7 days Tokens expire in 7 days if app not published
Production mode = forever Refresh tokens last until manually revoked
One Client ID per account Each Google account needs its own OAuth Client ID
Use burner accounts Don't use your main Google account for bots

---

📄 License

MIT — Free to use, modify, share.
