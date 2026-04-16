# Cache Architecture

## Goals
- Serve previously accessed content entirely offline.
- Keep caches consistent across platforms with shared schemas and eviction rules.
- Support conflict-free sync once connectivity returns.

## Layers
- **Metadata cache:** SQLite/Room/SwiftData/WinRT/Libadwaita tables mirroring `js/db.js` collections (favorites, history, playlists, pinned, settings). Indexed on IDs and timestamps for fast lookups and conflict resolution.
- **Artwork cache:** Memory LRU + disk cache per platform (Coil/Glide/Picasso on Android, `URLCache` + `NSCache` on Apple, WinRT `HttpClient` cache, GNOME thumbnailer-compatible cache on Linux). Cache keys are content hashes; eviction uses size- and age-based policies.
- **Audio cache:** Chunked, resumable downloads stored in platform-private app storage. Uses HTTP range requests and integrity checks (hash/length). Supports pause/resume and re-queuing failed segments.
- **Download queue:** Persistent state machine (`queued`, `downloading`, `paused`, `complete`, `error`) with retry/backoff and per-network constraints (Wi‑Fi only, battery saver).
- **Service worker (web/PWA):** Precache shell assets and background sync for metadata updates; aligns with native cache contract.

## Flows
1. **Read path:** UI requests → cache lookup (metadata + artwork + audio). If hit, return immediately; if miss and network available, fetch, normalize, persist, then serve.
2. **Write path:** User actions (favorite, playlist edit, pin, download) write to local caches and enqueue sync jobs; UI reflects local state instantly.
3. **Sync path:** Background workers drain queues when online, applying merge rules; failures back off and keep state persisted.
4. **Eviction:** Size budgets per cache; LRU for artwork/audio, TTL for transient metadata; downloads keep completed items until user deletes or storage pressure triggers prompts.

## Integrity + observability
- Store content hashes and sizes for audio/artwork; validate on resume.
- Record cache hit rate, eviction counts, download retries, and sync conflicts; surface metrics to diagnostics and CI artifacts.
- Use migrations to evolve schemas while preserving data (versioned databases; migrations scripted and idempotent).
