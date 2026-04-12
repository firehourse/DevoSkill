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

## Verification
- Bootstrap `verification.md` before implementation when the feature includes code changes.
- `verification.md` is the durable home for executed checks, negative paths, artifact cleanup notes, and remaining gaps.
