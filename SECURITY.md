# Security Guide

This repository keeps only shareable configuration in version control. Secrets and machine-specific credentials stay local.

## Never Commit Sensitive Files

The following must stay out of git history:

- SSH private keys (`~/.ssh/id_*`)
- GPG private keys (`~/.gnupg/private-keys-v1.d/`)
- npm tokens (`~/.npmrc.local`)
- Cloud credentials (`~/.aws/credentials`, `~/.docker/config.json`)
- `.env` files with real secrets
- `~/.gitconfig.local` when it contains personal identity/signing values

These patterns are covered by [.gitignore](.gitignore).

## Repository Security Defaults

### Git configuration (`git/.gitconfig`)

- Includes local overrides from `~/.gitconfig.local`
- Uses macOS Keychain credential helper (`osxkeychain`)
- Enforces fast-forward pulls (`pull.ff=only`)
- Enables transfer and receive object checks (`fsckObjects=true`)
- Sets merge signature verification to off by default (`merge.verifySignatures=false`)
- Rewrites GitHub HTTPS URLs to SSH (`https://github.com/...` -> `git@github.com:...`)
- Rewrites `git://` URLs to `https://`

### Commit and tag signing behavior

Signing is configured in `~/.gitconfig.local` during `setup.sh`:

- If a signing key is present, commit and tag signing are enabled.
- If no signing key is set, signing remains disabled.

This means signing is conditional, not universally forced.

### SSH configuration (`ssh/.ssh/config`)

- Prefers Ed25519 keys
- Disables agent forwarding by default
- Enables hashed known hosts (`HashKnownHosts yes`)
- Uses per-host connection multiplexing under `~/.ssh/sockets`
- Allows machine-local overrides via `~/.ssh/config.local`

`~/.ssh/known_hosts` is intentionally machine-local and not stowed.

### GPG configuration (`gpg/.gnupg/*`)

- Uses `pinentry-mac` from detected Homebrew path
- Sets agent cache timeout defaults
- Enables key retrieval and fingerprint-friendly output in `gpg.conf`

### Shell and npm defaults

- `npm/.npmrc` avoids hardcoded tokens (use `~/.npmrc.local`)
- `zsh/.zshrc` sets safer shell defaults (`NO_CLOBBER`, history filtering, strict umask)

## Verify Your Local Security State

```bash
# Verify Git signing and identity settings in effect
git config --show-origin --get user.signingkey
git config --show-origin --get commit.gpgsign
git config --show-origin --get tag.gpgSign

# Check SSH and GPG tooling
ssh -G github.com | head -n 30
gpg --version | head -n 1

# Scan for accidental secrets in this repo
gitleaks detect --source . -v
```

## Incident Response (Credential Leak)

1. Revoke exposed credentials immediately.
2. Rotate keys/tokens and update local config.
3. Remove leaked content from git history (`git-filter-repo` or BFG).
4. Force-push cleaned history if needed.
5. Re-run `gitleaks detect` before sharing the repository again.

## Related Docs

- [README.md](README.md)
- [docs/INSTALL.md](docs/INSTALL.md)
- [docs/OPERATIONS.md](docs/OPERATIONS.md)
- [docs/CUSTOMIZATION.md](docs/CUSTOMIZATION.md)
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
