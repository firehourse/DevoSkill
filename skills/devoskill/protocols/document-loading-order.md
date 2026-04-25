# Document Loading Order Protocol

Use this protocol when deciding the default read surface for a phase.

## Planning
1. Relevant `architecture.md` sections
2. Relevant `study/*.md` only when the current existing-system plan needs reusable reality context
3. Existing active `task.md` only if rewriting
4. Existing `design.md` / `test.md` only when rewriting or reconciling a prior contract
5. `project-changelog.md` or notes only when directly required

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

## Quality
1. `design.md`
2. `test.md`
3. Active phase in `task.md`
4. `verification.md`
5. Relevant `architecture.md` sections only when required by a category

Do not load `study/`, `project-changelog.md`, notes, old phases, or abandoned plans unless the current step explicitly needs them.
