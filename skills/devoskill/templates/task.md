# [Project/Feature Name] Active Task Plan

This document contains only the currently active executable work. It is the source of truth for the Developer subagent during the current phase.

## Global Constraints Reminder
- Keep effective planning markdown files under 600 lines each. Split phases or move history into `notes/` if necessary.
- Adhere to Python ecosystem rules (`uv`) if applicable.
- If `architecture.md` and `task.md` disagree, stop and return to planning.
- Do not load history or abandoned plans unless the user explicitly asks for them.

## 1. Active Phase Summary
- Current Phase: `[Part 1 | Part 2 | ...]`
- Goal:
- Depends on architecture sections:
- Implementation approval status: `[Planning only | Approved to implement]`
- Explicit go-ahead required before code changes: `[Yes | No]`
- User inputs still required:
- Stop and ask the user if:

## 2. Setup and Preconditions
- [ ] `.devoskill` symlink verified if required
- [ ] Required schema / contract / sample payload from user collected
- [ ] Existing pattern decision confirmed: `[Follow Existing Patterns | Adopt New Patterns]`
- [ ] Environment prerequisites confirmed
- [ ] Explicit implementation go-ahead recorded from the user

## 3. Execution Tasks

### 3.1 [Task Group / Component]
- Scope:
- Files / modules:
- Constraints:

- [ ] **Task 3.1.1**
  - Target:
  - Action:
  - Expected output:
  - Verification:

- [ ] **Task 3.1.2**
  - Target:
  - Action:
  - Expected output:
  - Verification:

### 3.2 [Task Group / Component]
- Scope:
- Files / modules:
- Constraints:

- [ ] **Task 3.2.1**
  - Target:
  - Action:
  - Expected output:
  - Verification:

## 4. Human Handoff Points
List any steps the agent must not guess through.

- [ ] Human provides schema / contract / credentials / sample data
- [ ] Human approves implementation start
- [ ] Human approves boundary change
- [ ] Human executes sensitive environment step

## 5. Out of Scope for This Phase
- [Item]
- [Item]

## 6. Completion Criteria for This Phase
- [ ] All tasks in the active phase are completed
- [ ] Effective planning markdown files remain under 600 lines
- [ ] Work matches the active architecture sections
- [ ] Remaining work is either moved to the next phase or handed back to the user
