# Document Authority Protocol

Use this protocol when a phase needs to know which document is allowed to claim what.

## Authority Rules
- Chat is not durable project state.
- `architecture.md` owns effective architecture and stable boundaries.
- `task.md` owns only the active executable phase.
- `design.md` owns the execution-facing design contract for the current feature or phase.
- `verification.md` owns durable verification evidence and reconciliation notes.
- `notes/` owns non-default history and abandoned context.

If these documents disagree, stop and reconcile instead of guessing.
