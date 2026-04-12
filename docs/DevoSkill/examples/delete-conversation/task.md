# Delete Conversation Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Part 1`
- Goal: implement delete-conversation behavior with matching design, test contract, and verification evidence
- Depends on architecture sections: `Success Criteria`, `Target Shape / To-Be`, `Key Flows`, `Constraints and Boundaries`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Ready for review`
- Last writeback timestamp / session note: `Example feature documents completed`
- User inputs still required: `None`
- Current blocker: `None`
- Next user handoff: `Review the design-test-verification chain`
- Stop and ask the user if: `delete behavior changes beyond owned hard delete`
- Verification artifact location: `docs/DevoSkill/examples/delete-conversation/verification.md`
- Test contract location: `docs/DevoSkill/examples/delete-conversation/test.md`
- Planning reality last reconciled at: `Example document set creation`

## 2. Setup and Preconditions
- [x] Behavior contract extracted from `architecture.md` / `design.md`
- [x] Test methodology and minimum coverage extracted from `test.md`
- [x] Authorization / ownership boundaries identified
- [x] `test.md` bootstrapped and linked from the active phase summary
- [x] `verification.md` bootstrapped and linked from the active phase summary

## 3. Execution Tasks

### 3.1 Delete endpoint
- Scope: add user-scoped delete endpoint across controller/service/repository
- Files / modules: `conversation.controller.ts`, `conversation.service.ts`, `conversation.repository.ts`
- Constraints: preserve layering and ownership predicate
- Behavior contract entries covered: owned delete, non-owned rejection, transactional cleanup

- [x] **Task 3.1.1**
  - Target: controller route wiring
  - Action: add delete endpoint and response mapping
  - Expected output: `DELETE /api/conversations/:id` enters service cleanly
  - Verification: integration and acceptance coverage planned in `test.md`
  - Durable evidence: `verification.md` test execution section
  - Status / writeback note: `Completed in example contract`

- [x] **Task 3.1.2**
  - Target: service + repository delete behavior
  - Action: add ownership-scoped transactional delete
  - Expected output: owner can delete, non-owner cannot
  - Verification: unit, integration, and acceptance coverage planned in `test.md`
  - Durable evidence: `verification.md` test execution section
  - Status / writeback note: `Completed in example contract`

## 4. Verification Contract
- Required runtime checks: successful delete removes parent and child rows
- Required test suites / scenarios from `test.md`: `DEL-001`, `DEL-002`, `DEL-003`, `DEL-004`
- Required ownership / authorization checks: non-owner cannot delete another user's conversation
- Required negative-path checks: missing conversation, non-owner attempt
- Evidence that later review must be able to inspect in `verification.md`: executed commands, scenario IDs, observed ownership enforcement

## 5. Planning Reality Reconciliation
- [x] `architecture.md`, `task.md`, `design.md`, `test.md`, and actual example file tree agree on active scope
- [x] Delivered artifacts exist only in approved locations
- [x] Verification claims are backed by evidence
- [x] `test.md` still matches actual planned coverage and methodology
- [x] `verification.md` reflects the latest executed checks and remaining gaps
- [x] Remaining drift is either fixed or explicitly handed back to planning
