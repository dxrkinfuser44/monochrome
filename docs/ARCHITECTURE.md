# Monochrome Native & Offline Architecture

## Current state (web + Capacitor)
- **App shell:** Vite-built SPA (`index.html`) bootstrapped by `js/app.js`; routing in `js/router.js`.
- **Playback stack:** `js/player.js`, `js/events.js`, `js/audio-context.js`, `js/ffmpeg.js`, visualizers in `js/visualizer.js` and `js/visualizers/*`.
- **Data + API:** Catalog and playback metadata via `js/music-api.js`, `js/HiFi.ts`, `js/api.js`; auth/sync via `js/accounts/*`.
- **Persistence:** IndexedDB wrapper in `js/db.js` for history, favorites, playlists, pinned items, settings; `js/storage.js` for simple key/value settings; service worker and PWA setup in `vite.config.ts`.
- **Mobile packaging today:** Capacitor containers in `android/` and `ios/` ship the web bundle with limited native hooks.

## Target architecture (native, offline-first)
- **Shared domain + sync layer:** A platform-neutral core that owns catalog models, download queue, conflict resolution, and playback/session state. Persistence uses SQLite/Room on Android, SwiftData/CoreData on Apple platforms, SQLite/WinRT storage on Windows, and SQLite/Libadwaita on Linux. The same logical schema mirrors the current IndexedDB shapes (favorites, history, playlists, pinned items, settings, downloads).
- **Media engine per platform:**
  - Android: Media3/ExoPlayer + `MediaSessionService` for background + Android Auto.
  - iOS/macOS: `AVQueuePlayer` + `AVAudioSession`, `MPNowPlayingInfoCenter`, Live Activities/CarPlay.
  - Windows: WinUI 3 + `SystemMediaTransportControls`, WASAPI/AudioGraph.
  - Linux: GTK4/libadwaita + GStreamer with PipeWire + MPRIS2.
- **Offline-first cache path:** API responses → normalized models → persisted caches → UI/read models; artwork cached in memory + disk; audio cached in chunked downloads with resumable transfers; service worker remains for web/PWA parity.
- **Sync engine:** Background workers (WorkManager/BGProcessingTask/Task Scheduler/systemd units) reconcile offline mutations (favorites, playlists, history, downloads) with server APIs using per-collection change tokens and last-write-wins + merge strategies.
- **UI composition:** Native UI layers (Jetpack Compose, SwiftUI, WinUI, GTK4) consume the shared domain models and expose platform-native controls, notifications, widgets, and media controls while honoring the monochrome palette.

## Module boundaries
- **Platform modules:** `/android`, `/ios`, `/macos`, `/windows`, `/linux` house native projects, each consuming shared schemas and sync contracts.
- **Shared assets:** `public/`, `images/`, and theme constants from `THEME_GUIDE.md` are reused for monochrome theming; iconography piped through platform-specific asset pipelines.
- **Network + auth:** Appwrite/PocketBase clients live in a shared networking layer with pluggable adapters for platform HTTP stacks and secure token storage (Keystore/Keychain/Credential Manager/libsecret).
- **Download manager:** Unified state machine (`queued → downloading → paused → complete → error`) drives platform download services and surfaces progress to UI and media session metadata.

## Data flow (high level)
1. User intent (UI or deep link) resolves to a route and fetch plan.
2. Cache check (metadata/artwork/audio) satisfies requests offline when available.
3. If network is available, fetch via platform HTTP client, normalize to shared models, persist, then refresh UI.
4. Playback requests hand off to platform media engine; progress and metadata feed back into caches, history, and sync queues.
5. Background workers push local changes when connectivity returns and reconcile conflicts.

## Extensibility and parity
- Keep feature parity between web and native by defining shared contracts for queue semantics, playlists, search, and downloads.
- Expose bridge layers so existing web modules can be reused inside the native shells when appropriate (e.g., lyric parsing, visualization presets) while migrating critical paths (playback, downloads, storage) to native code for offline reliability.
