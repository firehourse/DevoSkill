# Operational Gates Protocol

Primary question: which operational actions always require explicit user approval, regardless of route, phase, or how routine the surrounding flow looks?

Use this protocol whenever a step plans, prepares, or executes an action that leaves the local machine or mutates shared state.

## Gates

- **`git commit`**: agents may create local branches and stage/edit files for development work, but do not commit unless the user explicitly asks for it in the current turn. Implementation approval is not commit approval — finish the work, leave the tree uncommitted, and let the user decide when history gets written.
- **`git push` (any branch, any remote)**: must not push unless the user explicitly asks for it in the current turn. Approval in an earlier turn or for a different ref does not carry over.
- **PR creation or update against a shared remote**: same explicit, same-turn approval requirement as push.
- **External system updates** (ticket systems, deployment triggers, third-party APIs that mutate state): explicit approval in the current turn, named per action.
- Plans must call out push / PR creation / external updates as human-approved boundaries, especially when credentials or signing are not ready.

Project/domain skills may add stricter gates on top (e.g. a ticketing discipline that blocks branch naming before a ticket exists); those live in the project skill and are discovered through it. This protocol owns only the workspace-wide floor.

## Red Flags — If You Think This, Stop

- "The user approved a push earlier in this session" — approval is per-turn, per-action.
- "The flow is routine, the push is implied" — routine is exactly when the gate gets skipped silently.
- "It's just a draft PR" — a draft on a shared remote is still external state.
