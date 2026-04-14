# Agent Skills for Monochrome

Use these reusable skill definitions to keep agent tasks consistent.

## Skill catalog

### 1) `repo-map`

**Goal:** Quickly identify where a feature lives before editing.  
**Use when:** Starting any non-trivial change.

**Checklist**
- Locate entry points and ownership files.
- List affected modules and tests.
- Confirm related docs that must be updated.

### 2) `safe-change`

**Goal:** Implement minimal, scoped edits with low regression risk.  
**Use when:** Editing app logic, routing, player, or UI state.

**Checklist**
- Change only task-relevant files.
- Preserve existing APIs/contracts unless explicitly requested.
- Keep diffs understandable and reversible.

### 3) `validate-change`

**Goal:** Ensure quality before finalizing.  
**Use when:** Any code or config changes are made.

**Checklist**
- Run lint/test/build scripts already provided by the repo.
- Confirm no new security risks in changed code paths.
- Summarize what was validated and any known unrelated failures.

### 4) `docs-sync`

**Goal:** Keep documentation aligned with behavior.  
**Use when:** Commands, architecture, workflows, or contributor steps change.

**Checklist**
- Update docs hub/index links.
- Update affected usage/setup instructions.
- Ensure new docs are discoverable from `README.md`.

## Suggested usage order

`repo-map` → `safe-change` → `validate-change` → `docs-sync`
