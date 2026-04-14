# How Monochrome Works

This document explains the high-level architecture and runtime flow of Monochrome.

## Runtime model

Monochrome is a Vite-built single-page web app. The browser loads `index.html`, then the app bootstrap (`js/app.js`) initializes API clients, UI systems, player state, event wiring, and route handling.

## Core execution flow

1. **Bootstrap** (`js/app.js`)
    - Initializes global services (API, player, UI renderer, analytics, auth/sync integrations).
    - Registers service worker support and startup behaviors.
    - Hooks UI and playback events.
2. **Routing** (`js/router.js`)
    - Reads the current URL path.
    - Dispatches to page renderers (album, artist, track, playlist, library, etc).
    - Supports provider-aware route formats and deep links.
3. **Data fetch + transformation**
    - `js/music-api.js` and `js/HiFi.ts` fetch music/catalog data.
    - Utility modules normalize data for rendering and playback.
4. **Rendering** (`js/ui.js`)
    - Produces page UI and updates stateful panels, lists, and controls.
    - Coordinates with side panel, command palette, and interaction handlers.
5. **Playback engine** (`js/player.js`)
    - Manages queue, current track, play/pause/seek, repeat/shuffle, and media session integration.
    - Integrates with scrobbling, lyrics, downloads, and visualizers.
6. **Persistence**
    - `js/storage.js` handles settings/preferences.
    - `js/db.js` stores local/offline app data.

## Main subsystems

- **Player + media controls:** `js/player.js`, `js/events.js`, `js/audio-context.js`
- **UI + interactions:** `js/ui.js`, `js/ui-interactions.js`, `js/side-panel.js`, `js/commandPalette.js`
- **Routing/navigation:** `js/router.js`
- **API integrations:** `js/music-api.js`, `js/HiFi.ts`, `js/api.js`
- **Account/sync:** `js/accounts/*`
- **Metadata/download pipeline:** `js/downloads.js`, `js/ffmpeg.js`, `js/metadata*.js`, `js/taglib.ts`
- **Visualizers:** `js/visualizer.js`, `js/visualizers/*`
- **PWA/build tooling:** `vite.config.ts`, `public/manifest.json`

## Build and delivery

- Vite builds the SPA into `dist/`.
- PWA behavior is configured via `vite-plugin-pwa` in `vite.config.ts`.
- Production deploys are automated through repository workflows/platform integrations.

## Mobile packaging

The same web app is wrapped with Capacitor for native containers:

- Android project: `android/`
- iOS project: `ios/`

These wrappers package the built web assets and expose native platform capabilities used by the app.
