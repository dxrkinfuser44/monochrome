# Dependencies

## Web/runtime
- **Build/test:** Vite, Vitest (+ Playwright browser runner), ESLint, Stylelint, HTMLHint, Prettier, Bun/Node.js.
- **Playback + streaming:** `shaka-player`, `hls.js`, `@ffmpeg/*`, `@capgo/capacitor-media-session`, Web Audio helpers in `js/audio-context.js`.
- **Data + APIs:** `pocketbase`, `appwrite`, `@svta/common-media-library`, `fuse.js` (search), `uuid`, `eventemitter3`.
- **UI/assets:** `lucide-static` icons, `simple-icons`, `svgo`, theme guidance in `THEME_GUIDE.md`.
- **PWA:** `vite-plugin-pwa`, service worker generated at build.

## Mobile/native (target stacks)
- **Android:** Kotlin, Jetpack Compose, Media3/ExoPlayer, Room, WorkManager, `MediaSessionService`, Android Auto (MediaLibraryService), Glance widgets, Keystore/EncryptedSharedPreferences.
- **iOS:** Swift + SwiftUI, `AVFoundation`/`AVAudioSession`, `MPNowPlayingInfoCenter`, BackgroundTasks (`BGProcessingTask`), CoreSpotlight, ActivityKit (Live Activities), Keychain.
- **macOS:** SwiftUI + AppKit interop, `NSVisualEffectView`, menu bar mini-player (`NSStatusItem`), Keychain + sandboxed storage.
- **Windows:** WinUI 3 with Windows App SDK, `SystemMediaTransportControls`, WASAPI/AudioGraph, Credential Manager.
- **Linux:** GTK4/libadwaita, GStreamer (PipeWire sink), MPRIS2, libsecret/kwallet.

## Build/automation
- **CI:** GitHub Actions with bun install + shared web build, platform-specific setup (JDK 17, Xcode/macOS runners, Windows build tools, GTK/GStreamer).
- **Artifacts:** Platform build outputs or placeholders uploaded via `actions/upload-artifact`.

## Dependency hygiene
- Lockfiles: `bun.lock`/`bun.lockb` for JavaScript tooling; platform package managers manage native locks (Gradle, SwiftPM/CocoaPods, NuGet, APT).
- Security: HTTPS enforced, no committed secrets, certificate pinning where supported, periodic `npm audit`/`bun audit` + platform-specific audits (Gradle dependencies, `swift package show-dependencies`).
