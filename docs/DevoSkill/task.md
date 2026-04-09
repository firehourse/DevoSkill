# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 4`
- Goal: Front-load DevoSkill's bootstrap and mode-routing rules so the model sees path resolution and work-mode classification before detailed workflow prose.
- Depends on architecture sections: `Current Reality`, `Approved Target Shape`, `Boundaries`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-04-09 restructured DevoSkill around bootstrap-first and mode-first routing, and updated sibling skills to self-check phase instead of assuming static context`
- User inputs still required: `None for this slice`
- Current blocker: `None`
- Next user handoff: `Review and decide whether to continue into prompt-mechanics refinements or trigger tests for the new routing model`
- Stop and ask the user if: `A broader DevoSkill restructuring is needed beyond bootstrap-first and mode-first routing`

## 2. Setup and Preconditions
- [x] Local skilldocs mapping established
- [x] Improvement scope narrowed to a first slice
- [x] Explicit user approval to modify the DevoSkill project received

## 3. Execution Tasks

### 3.1 Bootstrap-first router refactor
- Scope: Move DevoSkill's most important routing decisions to the front of the entry prompt so the model first decides path state and work mode, then loads the smallest matching skill.
- Files / modules: `skills/devoskill/SKILL.md`, `skills/devoskill-workspace-setup/SKILL.md`
- Constraints: Preserve the router model, keep rules concise, and avoid loading workspace-setup by default when canonical state already exists.

- [x] **Task 3.1.1**
  - Target: `skills/devoskill/SKILL.md`
  - Action: Restructure the entry skill around `bootstrap-first -> classify mode -> route by mode -> load support modules only when needed`.
  - Expected output: The first part of the prompt contains the highest-value decisions, so the model can remember them and lazy-load the detailed skills later.
  - Verification: The entry skill now leads with canonical path checks, exact mode classification, and phase-aware rerouting rules.
  - Status / writeback note: `Completed by moving workspace/path guard clauses and primary mode routing to the front of the entry prompt.`

- [x] **Task 3.1.2**
  - Target: `skills/devoskill-workspace-setup/SKILL.md`
  - Action: Convert workspace setup into an explicit bootstrap/repair mode instead of a default background skill.
  - Expected output: Agents stop reading path-related instructions when canonical mapping state already exists.
  - Verification: Workspace setup skill says to run only when canonical mapping is missing/broken or when the task is explicitly about setup.
  - Status / writeback note: `Completed by turning workspace setup into a guarded bootstrap mode tied to the canonical mapping file.`

### 3.2 Phase-aware sibling skill updates
- Scope: Make each primary skill assume routing already happened, but still self-check whether the work is still in the same mode.
- Files / modules: `skills/devoskill-planning/SKILL.md`, `skills/devoskill-development/SKILL.md`, `skills/devoskill-review/SKILL.md`, `skills/devoskill-performance/SKILL.md`
- Constraints: Keep sibling skills small and mode-specific; do not re-explain the whole router in every file.

- [x] **Task 3.2.1**
  - Target: `skills/devoskill-planning/SKILL.md`, `skills/devoskill-development/SKILL.md`, `skills/devoskill-review/SKILL.md`, `skills/devoskill-performance/SKILL.md`
  - Action: Make each mode-specific skill explicitly assume prior routing, skip workspace setup unless broken, and reroute if the user has changed phase.
  - Expected output: Agents can orient themselves while working instead of blindly staying in the first-loaded skill.
  - Verification: Each sibling skill now says what mode it assumes, when to skip workspace setup, and when to reroute.
  - Status / writeback note: `Completed by adding phase self-checks and lazy workspace-setup loading rules to the sibling skills.`

### 3.3 Planning writeback
- Scope: Bring the project-level planning docs into alignment with the new prompt mechanics.
- Files / modules: `docs/DevoSkill/architecture.md`, `docs/DevoSkill/task.md`
- Constraints: Keep planning files concise and describe only the effective routing model.

- [x] **Task 3.3.1**
  - Target: `docs/DevoSkill/architecture.md`, `docs/DevoSkill/task.md`
  - Action: Write back Phase 4 so the planning surface describes bootstrap-first routing and phase-aware sibling skills.
  - Expected output: The project-level docs describe the current prompt structure rather than the previous contract-hardening slice alone.
  - Verification: Architecture and task docs both mention front-loaded path/mode decisions and phase self-check behavior.
  - Status / writeback note: `Completed by updating the project-level docs to reflect bootstrap-first and mode-first routing as the current effective design.`

## 4. Human Handoff Points
- [ ] Human decides whether to proceed into broader DevoSkill productization after this contract-hardening slice

## 5. Out of Scope for This Phase
- Full multi-agent test matrix
- Runtime code generation harnesses outside the current document-driven contract
- Broad DevoSkill workflow redesign beyond bootstrap-first and mode-first routing

## 6. Completion Criteria for This Phase
- [x] Entry prompt front-loads path and mode decisions
- [x] Sibling skills explicitly assume a mode and self-check for rerouting
- [x] Planning docs reflect the new routing model
- [x] Planning files reflect actual work state
