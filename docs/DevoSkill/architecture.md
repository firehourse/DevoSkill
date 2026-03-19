# DevoSkill Effective Architecture

## Current Reality
- DevoSkill is a router-style skill framework under `skills/`.
- The core value is phase discipline: planning, approval, development, review, and performance.
- The current structure is strong on protocol routing, but weaker on short-trigger usability and task-specific entry points.

## Approved Target Shape
- Keep the existing router and phase model intact.
- Improve skill discoverability with clearer trigger-oriented descriptions and quick-start guidance.
- Make the top-level router classify from natural project/task descriptions instead of depending on explicit skill names.
- Make planning use user-grilling by default rather than treating grilling as an independent router mode.
- Keep `devoskill-grill` only as a compact support module for planning-time interrogation.
- Add a lightweight trigger-testing skeleton that validates short prompts without importing a heavyweight test harness.
- Update top-level documentation so the new capability is visible without reading the whole tree.

## Boundaries
- Do not redesign the overall DevoSkill workflow model in this slice.
- Do not change unrelated skills or overwrite existing user edits.
- Keep the new skill compact and compatible with the existing sibling-skill pattern.

## Execution Shape
- Phase 1: Add the new grill skill and improve trigger surfacing in the entrypoint docs.
- Phase 2: Add a minimal trigger-testing skeleton and document the low-context testing principle.
