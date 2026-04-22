# Document Authority Protocol

Use this protocol when a phase needs to know which document is allowed to claim what.

## Authority Rules
- Chat is not durable project state.
- `architecture.md` owns effective architecture and stable boundaries.
- `task.md` owns only the active executable phase.
- `design.md` owns the execution-facing design contract for the current feature or phase.
- `test.md` owns the execution-facing testing contract derived from `design.md`.
- `verification.md` owns durable verification evidence and reconciliation notes.
- Project-root `project-changelog.md` owns non-default decision rationale and change timeline for the project.
- Feature-level `notes/` owns abandoned context and local background that is not needed in the default load surface.
- Planning files should keep only the effective decision and link to `project-changelog.md` for historical rationale when needed.

If these documents disagree, stop and reconcile instead of guessing.
