# Greenfield Planning Protocol

Use this when the project or subsystem is effectively new.

## Planning Objective
Converge on the intended end-state shape without pretending that every implementation detail is already known.

## Required Outputs in `architecture.md`
- **System Goal**
- **Success Criteria**
- **Target Shape**
- **Major Components and Responsibilities**
- **Primary Data / Control Flow**
- **Known Constraints**
- **Non-Goals**
- **Open Decisions That May Change During Implementation**
- **Phased Delivery Plan** when the work is large

## Rules
1. Start from the final desired shape, not from speculative implementation detail.
2. Record implementation-sensitive uncertainties as explicit open decisions instead of fake certainty.
3. If later implementation reality forces a design adjustment, update `architecture.md` so it remains the current effective architecture.
4. Do not turn a greenfield architecture into a diary of every design conversation.

## Task Generation Requirements
`task.md` must:
- map directly to the approved target shape,
- be organized by phase when scope is broad,
- identify user dependencies or approvals still needed,
- stop before speculative tasks that depend on unresolved decisions.
