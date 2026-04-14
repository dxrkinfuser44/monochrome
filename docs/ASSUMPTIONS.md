# Assumptions

Because maintainer clarifications are unavailable, the following assumptions guide the native/offline-first rollout:

- **Cross-platform strategy:** Implement shared data/sync contracts across all platforms while building native-first UI and media pipelines per OS (no reliance on a webview shell beyond the existing PWA).
- **Authentication domain:** PocketBase/Appwrite endpoints remain stable and reachable over HTTPS; OAuth provider scopes match current web usage. Tokens can be stored in platform-secure storage without additional SSO constraints.
- **API parity:** The upstream `monochrome-music/monochrome` API contracts remain compatible; any divergences will be patched in adapters rather than altering backend schemas.
- **Minimum OS levels:** Android 8.1 (API 27+) for Media3/WorkManager support; iOS 16+ and macOS 13+ for SwiftUI + ActivityKit; Windows 11 (22H2+) with Windows App SDK; Linux targets modern GTK4/libadwaita distributions with PipeWire.
- **Offline scope:** All catalog items previously accessed, user playlists/folders, favorites, pinned items, history, lyrics, and downloaded audio must be available offline. Streaming-only items show graceful degradation with cached metadata + retry prompts.
- **Design language:** Existing monochrome palette and theming rules in `THEME_GUIDE.md` apply to all native surfaces (widgets, notifications, mini-players).
- **CI/CD environment:** GitHub-hosted runners are permitted for Android/Linux/Windows/macOS/iOS jobs; signing is out-of-scope, so unsigned artifacts are acceptable.

If any assumption proves incorrect, update this file and adjust the implementation/sync contracts accordingly.
