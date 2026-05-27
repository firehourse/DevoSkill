# Planning Approval Workflow

Use this step when handing planning back to the user.

## Rules
- Read `../protocols/implementation-readiness-gate.md` immediately before this handoff.
- If the change adds, changes, or removes observable behavior or agent workflow behavior, read `../protocols/change-review-packet.md` before this handoff.
- Apply the Implementation Readiness Gate before declaring planning complete or asking whether implementation should begin.
- If the gate fails, do not ask for implementation approval. Stay in Planning, report the specific blocking ambiguity, and resolve it in the planning documents.
- If behavior delta is required, do not ask for implementation approval until the feature-level `architecture.md` contains `Behavior Delta` and `task.md`, `test.md`, and `verification.md` identify how it will be executed and proven.
- Stop after planning documents are updated.
- Ask explicitly whether implementation should begin.
- Do not treat `task.md` existence as implementation approval.
- Do not treat user approval as valid while active planning documents still contain implementation choices for the Developer.
- Keep the planning surface clean: default context is active phase plus effective architecture, not history.
- Do not auto-switch into development because the docs now exist.
- Do not begin "small safe edits" before approval.

## Red Flags — Stay in Planning

- "The docs exist now, so I can start"
- "Just a small safe edit before approval"
- "Approval is implied, the user saw the plan"
- "I'll begin while planning wraps up"

Each means: do not edit code. Ask explicitly whether implementation should begin.
