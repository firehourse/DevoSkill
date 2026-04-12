# DevoSkill Effective Architecture

## Current Reality
- DevoSkill is a router-style skill framework under `skills/`.
- The core value is phase discipline: planning, approval, development, review, and performance.
- The current structure is strong on protocol routing, but the execution contract has recently expanded beyond the old trigger-testing slice.
- The implementation now includes stronger workspace setup rules, explicit design/verification artifacts, durable evidence requirements, and engineering standards, but the project-level planning docs had not been written back to describe that broader shape.
- The next structural gap is testing: DevoSkill has strong design and verification semantics, but test strategy is not yet a first-class planning artifact.
- The project also lacks a stable doctrine file that explains the underlying prompt-weight-aware design philosophy for future maintainers and agents.
- Multiple accidental local-state paths (`config/`, `skills/config/`) appeared alongside the canonical `skills/devoskill/config/workspace-map.local.json`, which risks repo pollution and inconsistent workspace mapping behavior.
- The current entry prompt still spends too much early attention on background rules instead of first-step decisions, which weakens routing reliability because models remember the front of the prompt more strongly than the middle.

## Approved Target Shape
- Keep the existing router and phase model intact.
- Keep the existing router and phase model intact while hardening the execution contract and front-loading the most important decisions.
- Make the entry skill operate as `bootstrap-first + mode-first + lazy-load`:
  - first check canonical path state,
  - then classify the current work mode,
  - then load only the matching sibling skill,
  - then let that skill load its own fine-grained support modules.
- Make the planning surface explicitly document:
  - the long-lived DevoSkill doctrine for humans and agents,
  - the active feature folder model under `.devoskill`,
  - `design.md` as the binding implementation contract,
  - `test.md` as the binding testing contract derived from `design.md`,
  - `verification.md` as the durable evidence surface,
  - engineering standards as mandatory review/development gates,
  - artifact hygiene and ownership/authorization checks as first-class review concerns.
- Keep local workspace state canonical at `skills/devoskill/config/workspace-map.local.json` and treat any duplicate local-state path as legacy pollution to clean up rather than preserve.
- Keep the lightweight trigger-testing skeleton, but treat it as only one slice of the product, not the whole effective architecture.
- Make sibling skills phase-aware: they should assume a primary mode has already been chosen, but they must still self-check and reroute if the work changes phase.

## Boundaries
- Do not redesign the overall DevoSkill workflow model.
- Do not turn the new doctrine into feature-history or duplicate README prose without adding sharper operational guidance.
- Do not introduce a heavyweight test harness or unrelated product features.
- Do not track machine-local workspace mapping state in git.
- Keep the new contract-oriented rules compatible with the existing sibling-skill pattern and concise enough to reload quickly.

## Execution Shape
- Phase 1: Add the new grill skill and improve trigger surfacing in the entrypoint docs.
- Phase 2: Add a minimal trigger-testing skeleton and document the low-context testing principle.
- Phase 3: Harden DevoSkill into a document-driven execution contract by adding project/feature folder rules, design/verification artifacts, engineering standards, review evidence checks, and artifact-hygiene expectations.
- Phase 4: Restructure the entry router so bootstrap/path decisions and work-mode classification happen at the front of the prompt, and make sibling skills explicitly rely on that routing model.
- Phase 5: Add a durable doctrine document and promote `test.md` into a first-class planning artifact across templates, workflows, and document-system semantics.
