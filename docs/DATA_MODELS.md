# Data Models

This document captures the current Monochrome data shapes and how they will map into native persistence layers.

## IndexedDB stores (web baseline)
- **favorites_tracks / favorites_videos** (`keyPath: id`): `id`, `title`, `duration`, `explicit`, `artist`, `artists[] {id,name}`, `album {id,title,cover,releaseDate,vibrantColor,artist,numberOfTracks,mediaMetadata.tags}`, `copyright`, `isrc`, `trackNumber`, `streamStartDate`, `version`, `mixes`, `isTracker`, `trackerInfo`, `isPodcast`, `enclosureUrl`, `enclosureType`, `enclosureLength`, `audioUrl`, `remoteUrl`, `audioQuality`, `mediaMetadata.tags`, `addedAt`.
- **favorites_albums** (`keyPath: id`): `id`, `title`, `cover`, `releaseDate`, `explicit`, `artist {id,name}`, `type`, `numberOfTracks`, `addedAt`.
- **favorites_artists** (`keyPath: id`): `id`, `name`, `picture`, `addedAt`.
- **favorites_playlists** (`keyPath: uuid`): `uuid`, `title`, `image`, `numberOfTracks`, `user {name}`, `addedAt`.
- **favorites_mixes** (`keyPath: id`): `id`, `title`, `subTitle`, `description`, `mixType`, `cover`, `addedAt`.
- **history_tracks** (`keyPath: timestamp`): minified track payload + `timestamp` (monotonic) capturing play history.
- **user_playlists** (`keyPath: id`): playlist metadata plus `tracks[]` minified track entries; `createdAt`.
- **user_folders** (`keyPath: id`): folder metadata with `createdAt`.
- **settings**: arbitrary key/value settings.
- **pinned_items** (`keyPath: id`): `{id,type,name,cover,images?,href,pinnedAt}` capped at three items.

## Runtime models
- **Player queue items:** align with track/video minified shape plus playback-specific fields (`audioUrl`, `remoteUrl`, `audioQuality`, `streamStartDate`, `isPodcast`, `enclosure*`).
- **Downloads:** queue items store source URL, target path, bytes downloaded, total bytes, mime/type, and state (`queued`, `downloading`, `paused`, `complete`, `error`), with progress callbacks feeding UI and cache updates.
- **Search/catalog entities:** `track`, `album`, `artist`, `playlist`, `mix` share IDs/titles/artwork and normalized artist/album references for cross-provider rendering.

## Native mapping plan
- **SQLite/Room/SwiftData/WinRT/Libadwaita:** mirror the IndexedDB collections as normalized tables with foreign keys (`Track`, `Album`, `Artist`, `Playlist`, `PlaylistTrack`, `History`, `PinnedItem`, `Setting`, `Download`).
- **Serialization:** Maintain field names for cross-platform sync; keep `addedAt`/`timestamp` for conflict resolution.
- **Portability:** Shared schemas live in a platform-agnostic layer so cache + sync logic remains consistent across Android, iOS, macOS, Windows, Linux, and the web/PWA.
