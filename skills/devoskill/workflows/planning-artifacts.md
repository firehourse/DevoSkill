# Planning Artifacts Workflow

Use this step when generating or rewriting planning artifacts.

## Architecture
- Write only effective architecture and stable boundaries.
- Externalize allowed inputs, forbidden inputs, ownership boundaries, lifecycle rules, and required evidence.
- Existing-system changes write a feature-level `architecture.md` only when the change introduces meaningful new components, boundaries, or design decisions.
- New projects write the full system architecture at the project root.
- Before writing behavior-delta sections, read `../protocols/change-review-packet.md`.
- For changes that add, change, or remove observable behavior or agent workflow behavior, add a skeletal `Behavior Delta` section to feature-level `architecture.md` with `Added`, `Changed`, `Removed`, `Non-Goals`, and `Review Evidence`.
- Keep `Behavior Delta` skeletal. Do not put execution rules or rationale there.
- Do not leave active-phase architecture as a menu of possible designs. If an option is selected, write it as the target shape. If an option is rejected or deferred, mark it out of scope or future phase.
- Open questions that can change behavior, boundaries, dependencies, security/data rules, risk, scope, or verification mean planning is incomplete. Equivalent private implementation choices may remain adaptive.

## Task
- Write only the active executable phase.
- Define the surgical change boundary before implementation: allowed files/modules, explicitly out-of-scope cleanup, allowed cleanup caused by the planned change, and the diff review focus.
- Link task groups to behavior-delta entries when a behavior delta drives implementation.
- Include verification expectations, stop points, and forbidden shortcuts.
- Large changes must be phase-based instead of one monolithic checklist.
- `task.md` must be decision-complete for consequential active-phase choices. It may contain stop conditions and may delegate equivalent private implementation choices to the Developer's Better Path Check.
- If `User inputs still required`, `Current blocker`, or `Next user handoff` must be resolved before coding, the phase is still Planning-only.

## Test
- Bootstrap `test.md` before implementation when the feature includes code changes.
- `test.md` derives from `design.md` and records the selected methodology: `TDD`, `BDD`, or `Follow Existing Project Pattern`.
- `test.md` must map class responsibilities, flows, and behavior contracts to planned test coverage.
- `test.md` must map behavior-delta entries to acceptance, regression, or workflow checks when behavior delta exists.
- `test.md` must name one selected methodology for the active phase, not a list of possible methodologies for the Developer to choose later.

## Verification
- Bootstrap `verification.md` before implementation when the feature includes code changes.
- `verification.md` is the durable home for executed checks, command outcomes, negative paths, artifact cleanup notes, and remaining gaps.
- `verification.md` records executed evidence for behavior-delta entries when behavior delta exists.
- `verification.md` does not own test design; it records executed evidence against `test.md`.
