# Document Authority Protocol

Use this protocol when a phase needs to know which document is allowed to claim what.

## Authority Rules
- Chat is not durable project state.
- `architecture.md` owns effective architecture and stable boundaries.
- Feature-level `architecture.md` owns the primary `Behavior Delta` skeleton when a change adds, changes, or removes observable behavior.
- `task.md` owns only the active executable phase.
- `design.md` owns the execution-facing design contract for the current feature or phase.
- `test.md` owns the execution-facing testing contract derived from `design.md`.
- `verification.md` owns durable verification evidence, behavior-delta evidence, and reconciliation notes.
- Project-root `study/` owns reusable system understanding, flow maps, domain studies, and code-reading guides that are useful beyond one feature.
- Project-root `project-changelog.md` owns non-default decision rationale and change timeline for the project.
- Feature-level `notes/` owns abandoned context and local background that is not needed in the default load surface.
- When a feature spans multiple repos or work streams, the ticket-root `architecture.md` is the only architecture authority; stream subfolders own only their own `task.md`/`test.md`/`verification.md` per `feature-streams.md`. Sibling twin feature folders for the same ticket are forbidden for new work.
- Workspace-level `docs/<topic>/` knowledge folders own cross-project reusable learning that is not bound to one repo (see `study-surface.md § Placement`).
- Planning files should keep only the effective decision and link to `project-changelog.md` for historical rationale when needed.
- `change-review-packet.md` owns change packet terminology, behavior-delta lifecycle semantics, and sync/archive meanings. Other protocols may reference it but must not restate it inline.

If these documents disagree, stop and reconcile instead of guessing.
