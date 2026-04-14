# Implementation Plan

## Phase 1 — Discovery (complete in this repo)
- Document current architecture, data models, dependencies, and assumptions.
- Baseline lint/test/build to capture existing issues and build health.

## Phase 2 — Shared core extraction
- Define shared schemas mirroring `js/db.js` collections (favorites, history, playlists, pinned, settings, downloads).
- Create platform-agnostic sync contracts (operations, change tokens, conflict rules).
- Factor shared utilities (lyrics parsing, visualization presets, metadata normalization) into a reusable library package.
- Establish service worker parity for the web/PWA while preparing native cache boundaries.

## Phase 3 — Offline cache + download manager
- Implement storage adapters:
  - Android: Room + SQLCipher optional, artwork/audio disk caches, WorkManager for eviction.
  - iOS/macOS: SwiftData/CoreData + on-disk artwork/audio caches; BackgroundTasks for maintenance.
  - Windows: SQLite/WinRT + background tasks; Linux: SQLite + systemd/cron equivalents.
- Implement download state machine (`queued/downloading/paused/complete/error`) with resumable transfers and backoff.
- Wire cache reads before network fetch; prime caches on first use; add cache hit metrics.

## Phase 4 — Native UI + media integration
- Android: Jetpack Compose app with `MediaSessionService`, notifications, Android Auto, Glance widgets.
- iOS: SwiftUI app with `AVQueuePlayer`, Now Playing/RemoteCommandCenter, Live Activities, CarPlay intents.
- macOS: SwiftUI + AppKit menubar mini-player using `NSStatusItem`, Liquid Glass effects.
- Windows: WinUI 3 desktop app with SMTC and AudioGraph; Linux: GTK4/libadwaita UI with MPRIS2.
- Map monochrome theme tokens to platform theming systems; ensure offline navigation flows.

## Phase 5 — Sync + conflict resolution
- Implement background sync workers per platform with exponential backoff and connectivity awareness.
- Apply last-write-wins with merge rules for playlists/history; dedupe by IDs and timestamps.
- Add telemetry hooks for sync health and cache hit rates (logged locally, uploaded when online).

## Phase 6 — CI/CD + artifacts
- GitHub Actions matrix (android/linux/windows/macos/ios) to install dependencies, run shared web build, then invoke platform builds.
- Upload unsigned artifacts (`.apk/.aab`, `.ipa`, `.app/.dmg`, `.msix/.exe`, `.AppImage/.deb`) named with commit SHA.
- Enable caching keyed by lockfiles; run lint/test/build for shared code where feasible.

## Phase 7 — Hardening
- Add security controls (pinning, secure storage, secret scanning) and performance budgets (cold start, memory, battery).
- Expand test coverage: unit tests for cache/sync/download state machines; integration tests per platform; headless web tests.
- Final verification of offline-first behavior and graceful degradation on older OS versions.
