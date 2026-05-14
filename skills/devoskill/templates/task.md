# [Project/Feature Name] Active Task Plan

This document contains only the currently active executable work. It is the source of truth for the Developer subagent during the current phase.

## Global Constraints Reminder
- Keep DevoSkill markdown files (`architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, project-root `project-changelog.md`, loaded `study/*.md`, and `notes/*.md`) under 600 lines each. Split phases, move reusable understanding into `study/`, or move project-level rationale into `project-changelog.md` if necessary. This limit does not apply to implementation source files.
- Python projects: follow `templates/design-python.md`.
- If `architecture.md` and `task.md` disagree, stop and return to planning.
- Do not load `study/`, `project-changelog.md`, or abandoned plans unless the user explicitly asks for them or the task needs reusable context or change rationale.
- Do not store long rationale in this file. Link to the relevant `project-changelog.md` entry when historical context matters.
- Verification claims must point to durable evidence or directly inspectable repository state.

## 1. Active Phase Summary
- Current Phase: `[Part 1 | Part 2 | ...]`
- Goal:
- Depends on architecture sections:
- Implementation approval status: `[Planning only | Approved to implement]`
- Explicit go-ahead required before code changes: `[Yes | No]`
- Execution status: `[Not started | In progress | Blocked | Ready for review | Completed]`
- Last writeback timestamp / session note:
- User inputs still required:
- Current blocker:
- Next user handoff:
- Stop and ask the user if:
- Verification artifact location: `[feature-folder]/verification.md`
- Test contract location: `[feature-folder]/test.md`
- Planning reality last reconciled at:

## 2. Implementation Readiness Gate
- Active-phase decisions complete: `[Yes | No]`
- Implementation choice alternatives remaining: `[None | list blockers]`
- Blocking open questions: `[None | list blockers]`
- Required placeholders / TODO / TBD in active docs: `[None | list blockers]`
- Deferred decisions not part of active phase:
- Approval phrase/source:

If any required readiness value is not `Yes` or `None`, this task is Planning-only. Do not begin implementation.

## 3. Setup and Preconditions
- [ ] `.devoskill` symlink verified if required
- [ ] Required schema / contract / sample payload from user collected
- [ ] Existing pattern decision confirmed: `[Follow Existing Patterns | Adopt New Patterns]`
- [ ] Environment prerequisites confirmed
- [ ] Implementation Readiness Gate passed
- [ ] Explicit implementation go-ahead recorded from the user
- [ ] Writeback expectations for `task.md` / `architecture.md` confirmed
- [ ] Behavior contract extracted from `architecture.md` / `design.md`
- [ ] Test methodology and minimum coverage extracted from `test.md`
- [ ] Authorization / ownership boundaries identified
- [ ] Verification artifact expectations confirmed
- [ ] Runtime artifact hygiene expectations confirmed
- [ ] `test.md` bootstrapped and linked from the active phase summary
- [ ] `verification.md` bootstrapped and linked from the active phase summary

## 4. Execution Tasks

### 4.1 [Task Group / Component]
- Scope:
- Files / modules:
- Constraints:
- Behavior delta entries covered:
- Behavior contract entries covered:

- [ ] **Task 4.1.1**
  - Target:
  - Action:
  - Expected output:
  - Verification:
  - Durable evidence:
  - Status / writeback note:

- [ ] **Task 4.1.2**
  - Target:
  - Action:
  - Expected output:
  - Verification:
  - Durable evidence:
  - Status / writeback note:

### 4.2 [Task Group / Component]
- Scope:
- Files / modules:
- Constraints:
- Behavior delta entries covered:
- Behavior contract entries covered:

- [ ] **Task 4.2.1**
  - Target:
  - Action:
  - Expected output:
  - Verification:
  - Durable evidence:
  - Status / writeback note:

## 5. Verification Contract
- Required runtime checks:
- Required test suites / scenarios from `test.md`:
- Required behavior-delta evidence:
- Required ownership / authorization checks:
- Required negative-path checks:
- Evidence that later review must be able to inspect in `verification.md`:

## 6. Surgical Change Boundary
- Allowed files/modules:
- Allowed generated or runtime artifacts:
- Allowed cleanup caused by this change:
- Explicitly out-of-scope cleanup:
- Adjacent code that must not be touched:
- Dead code policy:
  - Pre-existing dead code:
  - Dead code created by this change:
- Diff review focus:
- Every planned changed hunk must trace to:
  - user request:
  - `architecture.md` section:
  - behavior-delta entry:
  - `design.md` section:
  - task item:
  - verification cleanup:

## 7. Planning Reality Reconciliation
- [ ] `architecture.md`, `task.md`, `design.md`, `test.md`, and actual file tree agree on active scope
- [ ] Implementation Readiness Gate still passes
- [ ] Delivered artifacts exist only in approved locations
- [ ] Verification claims are backed by evidence
- [ ] `test.md` still matches actual planned coverage and methodology
- [ ] `verification.md` reflects the latest executed checks and remaining gaps
- [ ] Remaining drift is either fixed or explicitly handed back to planning

## 8. Human Handoff Points
List any steps the agent must not guess through.

- [ ] Human provides schema / contract / credentials / sample data
- [ ] Human approves implementation start
- [ ] Human approves boundary change
- [ ] Human executes sensitive environment step

## 9. Forbidden Shortcuts
- Do not change files, hunks, comments, formatting, or dead code outside the surgical change boundary unless the user explicitly approves the expansion.
- Do not mark a task "verified" without durable evidence or a directly inspectable surface.
- Do not treat `task.md` as the storage location for raw verification output; write the proof to `verification.md` and summarize it here.
- Do not leave build output, dependency directories, uploads, or generated artifacts in tracked source paths unless the contract explicitly allows them.
- Do not assume CRUD authorization automatically covers streams, replay, or cancel flows.
- Do not reconcile planning drift in chat only; update the documents.
- Do not choose between active implementation alternatives during Development; return to Planning if the selected path is missing.

## 10. Out of Scope for This Phase
- [Item]
- [Item]

## 11. Completion Criteria for This Phase
- [ ] All tasks in the active phase are completed
- [ ] Effective DevoSkill markdown files remain under 600 lines
- [ ] Work matches the active architecture sections
- [ ] `task.md` writeback reflects actual execution status and verification
- [ ] `architecture.md` is updated if implementation changed effective architecture
- [ ] Verification artifacts and evidence surface are complete
- [ ] Planning reality reconciliation is complete
- [ ] Final diff contains only changes allowed by the surgical change boundary
- [ ] No runtime-generated artifacts remain in tracked implementation paths unless explicitly approved
- [ ] Remaining work is either moved to the next phase or handed back to the user
