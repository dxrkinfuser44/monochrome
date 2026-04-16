# Performance

## Targets
| Metric | Target |
| --- | --- |
| Cold start | < 2s on mid-range devices |
| Memory | Stay within platform app memory class; avoid leaks |
| Battery | Minimal background impact during playback/downloads |
| Cache hit rate | >80% for artwork; high reuse for metadata |
| Audio underruns | Near zero during playback |

## Strategies
- **Startup:** lazy-load non-critical modules, prefetch last session state, defer network until after initial paint; on native, use splash-free launch with cached home screen data.
- **Rendering:** Compose/SwiftUI/WinUI/GTK4 components fed by memoized view models; avoid unnecessary recompositions.
- **Playback:** Pre-buffer next track; use platform media pipelines for hardware acceleration; throttle visualizers when backgrounded.
- **Downloads:** Parallelism tuned per network type; resume with range requests; pause on battery saver/roaming.
- **Caching:** Size-based eviction; gzip/ Brotli where applicable; reuse artwork across views; service worker prefetch for PWA parity.
- **Metrics:** Collect cold start timings, memory snapshots, battery impact, cache hit/miss, and underrun counts; store locally and surface in diagnostics; export to CI artifacts for regression tracking.

## Validation
- Automated headless web tests (`npm run test:headless`) and lint/build gates.
- Platform profiling: Android Studio profiler, Xcode Instruments, Windows Performance Analyzer, Linux perf stack; measure before/after optimizations.
- Performance budgets enforced in CI once native builds are wired (fail on regressions).
