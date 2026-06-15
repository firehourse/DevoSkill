# Document Loading Order Protocol

Use this protocol when deciding the default read surface for a phase.

## Planning
1. Relevant `architecture.md` sections
2. `study/registry.md` first, when present and the current existing-system plan may need reusable reality context
3. Relevant `study/*.md` selected from the registry or direct search
4. `protocols/change-review-packet.md` only when the change adds, changes, or removes observable behavior or agent workflow behavior
5. Existing active `task.md` only if rewriting
6. Existing `design.md` / `test.md` only when rewriting or reconciling a prior contract
7. `project-changelog.md` or notes only when directly required

## Development
1. `design.md`
2. `test.md`
3. Active phase in `task.md`
4. `verification.md`
5. Relevant `architecture.md` sections

## Review
1. Active phase in `task.md`
2. `design.md`
3. `test.md`
4. Relevant `architecture.md` sections
5. `verification.md`
6. `protocols/change-review-packet.md` only when the active planning surface contains `Behavior Delta` or change-packet closeout terms

## Quality
1. `design.md`
2. `test.md`
3. Active phase in `task.md`
4. `verification.md`
5. Relevant `architecture.md` sections only when required by a category

## Closeout
Invoked by Development (Step 8) at phase completion and optionally by Review (R8) as the final decoupled pass; runnable standalone. Load surface:
1. Active phase in `task.md` (completion + writeback state)
2. `verification.md` (evidence surface)
3. The final `git diff` (scope-bleed / architecture-drift re-verify)
4. Relevant `architecture.md` sections (drift check)
5. `project-changelog.md` only when behavior/boundary changed
6. `protocols/change-review-packet.md` only when the surface uses `Behavior Delta` / closeout terms

Registries are selectors, not default context. Read a registry before detailed files only when the active phase has already justified that surface.

Do not load `study/`, `project-changelog.md`, notes, old phases, abandoned plans, or `change-review-packet.md` unless the current step explicitly needs them.
