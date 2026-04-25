# Template Storage

This directory contains the effective planning templates used by DevoSkill.

- `architecture.md`: The current effective architecture only. It is for future execution sessions, not for storing long-form design history.
- `design.md`: The execution-facing implementation contract.
- `design-go.md`, `design-node.md`, `design-python.md`, `design-ruby.md`: Stack-specific design baselines. Use them together with the matching quality workflow so naming, lifecycle, and error-handling constraints are already explicit during planning.
- `test.md`: The execution-facing testing contract derived from `design.md`.
- `task.md`: The active executable plan for the current phase only. It should stay small, concrete, and directly actionable.
- `verification.md`: Durable evidence for runtime checks, negative-path checks, and reconciliation. This is where proof lives, not in chat.
- `project-changelog.md`: Project-level feature/change timestamp rows with rationale. It is read only when change rationale is needed.
- `study.md`: Template for files under project-root `study/`. Study files preserve reusable system understanding and are read selectively by Inquiry or Planning.

Do not turn these templates into archival logs. Project rationale belongs in `project-changelog.md`; feature-local abandoned context belongs in `notes/`.
