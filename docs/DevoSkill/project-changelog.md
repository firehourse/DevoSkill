# DevoSkill Project Changelog

This file records project-level feature/change timestamp rows and rationale.
Read it only when a task or review needs to understand why existing behavior or structure is the way it is.

## Entries

### Project Changelog Artifact - 2026-04-22 08:37 UTC
- Reason: The SkillDocs layout needed a simple durable place to record why decisions and changes happened without putting that timeline into `architecture.md`, `task.md`, or chat.
- Decision: Add one project-root `project-changelog.md` under `docs/<project>/`. Keep it out of the default load surface. During review or maintenance, load it only when change rationale is needed.
- Changed: Updated document authority, persistence, loading order, workspace layout, templates, doctrine, architecture, and the active task writeback.
- Follow-up: Planning files should link to the relevant changelog entry instead of carrying long rationale. If one file becomes too large, promote `project-changelog.md` into a changelog folder with the same non-default loading rule.
