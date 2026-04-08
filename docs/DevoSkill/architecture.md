# DevoSkill Effective Architecture

## Current Reality
- DevoSkill is a router-style skill framework under `skills/`.
- The core value is phase discipline: planning, approval, development, review, and performance.
- The current structure is strong on protocol routing, but the execution contract has recently expanded beyond the old trigger-testing slice.
- The implementation now includes stronger workspace setup rules, explicit design/verification artifacts, durable evidence requirements, and engineering standards, but the project-level planning docs had not been written back to describe that broader shape.
- Multiple accidental local-state paths (`config/`, `skills/config/`) appeared alongside the canonical `skills/devoskill/config/workspace-map.local.json`, which risks repo pollution and inconsistent workspace mapping behavior.

## Approved Target Shape
- Keep the existing router and phase model intact.
- Keep the existing router and phase model intact while hardening the execution contract.
- Make the planning surface explicitly document:
  - the active feature folder model under `.devoskill`,
  - `design.md` as the binding implementation contract,
  - `verification.md` as the durable evidence surface,
  - engineering standards as mandatory review/development gates,
  - artifact hygiene and ownership/authorization checks as first-class review concerns.
- Keep local workspace state canonical at `skills/devoskill/config/workspace-map.local.json` and treat any duplicate local-state path as legacy pollution to clean up rather than preserve.
- Keep the lightweight trigger-testing skeleton, but treat it as only one slice of the product, not the whole effective architecture.

## Boundaries
- Do not redesign the overall DevoSkill workflow model.
- Do not introduce a heavyweight test harness or unrelated product features.
- Do not track machine-local workspace mapping state in git.
- Keep the new contract-oriented rules compatible with the existing sibling-skill pattern and concise enough to reload quickly.

## Execution Shape
- Phase 1: Add the new grill skill and improve trigger surfacing in the entrypoint docs.
- Phase 2: Add a minimal trigger-testing skeleton and document the low-context testing principle.
- Phase 3: Harden DevoSkill into a document-driven execution contract by adding project/feature folder rules, design/verification artifacts, engineering standards, review evidence checks, and artifact-hygiene expectations.
