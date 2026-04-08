# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 3`
- Goal: Write back the newer contract-driven DevoSkill rules into the project planning surface and clean the local-state boundaries so the repo matches the updated workflows.
- Depends on architecture sections: `Current Reality`, `Approved Target Shape`, `Boundaries`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-04-08 wrote back Phase 3 contract-hardening changes, aligned architecture/task docs with current workflows, and cleaned duplicate local-state paths`
- User inputs still required: `None for this slice`
- Current blocker: `None`
- Next user handoff: `Review and decide whether to continue into further DevoSkill productization`
- Stop and ask the user if: `A broader DevoSkill restructuring is needed beyond contract hardening and repo hygiene`

## 2. Setup and Preconditions
- [x] Local skilldocs mapping established
- [x] Improvement scope narrowed to a first slice
- [x] Explicit user approval to modify the DevoSkill project received

## 3. Execution Tasks

### 3.1 Contract-driven workflow hardening
- Scope: Expand DevoSkill from a lightweight routing improvement into an explicit execution contract with feature-folder layout, design/verification artifacts, engineering standards, and durable evidence requirements.
- Files / modules: `skills/devoskill/SKILL.md`, `skills/devoskill-development/SKILL.md`, `skills/devoskill-review/SKILL.md`, `skills/devoskill-planning/SKILL.md`, `skills/devoskill/protocols/workspace-setup.md`, `skills/devoskill/workflows/02-development.md`, `skills/devoskill/workflows/03-review.md`, `skills/devoskill/workflows/05-quality.md`, `skills/devoskill/workflows/engineering-standards.md`, `skills/devoskill/workflows/quality-go.md`, `skills/devoskill/workflows/quality-node.md`, `skills/devoskill/templates/*`
- Constraints: Preserve the router model, keep rules concise, and make the planning/evidence contract explicit instead of implied in chat.

- [x] **Task 3.1.1**
  - Target: `skills/devoskill/protocols/workspace-setup.md`, `skills/devoskill-workspace-setup/SKILL.md`, `.gitignore`
  - Action: Define the project/feature folder structure, canonical `.devoskill` target shape, and local-state boundary rules.
  - Expected output: Workspace setup rules point to one canonical mapping path and treat duplicate local-state files as repo pollution rather than valid state.
  - Verification: Workspace setup docs describe project root plus feature folders, and duplicate local-state paths are ignored/cleaned.
  - Status / writeback note: `Completed by documenting project+feature folder structure, canonicalizing workspace-map local state, and updating git ignore coverage for accidental local-state paths.`

- [x] **Task 3.1.2**
  - Target: `skills/devoskill/workflows/02-development.md`, `skills/devoskill/workflows/03-review.md`, `skills/devoskill/workflows/05-quality.md`, `skills/devoskill/workflows/engineering-standards.md`, `skills/devoskill/workflows/quality-go.md`, `skills/devoskill/workflows/quality-node.md`
  - Action: Add explicit development/review/quality checks for design contracts, verification artifacts, engineering standards, authorization boundaries, and artifact hygiene.
  - Expected output: Development and review are now contract-driven rather than relying on implied chat context.
  - Verification: The workflows require `design.md`, `verification.md`, engineering-standards checks, and evidence/artifact reconciliation.
  - Status / writeback note: `Completed by adding explicit contract loading order, engineering standards, evidence-surface checks, authorization checks, and runtime artifact hygiene guidance.`

- [x] **Task 3.1.3**
  - Target: `skills/devoskill/templates/architecture.md`, `skills/devoskill/templates/task.md`, `skills/devoskill/templates/verification.md`, `skills/devoskill/templates/design-go.md`, `skills/devoskill/templates/design-node.md`, `skills/devoskill/templates/design-python.md`
  - Action: Extend templates so the planning surface can explicitly capture inputs, durable evidence, verification contracts, and implementation tree/design expectations.
  - Expected output: A new planning run can produce the artifacts that the updated development/review rules now require.
  - Verification: Templates expose harness contract, verification artifact, behavior contract, and planning-reality reconciliation fields.
  - Status / writeback note: `Completed by adding design and verification templates plus richer architecture/task templates that match the new workflow expectations.`

### 3.2 Planning writeback and repo hygiene
- Scope: Bring the project-level planning docs and repository hygiene into alignment with the broader contract-hardening work.
- Files / modules: `docs/DevoSkill/architecture.md`, `docs/DevoSkill/task.md`, `.gitignore`, local `workspace-map.local.json` pollution paths
- Constraints: Keep planning files concise and avoid tracking machine-local state.

- [x] **Task 3.2.1**
  - Target: `docs/DevoSkill/architecture.md`, `docs/DevoSkill/task.md`
  - Action: Write back the current Phase 3 contract-hardening work so the planning surface describes actual repository state.
  - Expected output: The project-level docs no longer pretend the repo is only on the old trigger-testing slice.
  - Verification: Architecture and task docs both mention contract hardening, verification artifacts, and workspace/local-state boundaries.
  - Status / writeback note: `Completed by updating the project-level planning docs to reflect the broader workflow/template/quality changes already present in the repo.`

- [x] **Task 3.2.2**
  - Target: `config/workspace-map.local.json`, `skills/config/workspace-map.local.json`
  - Action: Remove duplicate accidental local-state files that drifted outside the canonical path.
  - Expected output: Only the canonical `skills/devoskill/config/workspace-map.local.json` remains as local machine state.
  - Verification: Accidental duplicate `workspace-map.local.json` paths are absent from the repo tree and ignored if recreated.
  - Status / writeback note: `Completed by deleting duplicate root/skills local-state files and widening gitignore coverage so they do not reappear as repo noise.`

## 4. Human Handoff Points
- [ ] Human decides whether to proceed into broader DevoSkill productization after this contract-hardening slice

## 5. Out of Scope for This Phase
- Full multi-agent test matrix
- Runtime code generation harnesses outside the current document-driven contract
- Broad DevoSkill workflow redesign beyond contract hardening and repo hygiene

## 6. Completion Criteria for This Phase
- [x] Workflow and template changes are reflected in project planning docs
- [x] Canonical local-state path is explicit and duplicate local-state files are cleaned up
- [x] Updated contract expectations remain within concise planning documents
- [x] Planning files reflect actual work state
