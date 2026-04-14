# Agent Hooks for Monochrome

These hooks define what an agent should do before and after major actions.

## Pre-task hook

Run before starting implementation.

### Actions

1. Read `agent.md` and `docs/README.md`.
2. Identify affected files/modules.
3. Confirm validation commands from `package.json`.
4. Create a short checklist plan.

## Pre-edit hook

Run before changing any file.

### Actions

1. Confirm the target file is necessary for the request.
2. Ensure no unrelated refactors are included.
3. Check for adjacent tests/docs that must be updated.

## Post-edit hook

Run immediately after edits.

### Actions

1. Review diff for scope control and accidental changes.
2. Update related docs for any behavior or workflow changes.
3. Ensure links/paths in docs are valid.

## Pre-submit hook

Run before final handoff.

### Actions

1. Run applicable validation (`lint`, `test`, `build`) or explain why skipped.
2. Summarize changed files and intent.
3. Call out unresolved issues or unrelated existing failures.

## Example hook template (agent-facing)

```text
HOOK: pre-task
- Read: agent.md, docs/README.md
- Map modules and risks
- Produce concise execution checklist
```

```text
HOOK: pre-submit
- Validate with repo scripts
- Confirm docs parity
- Provide final summary + known limitations
```
