# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 5`
- Goal: Add a stable DevoSkill doctrine for future humans/agents and promote `test.md` into a first-class planning artifact tied to `design.md`.
- Depends on architecture sections: `Current Reality`, `Approved Target Shape`, `Boundaries`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-04-12 added doctrine and first-class test contract support across the DevoSkill document system`
- User inputs still required: `None for this slice`
- Current blocker: `None`
- Next user handoff: `Review whether the doctrine and test contract model should be refined further or exercised through a concrete feature plan`
- Stop and ask the user if: `A broader DevoSkill document-system redesign is needed beyond doctrine + test contract integration`

## 2. Setup and Preconditions
- [x] Local skilldocs mapping established
- [x] Improvement scope narrowed to a first slice
- [x] Explicit user approval to modify the DevoSkill project received

## 3. Execution Tasks

### 3.1 Doctrine document
- Scope: Add a stable doctrine document that explains DevoSkill's long-lived design philosophy for future humans and agents.
- Files / modules: `docs/DevoSkill/doctrine.md`, `README.md`, `docs/DevoSkill/architecture.md`
- Constraints: Keep it principle-focused, avoid feature-history drift, and explain prompt-weight-aware design, fine-grained decomposition, shared contracts, and document authority clearly.

- [x] **Task 3.1.1**
  - Target: `docs/DevoSkill/doctrine.md`, `README.md`
  - Action: Write the full doctrine and link it from the main project documentation.
  - Expected output: Future maintainers and agents can understand why DevoSkill is structured the way it is before modifying it.
  - Verification: Doctrine explains router/load strategy, document boundaries, anti-duplication rules, and testing philosophy.
  - Status / writeback note: `Completed by adding a durable doctrine document and linking it from README.`

- [x] **Task 3.1.2**
  - Target: `docs/DevoSkill/architecture.md`
  - Action: Write back the new doctrine/test-contract scope into the effective architecture.
  - Expected output: Project-level docs describe doctrine and `test.md` as part of the effective shape.
  - Verification: Architecture now names doctrine and `test.md` as first-class artifacts.
  - Status / writeback note: `Completed by updating effective architecture to include doctrine and test-contract semantics.`

### 3.2 Test contract integration
- Scope: Promote `test.md` into the document system, templates, workflows, and review semantics.
- Files / modules: `skills/devoskill/templates/*`, `skills/devoskill/protocols/*`, `skills/devoskill/workflows/*`, `README.md`
- Constraints: Keep document ownership clear: `test.md` owns test design, `verification.md` owns executed evidence.

- [x] **Task 3.2.1**
  - Target: `skills/devoskill/templates/test.md`, `skills/devoskill/templates/design-*.md`, `skills/devoskill/templates/task.md`, `skills/devoskill/templates/verification.md`
  - Action: Create the test template and update the other templates to acknowledge design-to-test traceability.
  - Expected output: New features can produce explicit test contracts instead of burying strategy inside verification notes.
  - Verification: Template set now includes `test.md` and cross-references it from design/task/verification.
  - Status / writeback note: `Completed by adding a dedicated test contract template and wiring it into related templates.`

- [x] **Task 3.2.2**
  - Target: `skills/devoskill/protocols/document-authority.md`, `document-loading-order.md`, `document-persistence.md`, `document-reviewability.md`, `workspace-layout.md`, `skills/devoskill/workflows/01-planning.md`, `planning-artifacts.md`, `planning-design-contract.md`, `02-development.md`, `03-review.md`
  - Action: Update DevoSkill semantics so every phase knows when to read, write, and review `test.md`.
  - Expected output: `test.md` is treated as a real contract throughout planning, development, and review.
  - Verification: Workflows and protocols explicitly mention `test.md`, methodology selection, and traceability expectations.
  - Status / writeback note: `Completed by integrating test-contract semantics across document authority, loading order, persistence, planning, development, and review.`

- [x] **Task 3.3.1**
  - Target: `docs/DevoSkill/task.md`
  - Action: Write back the completed doctrine + test-contract phase.
  - Expected output: Project task plan reflects the new completed scope instead of the previous router-only phase.
  - Verification: Active task plan now describes doctrine/test-contract work and marks it completed.
  - Status / writeback note: `Completed by replacing the previous active slice with the new doctrine + test-contract phase writeback.`

## 4. Human Handoff Points
- [ ] Human decides whether to proceed into broader DevoSkill productization after this contract-hardening slice

## 5. Out of Scope for This Phase
- Full executable test harness implementation for every language/runtime
- Runtime code generation harnesses outside the current document-driven contract
- Broad DevoSkill workflow redesign beyond doctrine + test-contract integration

## 6. Completion Criteria for This Phase
- [x] A long-lived doctrine document exists for future humans and agents
- [x] `test.md` exists as a first-class planning artifact
- [x] Templates, workflows, and document protocols recognize `test.md`
- [x] Project planning docs reflect the new doctrine + test-contract model
