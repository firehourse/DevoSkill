# Planning Artifacts Workflow

Use this step when generating or rewriting planning artifacts.

## Architecture
- Write only effective architecture and stable boundaries.
- Externalize allowed inputs, forbidden inputs, ownership boundaries, lifecycle rules, and required evidence.
- Existing-system changes write a feature-level `architecture.md` only when the change introduces meaningful new components, boundaries, or design decisions.
- New projects write the full system architecture at the project root.

## Task
- Write only the active executable phase.
- Include verification expectations, stop points, and forbidden shortcuts.
- Large changes must be phase-based instead of one monolithic checklist.

## Test
- Bootstrap `test.md` before implementation when the feature includes code changes.
- `test.md` derives from `design.md` and records the selected methodology: `TDD`, `BDD`, or `Follow Existing Project Pattern`.
- `test.md` must map class responsibilities, flows, and behavior contracts to planned test coverage.

## Verification
- Bootstrap `verification.md` before implementation when the feature includes code changes.
- `verification.md` is the durable home for executed checks, command outcomes, negative paths, artifact cleanup notes, and remaining gaps.
- `verification.md` does not own test design; it records executed evidence against `test.md`.
