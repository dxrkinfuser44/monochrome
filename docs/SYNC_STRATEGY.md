# Sync Strategy

## Principles
- Offline-first: all user actions commit locally and sync later.
- Deterministic merges: timestamped records with last-write-wins plus smart merges for ordered collections.
- Idempotent operations: retriable requests with stable IDs and change tokens.

## Scope
- Collections: favorites (tracks/videos/albums/artists/playlists/mixes), history, playlists/folders, pinned items, downloads (state + progress), settings.
- Platforms: Android (WorkManager), iOS/macOS (BGProcessingTask), Windows (background tasks), Linux (systemd/cron), web (service worker background sync).

## Change tracking
- Each collection maintains `updatedAt`/`timestamp` and a locally incremented `syncToken`.
- Sync requests include `sinceToken`; server responds with deltas and a new token.
- Conflict handling:
  - **Favorites/pins/settings:** last-write-wins by `updatedAt`.
  - **History:** append-only; dedupe by track ID + day.
  - **Playlists/folders:** merge track orders by comparing `updatedAt` on items; if divergence, prefer server order but append local additions at tail.
  - **Downloads:** server is authoritative for entitlement; client owns byte progress and resumes or evicts on denial.

## Transport + retries
- Exponential backoff with jitter, capped retries, and circuit breaking on repeated auth/network failures.
- Connectivity awareness: defer large downloads on cellular/roaming unless user opts in; pause on battery saver.
- Batches operations per collection to minimize API calls; compress payloads when large.

## Observability
- Record sync attempts, successes/failures, conflict counts, and latency; expose a diagnostics screen and log summaries for CI artifacts.
- Surface user-visible status (e.g., “Offline changes pending”, “Synced just now”).

## Security
- Use platform-secure token storage; refresh tokens prior to sync; reject if TLS validation fails.
- Avoid logging sensitive payloads; redact tokens and PII in diagnostics.
