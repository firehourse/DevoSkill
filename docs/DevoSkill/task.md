# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 2`
- Goal: Add a minimal trigger-testing skeleton that validates DevoSkill's short-prompt routing without creating a heavyweight harness.
- Depends on architecture sections: `Current Reality`, `Approved Target Shape`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-03-19 aligned router and planning so all planning uses user-grilling by default`
- User inputs still required: `None for this slice`
- Current blocker: `None`
- Next user handoff: `Review the first optimization slice`
- Stop and ask the user if: `A broader DevoSkill restructuring is needed beyond this slice`

## 2. Setup and Preconditions
- [x] Local skilldocs mapping established
- [x] Improvement scope narrowed to a first slice
- [x] Explicit user approval to modify the DevoSkill project received

## 3. Execution Tasks

### 3.1 Trigger and interaction improvements
- Scope: Completed first optimization slice for skill discoverability, natural-language routing, and planning-time interrogation.
- Files / modules: `skills/devoskill/SKILL.md`, `skills/devoskill-planning/SKILL.md`, `skills/devoskill/workflows/01-planning.md`, `skills/devoskill-grill/SKILL.md`, `README.md`
- Constraints: Preserve the existing router model and keep instructions concise.

- [x] **Task 3.1.1**
  - Target: `skills/devoskill/SKILL.md`
  - Action: Strengthen trigger wording and mention the new grill path.
  - Expected output: Better routing cues without expanding the entrypoint too much.
  - Verification: File remains concise and aligned with the sibling-skill structure.
  - Status / writeback note: `Completed by adding trigger-oriented description, natural-language routing rules, quick start, and grill route.`

- [x] **Task 3.1.2**
  - Target: `skills/devoskill-grill/SKILL.md`
  - Action: Create a new short, high-interaction skill for interrogating plans and designs.
  - Expected output: A compact skill that asks one high-value question at a time and inspects the codebase when possible.
  - Verification: Instructions are short, specific, and triggerable.
  - Status / writeback note: `Completed as a compact support module used inside planning rather than a standalone router destination.`

- [x] **Task 3.1.3**
  - Target: `README.md`
  - Action: Document the new capability and the productized positioning improvements.
  - Expected output: README surfaces the new skill and clearer usage guidance.
  - Verification: README language matches the implemented structure.
  - Status / writeback note: `Completed by documenting rapid interrogation mode and the productization direction.`

### 3.2 Lightweight trigger-testing
- Scope: Add a minimal test harness for short prompt routing.
- Files / modules: `tests/skill-triggering/run-test.sh`, `tests/skill-triggering/prompts/*`, `tests/README.md`, `README.md`
- Constraints: Keep test assets small, avoid broad harness coupling, and optimize for short prompts.

- [x] **Task 3.2.1**
  - Target: `tests/skill-triggering/run-test.sh`
  - Action: Add a minimal runner inspired by superpowers but scoped to one test at a time.
  - Expected output: A tiny script that runs a prompt and reports whether the expected skill triggered.
  - Verification: Script remains concise and documents its required environment.
  - Status / writeback note: `Completed with a minimal Claude-compatible runner and bash syntax verification.`

- [x] **Task 3.2.2**
  - Target: `tests/skill-triggering/prompts/`
  - Action: Add a few very short prompt fixtures for DevoSkill routing.
  - Expected output: Prompts cover planning and grill behavior with minimal wording.
  - Verification: Prompt files are concise and focused on trigger semantics.
  - Status / writeback note: `Completed with concise planning and grill prompt fixtures.`

- [x] **Task 3.2.3**
  - Target: `tests/README.md`, `README.md`
  - Action: Document the lightweight testing principle and how to run one trigger test at a time.
  - Expected output: Clear guidance that testing should not expand the default context surface.
  - Verification: Documentation matches the small harness actually present in the repo.
  - Status / writeback note: `Completed with low-context testing guidance in repository docs.`

## 4. Human Handoff Points
- [ ] Human decides whether to proceed into a broader second slice after reviewing this one

## 5. Out of Scope for This Phase
- Full multi-agent test matrix
- Additional task templates beyond this slice
- Broad workflow rewrites

## 6. Completion Criteria for This Phase
- [x] Lightweight trigger runner exists
- [x] Minimal prompt fixtures exist
- [x] README documents low-context testing guidance
- [x] Planning files reflect actual work state
