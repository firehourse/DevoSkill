# Implementation Readiness Gate

Use this protocol immediately before either of these actions:
- declaring planning complete or asking whether implementation should begin
- editing implementation files during Development preflight

Its job is to keep planning decisions in Planning. Development-ready documents must be decision-complete for the active phase.

## Core Rule
`architecture.md`, `design.md`, `test.md`, `task.md`, and the verification intent must instruct the Developer what to do. They must not ask the Developer to choose the active implementation direction.

A development-ready planning surface may contain selected decisions, explicit out-of-scope items, future-phase deferred options, and stop conditions. It may not contain active-phase decision branches.

## Hard Blockers
Implementation must not begin when the active planning surface contains any of these:

- alternatives for active implementation, such as "choose A or B", "either", "depending on judgment", or "pick the better approach"
- `TODO`, `TBD`, placeholder values, or bracketed choices in required active-phase sections
- open questions that can change active-phase behavior, file/module ownership, dependencies, test methodology, verification evidence, data contracts, authorization, or rollout behavior
- `User inputs still required`, `Current blocker`, or `Next user handoff` values that must be resolved before coding
- disagreement between `architecture.md`, `design.md`, `test.md`, `task.md`, or required user-provided contracts
- missing selected testing methodology, surgical change boundary, behavior contract, verification artifact path, or approval boundary
- approved exceptions that do not state the selected exception, reason, and compensating verification

User implementation approval does not override this gate. Approval can authorize execution only after the active planning surface is decision-complete.

## Allowed Non-Blocking Content
These are allowed only when they do not affect the active phase:

- deferred alternatives explicitly assigned to a future phase
- out-of-scope options that are not referenced by active tasks
- notes explaining rejected options, when stored outside the active execution contract or clearly marked as non-authoritative
- human handoff or stop conditions that tell the Developer to stop instead of choose

If an unresolved item affects the current phase, it is not non-blocking. Return to Planning.

## Required Behavior
- In Planning: do not ask for implementation approval until this gate passes. Ask the next high-value question or rewrite the documents so the active phase has one selected path.
- In Development: apply this gate before any file edit. If it fails, stop, report the blocking ambiguity, and reroute to Planning.
- In Review: treat implementation that proceeded through a failed gate as a planning compliance failure.

## Fast Inspection Heuristics
Search the active planning surface for:
- `TODO`
- `TBD`
- `[`
- `?`
- `choose`
- `either`
- `or`
- `option`
- `alternative`
- `open question`
- `user input`
- `current blocker`

These terms are not automatically failures, but each hit must be classified as selected, deferred, out-of-scope, or a stop condition before development begins.
