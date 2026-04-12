# Workspace Repair Protocol

Use this protocol when workspace mapping and local symlink state drift out of sync.

## Common Drift Cases
- mapping exists but `.devoskill` is missing
- mapping exists and `.devoskill` points to a different project
- mapping path is valid but the previously used project is no longer the active one
- workspace was repurposed for a different project set over time

## Repair Rules
- Repair workspace state only when:
  - bootstrap cannot determine the current docs location safely, or
  - the task is explicitly about workspace setup/repair, or
  - the current session cannot proceed without resolving the active project
- If `.devoskill` already points to a plausible project and the user is actively working there, do not force-switch it to match legacy mapping state.
- When drift is detected, surface it explicitly:
  - mapping target
  - symlink target
  - which one is being treated as active for the current session
- If the current session can continue safely, route first and repair second.
- If repair persistence fails (for example mapping-file write failure), surface the failure explicitly and continue only with clearly labeled session-local derived state.
- Do not report repair as completed when the canonical file write failed.
