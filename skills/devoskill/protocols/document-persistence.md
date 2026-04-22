# Document Persistence Protocol

Use this protocol when deciding where project state should be written back.

## Persistence Rules
- Do not maintain project state through conversational summaries.
- Put architecture decisions in `architecture.md`.
- Put active execution state in `task.md`.
- Put execution-facing structure and runtime flow mapping in `design.md`.
- Put design-derived test strategy, methodology, and traceability in `test.md`.
- Put durable checks, command outcomes, and reconciliation notes in `verification.md`.
- Put project-level decision rationale and change timeline in project-root `project-changelog.md`.
- Put abandoned material or feature-local background in feature-level `notes/`.
- If a planning file starts explaining why an old decision exists, replace the long rationale with a short reference to the relevant `project-changelog.md` entry.

If a fact matters in later sessions and is not persisted to the right document, it is not durable state.
