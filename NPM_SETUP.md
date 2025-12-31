# 🚀 NPM Auto-Publish Setup Guide

## Cara Kerja Auto-Publish

Setiap kali Anda **push ke GitHub** (main branch), GitHub Actions akan:
1. ✅ Cek versi di `package.json`
2. ✅ Cek apakah versi sudah ada di NPM
3. ✅ Jika versi baru → Auto-publish ke NPM
4. ✅ Create Git tag (v8.4.1)
5. ✅ Create GitHub Release

**Hasil:** Perubahan di GitHub otomatis sync ke NPM! 🎊

---

## 📝 Setup Steps (One-Time Only)

### Step 1: Generate NPM Access Token

1. **Login ke NPM**
   ```bash
   npm login
   ```
   
2. **Buka NPM Settings**
   - Go to: https://www.npmjs.com/settings/YOUR_USERNAME/tokens
   - Or: https://www.npmjs.com → Profile → Access Tokens

3. **Generate Classic Token**
   - Click: **"Generate New Token"** → **"Classic Token"**
   - Token Type: **Automation** (for CI/CD)
   - Click: **"Generate Token"**

4. **Copy Token**
   - Format: `npm_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - ⚠️ **SAVE IT!** (hanya muncul sekali)

---

### Step 2: Add Token to GitHub Secrets

1. **Buka GitHub Repository Settings**
   - Go to: https://github.com/zesbe/ClaudeAll
   - Click: **Settings** (tab)

2. **Add Secret**
   - Sidebar: **Secrets and variables** → **Actions**
   - Click: **"New repository secret"**
   
3. **Create Secret**
   - Name: `NPM_TOKEN`
   - Value: `npm_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx` (paste token Anda)
   - Click: **"Add secret"**

✅ **Done!** GitHub Actions sekarang bisa publish ke NPM!

---

## 🎯 How to Publish (Super Simple!)

### Method 1: Update Version & Push (Recommended)

```bash
cd ~/ClaudeAll

# 1. Update version
echo "8.4.2" > VERSION
sed -i 's/"version": "8.4.1"/"version": "8.4.2"/' package.json

# 2. Make your changes (edit code, docs, etc)
# ...

# 3. Commit & Push
git add -A
git commit -m "feat: Your feature description"
git push origin main

# ✨ GitHub Actions will automatically:
# - Publish v8.4.2 to NPM
# - Create git tag v8.4.2
# - Create GitHub Release v8.4.2
```

### Method 2: Manual Publish (If Needed)

```bash
cd ~/ClaudeAll

# Update version
echo "8.4.2" > VERSION
sed -i 's/"version": "8.4.1"/"version": "8.4.2"/' package.json

# Commit
git add -A
git commit -m "chore: bump version to 8.4.2"
git push origin main

# Manual publish (if workflow fails)
npm publish --access public
```

---

## 🔍 Check Workflow Status

1. **GitHub Actions Page**
   - Go to: https://github.com/zesbe/ClaudeAll/actions
   - Check: **"Publish to NPM"** workflow
   - Status: ✅ Success / ❌ Failed

2. **NPM Package Page**
   - Go to: https://www.npmjs.com/package/claude-all-ai-launcher
   - Check: Latest version

---

## 🎊 Benefits

✅ **Auto-Sync**: GitHub → NPM otomatis
✅ **No Manual Publish**: Tidak perlu `npm publish` lagi
✅ **Versioned Releases**: Auto-create git tags & GitHub releases
✅ **CI/CD Pipeline**: Professional workflow
✅ **Time Saving**: 1 push = semua update

---

## 🛠️ Troubleshooting

### Problem: Workflow Failed (NPM_TOKEN not found)

**Solution:**
```
Pastikan NPM_TOKEN sudah di-add ke GitHub Secrets:
https://github.com/zesbe/ClaudeAll/settings/secrets/actions
```

### Problem: Version Already Exists on NPM

**Solution:**
```bash
# Update version number di package.json
sed -i 's/"version": "8.4.1"/"version": "8.4.2"/' package.json

# Update VERSION file juga
echo "8.4.2" > VERSION

# Commit & push
git add -A
git commit -m "chore: bump version to 8.4.2"
git push origin main
```

### Problem: Workflow Not Running

**Solution:**
```
Check if .github/workflows/npm-publish.yml exists:
https://github.com/zesbe/ClaudeAll/blob/main/.github/workflows/npm-publish.yml
```

---

## 📊 Workflow Triggers

Workflow akan auto-run ketika:
- ✅ Push ke branch `main`
- ✅ File berubah: `package.json`, `VERSION`, `claude-all`, `README.md`
- ✅ Manual trigger (via GitHub Actions UI)

---

## 🎯 Summary

**Before:**
```bash
# Manual process:
1. Edit code
2. Update version
3. git commit & push
4. npm publish          # ← Manual!
5. Create git tag       # ← Manual!
6. Create GitHub release # ← Manual!

Total: 6 steps, ~5 minutes
```

**After:**
```bash
# Automated process:
1. Edit code
2. Update version
3. git commit & push    # ← Only this!

GitHub Actions does the rest automatically!

Total: 3 steps, ~1 minute
```

---

## 🚀 Ready to Use!

Once NPM_TOKEN is set in GitHub Secrets:

```bash
# Just push to GitHub
git push origin main

# GitHub Actions will:
# ✓ Check version
# ✓ Publish to NPM
# ✓ Create tag
# ✓ Create release

# Done! 🎊
```

---

**Made with ❤️ for ClaudeAll v8.4.1**
