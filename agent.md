# Monochrome Agent Operating Guide

This file defines practical instructions for coding agents working in this repository.

## Mission

Deliver high-quality, minimal-risk changes quickly while preserving existing app behavior.

## Repository priorities

1. Do not break playback, routing, authentication, or queue behavior.
2. Keep changes small and scoped to the task.
3. Prefer existing project patterns over introducing new abstractions.
4. Update relevant docs whenever behavior, scripts, or workflows change.

## Working rules

- Read impacted files before editing.
- Reuse existing scripts in `package.json` for validation.
- Avoid adding dependencies unless required.
- Keep commits focused and reviewable.
- Do not edit unrelated code to “clean up” while implementing a task.

## Required validation

- Code changes: run lint + tests + build where practical.
- Docs-only changes: verify links/paths and ensure docs are consistent.

## Key entry points

- App bootstrap: `js/app.js`
- Routing: `js/router.js`
- UI rendering: `js/ui.js`
- Playback core: `js/player.js`
- API layer: `js/music-api.js`, `js/HiFi.ts`
- Build/test config: `vite.config.ts`, `package.json`

## Documentation map

- Docs hub: `docs/README.md`
- Development setup: `docs/DEVELOPMENT.md`
- Runtime architecture: `docs/HOW_IT_WORKS.md`
- Testing/validation: `docs/TESTING.md`
- Agent skills: `docs/AGENT_SKILLS.md`
- Agent hooks: `docs/AGENT_HOOKS.md`
