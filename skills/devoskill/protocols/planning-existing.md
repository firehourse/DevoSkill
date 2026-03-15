# Existing-System Planning Protocol

Use this when the request modifies or extends an already-existing system.

## Planning Objective
Model current reality first, then define the smallest safe delta that satisfies the user's goal.

## Required Outputs in `architecture.md`
- **Current Reality / As-Is**
- **User Requested Delta**
- **Immovable Boundaries**
- **Allowed Change Surface**
- **To-Be Architecture for This Change**
- **Affected Components**
- **Behavioral or Structural Risks**
- **Phased Delivery Plan** when the change is large

## Rules
1. Do not invent a fresh architecture before understanding the current one.
2. The As-Is description must be concrete enough that a later session can understand where the change attaches.
3. Record what must not be changed, including style, abstractions, contracts, schemas, or ownership boundaries.
4. If the user has not provided enough reality to plan safely, ask. Do not infer system-critical details.
5. Keep `architecture.md` focused on the effective current and target model, not a full archaeology log.

## Task Generation Requirements
`task.md` must:
- specify the affected files, modules, or interfaces,
- indicate whether to preserve or change existing patterns,
- sequence the delta in bounded chunks,
- include explicit user handoff points where needed.
