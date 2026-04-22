# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 7`
- Goal: Add project-root `project-changelog.md` as the simple feature/change timestamp and rationale surface for SkillDocs projects.
- Depends on architecture sections: `Approved Target Shape`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-04-22 added project-root project-changelog.md semantics and template`
- User inputs still required: `None`
- Current blocker: `None`
- Next user handoff: `Review project-changelog.md semantics after implementation`
- Stop and ask the user if: `project-changelog should become a folder instead of one project-root file`

## 2. Setup and Preconditions
- [x] Phase 6 (Update route + skill evolution) completed
- [x] Architecture updated to include Phase 7 scope
- [x] User confirmed the changelog mechanism should stay simple and timestamp-oriented

## 3. Execution Tasks

### 3.1 Document authority and persistence
- Scope: Make project-root `project-changelog.md` the owner of feature/change timestamp rows and rationale.
- Files: `skills/devoskill/protocols/document-authority.md`, `skills/devoskill/protocols/document-persistence.md`, `skills/devoskill/protocols/document-loading-order.md`, `skills/devoskill/protocols/thinking-promotion.md`

- [x] **Task 3.1.1**
  - Action: Add `project-changelog.md` as a non-default project-level artifact and keep feature-level `notes/` for abandoned local context.
  - Verification: Default loading still excludes changelog rationale unless directly required.

### 3.2 Workspace layout and templates
- Scope: Make the expected SkillDocs layout and template storage include `project-changelog.md`.
- Files: `skills/devoskill/protocols/workspace-layout.md`, `skills/devoskill/templates/README.md`, `skills/devoskill/templates/project-changelog.md`

- [x] **Task 3.2.1**
  - Action: Add project-root `project-changelog.md` to the layout and create a minimal template.
  - Verification: Template records feature/change name, timestamp, reason, decision, changed surface, and follow-up.

### 3.3 Doctrine and project writeback
- Scope: Update DevoSkill's own durable docs and create the current project changelog file.
- Files: `docs/DevoSkill/doctrine.md`, `docs/DevoSkill/architecture.md`, `docs/DevoSkill/task.md`, `docs/DevoSkill/project-changelog.md`

- [x] **Task 3.3.1**
  - Action: Write back the Phase 7 decision and record the rationale in `project-changelog.md`.
  - Verification: `project-changelog.md` explains the rationale without replacing `verification.md` or `task.md`.

## 4. Human Handoff Points
- [ ] Human confirms one `project-changelog.md` file is enough, instead of a changelog folder

## 5. Out of Scope for This Phase
- A changelog directory with monthly or per-issue files
- Moving verification evidence into `project-changelog.md`
- Loading `project-changelog.md` by default in planning, development, review, or quality

## 6. Completion Criteria for This Phase
- [x] Project layout includes `project-changelog.md`
- [x] Document authority and persistence rules define what belongs in `project-changelog.md`
- [x] `project-changelog.md` remains outside the default load surface
- [x] Minimal project changelog template exists
- [x] DevoSkill project docs written back
