# [Project/Feature Name] Active Task Plan

This document contains only the currently active executable work. It is the source of truth for the Developer subagent during the current phase.

## Global Constraints Reminder
- Keep effective planning markdown files under 600 lines each. Split phases or move history into `notes/` if necessary.
- Python projects: follow `templates/design-python.md`.
- If `architecture.md` and `task.md` disagree, stop and return to planning.
- Do not load history or abandoned plans unless the user explicitly asks for them.
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
- Planning reality last reconciled at:

## 2. Setup and Preconditions
- [ ] `.devoskill` symlink verified if required
- [ ] Required schema / contract / sample payload from user collected
- [ ] Existing pattern decision confirmed: `[Follow Existing Patterns | Adopt New Patterns]`
- [ ] Environment prerequisites confirmed
- [ ] Explicit implementation go-ahead recorded from the user
- [ ] Writeback expectations for `task.md` / `architecture.md` confirmed
- [ ] Behavior contract extracted from `architecture.md` / `design.md`
- [ ] Authorization / ownership boundaries identified
- [ ] Verification artifact expectations confirmed
- [ ] Runtime artifact hygiene expectations confirmed
- [ ] `verification.md` bootstrapped and linked from the active phase summary

## 3. Execution Tasks

### 3.1 [Task Group / Component]
- Scope:
- Files / modules:
- Constraints:
- Behavior contract entries covered:

- [ ] **Task 3.1.1**
  - Target:
  - Action:
  - Expected output:
  - Verification:
  - Durable evidence:
  - Status / writeback note:

- [ ] **Task 3.1.2**
  - Target:
  - Action:
  - Expected output:
  - Verification:
  - Durable evidence:
  - Status / writeback note:

### 3.2 [Task Group / Component]
- Scope:
- Files / modules:
- Constraints:
- Behavior contract entries covered:

- [ ] **Task 3.2.1**
  - Target:
  - Action:
  - Expected output:
  - Verification:
  - Durable evidence:
  - Status / writeback note:

## 4. Verification Contract
- Required runtime checks:
- Required ownership / authorization checks:
- Required negative-path checks:
- Evidence that later review must be able to inspect in `verification.md`:

## 5. Planning Reality Reconciliation
- [ ] `architecture.md`, `task.md`, `design.md`, and actual file tree agree on active scope
- [ ] Delivered artifacts exist only in approved locations
- [ ] Verification claims are backed by evidence
- [ ] `verification.md` reflects the latest executed checks and remaining gaps
- [ ] Remaining drift is either fixed or explicitly handed back to planning

## 6. Human Handoff Points
List any steps the agent must not guess through.

- [ ] Human provides schema / contract / credentials / sample data
- [ ] Human approves implementation start
- [ ] Human approves boundary change
- [ ] Human executes sensitive environment step

## 7. Forbidden Shortcuts
- Do not mark a task "verified" without durable evidence or a directly inspectable surface.
- Do not treat `task.md` as the storage location for raw verification output; write the proof to `verification.md` and summarize it here.
- Do not leave build output, dependency directories, uploads, or generated artifacts in tracked source paths unless the contract explicitly allows them.
- Do not assume CRUD authorization automatically covers streams, replay, or cancel flows.
- Do not reconcile planning drift in chat only; update the documents.

## 8. Out of Scope for This Phase
- [Item]
- [Item]

## 9. Completion Criteria for This Phase
- [ ] All tasks in the active phase are completed
- [ ] Effective planning markdown files remain under 600 lines
- [ ] Work matches the active architecture sections
- [ ] `task.md` writeback reflects actual execution status and verification
- [ ] `architecture.md` is updated if implementation changed effective architecture
- [ ] Verification artifacts and evidence surface are complete
- [ ] Planning reality reconciliation is complete
- [ ] No runtime-generated artifacts remain in tracked implementation paths unless explicitly approved
- [ ] Remaining work is either moved to the next phase or handed back to the user
