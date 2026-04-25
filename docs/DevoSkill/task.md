# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 8`
- Goal: Add project-root `study/` and Study Surface rules for reusable code-reading, architecture, domain, and workflow understanding.
- Depends on architecture sections: `Approved Target Shape`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-04-24 added Study Surface protocol, document rules, template, and project writeback`
- User inputs still required: `None`
- Current blocker: `None`
- Next user handoff: `Review Study Surface semantics`
- Stop and ask the user if: `Study should become a primary route instead of an Inquiry/Planning support surface`

## 2. Setup and Preconditions
- [x] Phase 6 (Update route + skill evolution) completed
- [x] Phase 7 (project changelog surface) completed
- [x] User confirmed the changelog mechanism should stay simple and timestamp-oriented
- [x] User confirmed Study should primarily serve Inquiry and Planning, using downstream project `study/` folders as the model

## 3. Execution Tasks

### 3.4 Study surface protocol
- Scope: Define Study as durable inquiry for reusable system understanding, not implementation planning.
- Files: `skills/devoskill/protocols/study-surface.md`, `skills/devoskill-exception/SKILL.md`, `skills/devoskill-planning/SKILL.md`, `skills/devoskill/workflows/planning-context-bootstrap.md`

- [x] **Task 3.4.1**
  - Action: Add Study load conditions, authority, discovery behavior, persistence rules, and forbidden uses.
  - Verification: Inquiry and Planning can load Study selectively; Development, Review, Quality, and Debug do not load it by default.

### 3.5 Document system, execution guardrails, and templates
- Scope: Add project-root `study/` to SkillDocs ownership, layout, loading, persistence, and template storage.
- Files: `skills/devoskill/protocols/document-authority.md`, `skills/devoskill/protocols/document-loading-order.md`, `skills/devoskill/protocols/document-persistence.md`, `skills/devoskill/protocols/document-reviewability.md`, `skills/devoskill/protocols/workspace-layout.md`, `skills/devoskill/protocols/subagent-orchestration.md`, `skills/devoskill/workflows/02-development.md`, `skills/devoskill/workflows/03-review.md`, `skills/devoskill/templates/README.md`, `skills/devoskill/templates/task.md`, `skills/devoskill/templates/study.md`

- [x] **Task 3.5.1**
  - Action: Add Study as a non-default project-root artifact surface.
  - Verification: Study is loaded selectively by Inquiry/Planning and remains outside default execution context.

### 3.6 DevoSkill project writeback
- Scope: Update DevoSkill durable docs to describe the new Study Surface.
- Files: `docs/DevoSkill/architecture.md`, `docs/DevoSkill/doctrine.md`, `docs/DevoSkill/task.md`, `docs/DevoSkill/project-changelog.md`

- [x] **Task 3.6.1**
  - Action: Record Phase 8 architecture/doctrine/task/changelog updates.
  - Verification: DevoSkill docs explain Study as reusable system understanding separate from Planning, Development, and Verification.

## 4. Human Handoff Points
- [ ] Human reviews whether Study should remain a support surface instead of becoming a primary route

## 5. Out of Scope for This Phase
- Making Study a primary router mode
- Loading `study/` by default in Development, Review, Quality, or Debug/Performance
- Moving feature-specific task planning, verification evidence, or raw search logs into `study/`
- Rewriting downstream project study files in this phase

## 6. Completion Criteria for This Phase
- [x] Project layout includes non-default `study/`
- [x] Study authority and persistence rules are explicit
- [x] Inquiry and Planning can load Study selectively
- [x] Development, Review, Quality, and Debug do not load Study by default
- [x] Minimal Study template exists
- [x] DevoSkill project docs written back
