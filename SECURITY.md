# 🔒 Security Best Practices

This document outlines the security measures implemented in these dotfiles and best practices for maintaining a secure development environment.

## 🚨 Critical Security Warnings

### Never Commit These Files

The following files contain sensitive information and should **NEVER** be committed to version control:

- SSH private keys (`~/.ssh/id_*`, `~/.ssh/*_rsa`, `~/.ssh/*_ed25519`)
- GPG private keys (`~/.gnupg/private-keys-v1.d/`, `*.gpg`, `*.key`)
- npm auth tokens (`~/.npmrc` with `_authToken`)
- AWS credentials (`~/.aws/credentials`, `~/.aws/config`)
- Docker credentials (`~/.docker/config.json`)
- Environment files with secrets (`.env`, `.env.local`, `*.secret`)
- Git credentials (`~/.git-credentials`)

All these patterns are included in [.gitignore](.gitignore:76-115).

### ⚠️ If You Accidentally Commit Secrets

If you accidentally commit sensitive data:

1. **Immediately revoke the exposed credentials**
   - npm tokens: `npm token revoke <token>`
   - GitHub tokens: Settings → Developer settings → Personal access tokens
   - AWS keys: AWS Console → IAM → Security credentials

2. **Remove from Git history**

   ```bash
   # Use BFG Repo-Cleaner or git-filter-repo
   brew install bfg
   bfg --delete-files .npmrc
   git push --force
   ```

3. **Scan for leaked secrets**

   ```bash
   gitleaks detect --source . -v
   ```

## 🛡️ Security Features Implemented

### Git Security ([git/.gitconfig](git/.gitconfig))

- ✅ **Commit signing**: All commits are GPG-signed to verify authorship
- ✅ **Tag signing**: All tags are GPG-signed
- ✅ **HTTPS enforcement**: Always use HTTPS instead of git:// protocol
- ✅ **Merge signature verification**: Disabled by default to keep `git pull` unblocked; enable with `merge.verifySignatures=true` if required
- ✅ **Object validation**: Check objects during transfer/receive
- ✅ **Fast-forward only pulls**: Prevent accidental merge commits
- ✅ **Safer force push**: Use `--force-with-lease` instead of `--force`
- ✅ **macOS Keychain**: Uses `osxkeychain` credential helper

### SSH Security ([ssh/.ssh/config](ssh/.ssh/config))

- ✅ **Ed25519 keys**: Prefer Ed25519 over RSA
- ✅ **Hash known hosts**: Protect against host enumeration
- ✅ **No agent forwarding**: Disabled by default
- ✅ **Keychain + agent**: Add keys to agent and macOS Keychain
- ✅ **Connection reuse**: ControlMaster with per-host sockets under `~/.ssh/sockets`
- ✅ **Keepalive**: Server-alive pings to drop dead sessions
- ✅ **Local overrides**: Place host-specific settings in `~/.ssh/config.local`

### npm Security ([npm/.npmrc](npm/.npmrc))

- ✅ **No hardcoded tokens**: Auth tokens stored separately
- ✅ **Save exact versions**: Pin package versions for reproducibility
- ✅ **Provenance support**: Ready for package attestation
- ✅ **Prefer pnpm**: More secure package manager

### Shell Security ([zsh/.zshrc](zsh/.zshrc))

- ✅ **No clobber**: Prevent accidental file overwrites
- ✅ **History privacy**: Don't save commands starting with space
- ✅ **Strict umask**: Files 644, directories 755
- ✅ **No core dumps**: Prevent sensitive data leakage
- ✅ **Auto-clear secrets**: Unset sensitive env vars on exit
- ✅ **GPG auto-lock**: Lock GPG after 30 minutes

## 🔐 Security Tools Included

### Installed via Brewfile

- **gnupg**: GPG encryption and signing
- **git-crypt**: Transparent file encryption in git
- **age**: Modern file encryption
- **ssh-audit**: Audit SSH configurations
- **lynis**: System security auditing
- **trivy**: Container and IaC vulnerability scanning
- **gitleaks**: Scan for secrets in git repos
- **mkcert**: Local TLS certificates

### Usage Examples

#### Scan for secrets in your repo

```bash
gitleaks detect --source . -v
```

#### Audit your SSH configuration

```bash
ssh-audit localhost
```

#### Scan for vulnerabilities

```bash
trivy fs .
trivy config .
```

#### System security audit

```bash
sudo lynis audit system
```

## 🔑 SSH Key Management

### Generate Secure SSH Keys

Use Ed25519 (most secure and fastest):

```bash
# Generate Ed25519 key (recommended)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Or RSA 4096-bit (if Ed25519 not supported)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### Create SSH socket directory

```bash
mkdir -p ~/.ssh/sockets
chmod 700 ~/.ssh/sockets
```

### Set proper permissions

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config
```

### Add to GitHub/GitLab

```bash
# Copy public key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub

# Then add to:
# GitHub: Settings → SSH and GPG keys
# GitLab: Preferences → SSH Keys
```

## 🔐 GPG Key Management

`pinentry-mac` is resolved via PATH, covering both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`) Homebrew installs.

### Generate GPG Keys

```bash
# Generate new GPG key (RSA 4096-bit)
gpg --full-generate-key

# List keys
gpg --list-secret-keys --keyid-format LONG

# Export public key
gpg --armor --export YOUR_KEY_ID | pbcopy
```

### Configure Git to use GPG

```bash
# Set signing key
git config --global user.signingkey YOUR_KEY_ID

# Enable signing
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

### Backup GPG Keys

```bash
# Export private key (KEEP SECURE!)
gpg --export-secret-keys YOUR_KEY_ID > gpg-private-key.asc

# Export public key
gpg --export YOUR_KEY_ID > gpg-public-key.asc

# Store in secure location (NOT in this repo!)
```

## 🔒 git-crypt for Sensitive Files

Use git-crypt to encrypt sensitive files in your repository:

### Setup git-crypt

```bash
# Initialize git-crypt in your repo
cd your-repo
git-crypt init

# Add GPG user (use your GPG key ID)
git-crypt add-gpg-user YOUR_GPG_KEY_ID

# Create .gitattributes to specify files to encrypt
echo "secrets/** filter=git-crypt diff=git-crypt" >> .gitattributes
echo ".env.* filter=git-crypt diff=git-crypt" >> .gitattributes

# Lock/unlock
git-crypt lock
git-crypt unlock
```

### What to encrypt with git-crypt

- API keys and tokens
- Database credentials
- SSL certificates
- Environment files with secrets
- Service account keys

## 🌐 1Password SSH & Git Signing

If you use 1Password, you can use it for SSH and Git signing:

### Enable 1Password SSH Agent

```bash
# Add to ~/.ssh/config
# IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

### Configure Git to use 1Password

1. Settings → Developer → Use the SSH agent
2. Settings → Developer → Use 1Password to sign Git commits

## 📋 Security Checklist

### Initial Setup

- [ ] Generate Ed25519 SSH key
- [ ] Add SSH key to GitHub/GitLab
- [ ] Generate GPG key (RSA 4096)
- [ ] Configure Git to use GPG signing
- [ ] Upload GPG public key to GitHub/GitLab
- [ ] Create `~/.npmrc.local` with npm token (not `.npmrc`)
- [ ] Create `~/.zshrc.local` for private aliases/env vars
- [ ] Set up 1Password SSH agent (optional)

### Regular Maintenance

- [ ] Rotate SSH keys annually
- [ ] Rotate GPG keys every 2-3 years
- [ ] Rotate npm tokens quarterly
- [ ] Rotate AWS keys every 90 days
- [ ] Review and revoke unused tokens
- [ ] Run `gitleaks detect` on repos
- [ ] Run `trivy fs .` for vulnerabilities
- [ ] Update security tools: `brew upgrade`

### Before Committing

- [ ] Review `git diff` for sensitive data
- [ ] Never commit real secrets (use `.env.example` instead)
- [ ] Never commit auth tokens
- [ ] Never commit private keys
- [ ] Run `gitleaks detect` before pushing

## 🆘 Security Incident Response

### If credentials are leaked

1. **Stop the leak**
   - Don't commit any more changes
   - Don't push if not already pushed

2. **Revoke immediately**
   - Revoke the compromised credentials
   - Generate new credentials

3. **Clean history**
   - Use `git-filter-repo` or BFG Repo-Cleaner
   - Force push to remote (if already pushed)

4. **Monitor**
   - Check AWS CloudTrail for suspicious activity
   - Check GitHub security log
   - Enable 2FA if not already enabled

5. **Learn**
   - Update `.gitignore` to prevent recurrence
   - Add pre-commit hooks (gitleaks)
   - Document the incident

## 📚 Additional Resources

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [npm Security Best Practices](https://github.com/bodadotsh/npm-security-best-practices)
- [SSH Security Guide](https://infosec.mozilla.org/guidelines/openssh)
- [GPG Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices)
- [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

## 🔗 Related Documentation

- [README.md](README.md) - Main setup documentation
- [.gitignore](.gitignore) - Files excluded from version control
- [git/.gitconfig](git/.gitconfig) - Git security configuration
- [ssh/.ssh/config](ssh/.ssh/config) - SSH hardening configuration
- [npm/.npmrc](npm/.npmrc) - npm security configuration

---

**Remember**: Security is an ongoing process, not a one-time setup. Stay vigilant!
