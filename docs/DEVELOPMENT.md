# Development Guide

This guide is for contributors who want to work on Monochrome locally.

## Tech stack

- **Runtime/Tooling:** Bun or Node.js + npm
- **App framework:** Vite (PWA-enabled single-page app)
- **Primary source:** `js/` (JavaScript + TypeScript modules)
- **Styling:** `styles.css` + static assets in `public/` and `images/`
- **Mobile wrappers:** Capacitor projects in `android/` and `ios/`

## Local setup

1. Install prerequisites:
    - Node.js (22+ recommended) and npm, or
    - Bun
2. Install dependencies:

    ```bash
    bun install
    # or
    npm install
    ```

3. Start the development server:

    ```bash
    bun run dev
    # or
    npm run dev
    ```

4. Open `http://localhost:5173/`.

## Common scripts

```bash
# Run all linters
npm run lint

# Run tests
npm run test

# Run tests in headless browser mode
npm run test:headless

# Build for production
npm run build

# Preview production build locally
npm run preview
```

> Equivalent `bun run <script>` commands are supported.

## Project layout

```text
monochrome/
├── js/                    # Core app logic, player, API, UI, routing, tests
│   ├── accounts/          # Auth + account sync integrations
│   ├── tests/             # Test suites
│   └── visualizers/       # Audio visualizer implementations
├── functions/             # Route-level serverless handlers/pages
├── public/                # Static files copied to build output
├── images/                # Source image assets used in UI/build
├── android/               # Capacitor Android project
├── ios/                   # Capacitor iOS project
├── index.html             # Main HTML shell
├── styles.css             # Global styles
└── vite.config.ts         # Build, test, PWA, and plugin configuration
```

## Architecture overview

- `js/app.js` is the main bootstrap and orchestration entry point.
- `js/router.js` resolves URL paths and dispatches page rendering.
- `js/ui.js` contains rendering/UI behavior for app pages and components.
- `js/player.js` controls playback state, queue flow, and media interactions.
- `js/music-api.js` and `js/HiFi.ts` handle API communication and client-level behaviors.
- `js/storage.js` and `js/db.js` persist settings and local app data.
- `js/events.js` and `js/ui-interactions.js` wire user interactions to behavior.

## Related docs

- [Contributing Guide](../CONTRIBUTING.md)
- [Docker Guide](../DOCKER.md)
- [Theme Guide](../THEME_GUIDE.md)
