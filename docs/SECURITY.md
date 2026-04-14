# Security

## Guiding rules
- Never commit secrets or signing material; use GitHub Actions secrets and platform vaults.
- Enforce HTTPS/TLS for all API calls; enable certificate pinning where supported.
- Limit data exposure in logs; redact tokens and user identifiers.

## Credential storage
- **Android:** Keystore + EncryptedSharedPreferences; Media3 sessions avoid leaking tokens; scoped storage for downloads.
- **iOS/macOS:** Keychain for tokens; `AVAudioSession` configured for background playback without exposing credentials; app sandbox for downloads.
- **Windows:** Credential Manager; app data stored under `%LocalAppData%/Monochrome`.
- **Linux:** libsecret/kwallet; user-level file permissions for caches and downloads.
- **Web/PWA:** IndexedDB + cookie/session with secure flags; service worker honors fetch scopes.

## Network hardening
- Strict HTTPS; reject invalid certificates.
- Optional pinning of backend certificates (PocketBase/Appwrite); rotate pins with versioned config.
- Use per-request timeouts and retries with backoff; disable caching of auth responses.

## Dependency hygiene
- Regular `bun audit`/`npm audit` and platform equivalents (`gradle dependencies --write-locks`, `swift package show-dependencies`, `winget/nuget audit`).
- Review third-party media libraries (ffmpeg, shaka-player, hls.js) for CVEs; keep overrides for known issues (`sourcemap-codec`, `source-map`, `serialize-javascript` already pinned).

## Data protection
- Downloads stored in app-private directories with integrity hashes.
- Minimal PII stored: favorites/history/pins keep IDs and basic metadata only.
- Wipe on logout: clear caches, revoke tokens, remove downloads if required by policy.

## CI/CD
- Secrets only via GitHub Actions secrets; no plain-text keys in workflows.
- Artifacts are unsigned by default; signing is deferred to platform app stores or downstream pipelines.
- Security checks (linting for secrets, dependency audits) are fast-follow tasks when native build steps are added.
