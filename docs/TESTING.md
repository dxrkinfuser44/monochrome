# Testing and Validation Guide

Use this guide to validate changes before opening or updating a pull request.

## Toolchain

- **Linting:** ESLint, Stylelint, HTMLHint
- **Formatting:** Prettier
- **Tests:** Vitest (+ Playwright browser provider)
- **Build:** Vite

## Local validation commands

```bash
# install deps first
bun install
# or npm install

# all linters
npm run lint

# tests
npm run test

# headless browser tests (CI-like)
npm run test:headless

# production build
npm run build
```

> `bun run <script>` equivalents are also supported.

## CI workflows (repository)

- `lint.yml` — linting + formatting checks/fixes workflow
- `tests.yml` — Playwright-backed Vitest test run
- `lighthouse.yml` — Lighthouse-related checks
- `copilot-setup-steps.yml` — pre-configuration for Copilot cloud agent sessions

## Recommended validation order

1. Run linters.
2. Run tests (headless when possible).
3. Run build.
4. Re-run targeted checks after large refactors.

## Notes

- Some existing branches may contain unrelated lint failures; focus on ensuring your changed areas remain valid.
- For docs-only changes, a full runtime validation is optional unless docs describe executable configuration you changed.
