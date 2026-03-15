# Hybrid Planning Protocol

Use this when a new capability is being added into an existing system and both target design and inherited constraints materially matter.

## Planning Objective
Separate what is newly designed from what is inherited, then define the integration boundary clearly.

## Required Outputs in `architecture.md`
- **Current Host System**
- **New Capability**
- **Integration Boundary**
- **Constraints Inherited From the Existing System**
- **New Components or Flows**
- **Compatibility and Migration Concerns**
- **Phased Delivery Plan** when rollout is staged

## Rules
1. Do not treat inherited constraints as optional.
2. Do not let existing-system details drown the description of the new capability.
3. Make the integration point explicit: where requests enter, where state changes, and where ownership changes.
4. If the work requires staged rollout, architecture phases must be written before task phases.

## Task Generation Requirements
`task.md` must:
- separate host-system work from net-new work,
- identify interface contracts between the two,
- define safe execution order,
- stop when further work depends on human decisions or newly observed reality.
