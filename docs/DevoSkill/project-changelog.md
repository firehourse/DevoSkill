# DevoSkill Project Changelog

This file records project-level feature/change timestamp rows and rationale.
Read it only when a task or review needs to understand why existing behavior or structure is the way it is.

## Entries

### Study Surface - 2026-04-24 UTC
- Reason: Large existing systems need reusable code-reading and architecture study artifacts so Inquiry and Planning can recover current reality without repeatedly rediscovering the same flows.
- Decision: Add project-root `study/` as a non-default SkillDocs surface and add `study-surface.md` as the shared protocol for durable inquiry. Study is loaded selectively by Inquiry and Planning, not by Development, Review, Quality, or Debug by default.
- Changed: Added the Study Surface protocol and template, updated Inquiry/Planning load rules, and updated document authority, loading, persistence, reviewability, workspace layout, Development/Review guardrails, subagent context rules, architecture, doctrine, and active task writeback.
- Follow-up: Downstream project skills can reference their project-root `study/` folders as reusable reality sources, but should still promote only change-specific facts into feature planning docs.

### Project Changelog Artifact - 2026-04-22 08:37 UTC
- Reason: The SkillDocs layout needed a simple durable place to record why decisions and changes happened without putting that timeline into `architecture.md`, `task.md`, or chat.
- Decision: Add one project-root `project-changelog.md` under `docs/<project>/`. Keep it out of the default load surface. During review or maintenance, load it only when change rationale is needed.
- Changed: Updated document authority, persistence, loading order, workspace layout, templates, doctrine, architecture, and the active task writeback.
- Follow-up: Planning files should link to the relevant changelog entry instead of carrying long rationale. If one file becomes too large, promote `project-changelog.md` into a changelog folder with the same non-default loading rule.
