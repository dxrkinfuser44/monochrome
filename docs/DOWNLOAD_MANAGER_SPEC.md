# Download Manager Specification

## Objectives
- Provide resumable, offline-first audio downloads with clear user feedback.
- Share a common state machine across all platforms.
- Respect network/battery constraints and storage limits.

## State machine
- `queued` → `downloading` → (`paused` | `complete` | `error`)
- `paused` → `queued`/`downloading` when resumed.
- `error` → `queued` after backoff or user retry.
- `canceled` removes local files and queue entry.

## Data persisted per item
- IDs (track/podcast/video), source URL, target file path, mime/type, total bytes, downloaded bytes, etag/hash, lastUpdated, retryCount, user preferences (Wi‑Fi only, quality).

## Platform execution
- **Android:** WorkManager foreground service with `MediaSessionService` notifications; scoped storage; chunked HTTP range requests; uses `ConnectivityManager` for network constraints.
- **iOS/macOS:** `BGProcessingTask` + `URLSession` background transfers; persists progress with `BGTaskScheduler`; integrates with Now Playing metadata.
- **Windows:** Background task with `HttpClient` + range requests; SMTC updates; stores files under `%LocalAppData%/Monochrome/downloads`.
- **Linux:** systemd/cron worker leveraging `gio`/`curl` with range support; publishes progress over DBus; MPRIS metadata updates.
- **Web/PWA:** service worker driven downloads when permitted; falls back to streaming with cache-as-you-go.

## Behaviors
- Concurrency: limit active downloads; prioritize current track + explicit user selections.
- Retry/backoff: exponential backoff on transient failures; stop on 4xx entitlement errors.
- Integrity: verify size/hash; discard partials on mismatch; resume with range headers when supported.
- User controls: pause/resume/cancel per item; clear all downloads; storage usage indicators; quality selection.
- Sync: download intents stored locally and synced; entitlement checked during sync; completed downloads stay local until user removal or storage pressure.
