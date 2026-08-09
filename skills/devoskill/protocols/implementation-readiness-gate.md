# Implementation Readiness Gate

Use this protocol immediately before either of these actions:
- declaring planning complete or asking whether implementation should begin
- editing implementation files during Development preflight

Its job is to keep planning decisions in Planning. Development-ready documents must be decision-complete for the active phase.

## Core Rule
`architecture.md`, `design.md`, `test.md`, `task.md`, and the verification intent must fix the decisions that change the product or its risk: behavior, system boundaries, dependencies, authorization/data rules, operational semantics, scope, and required evidence. They must not ask the Developer to choose among consequential directions.

A development-ready planning surface may leave equivalent private implementation choices to Developer judgment. Helper names, local decomposition, implementation order, and test seams are not blockers when every valid choice stays inside the approved contract.

## Hard Blockers
Implementation must not begin when the active planning surface contains any of these:

- alternatives for consequential active implementation, such as competing public behavior, component boundaries, dependencies, persistence models, rollout modes, or authorization rules
- `TODO`, `TBD`, placeholder values, or bracketed choices in required active-phase sections
- open questions that can change active-phase behavior, architecturally significant ownership, dependencies, required test methodology/evidence, data contracts, authorization, or rollout behavior
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
- local implementation alternatives explicitly bounded by the same approved behavior, architecture, dependencies, risk, and scope

If an unresolved item affects the current phase, it is not non-blocking. Return to Planning.

## Required Behavior
- In Planning: do not ask for implementation approval until this gate passes. Ask the next high-value question or rewrite the documents so the active phase has one selected path.
- In Development: apply this gate before any file edit. If a consequential ambiguity remains, stop and reroute to Planning. Resolve equivalent local choices through the Better Path Check in `workflows/02-development.md` and write the effective result back.
- In Closeout / conformance re-verify: treat implementation that proceeded through a failed gate as a conformance failure — Development's Plan Conformance Checkpoint (`workflows/02-development.md` Step 6) and `workflows/closeout-review.md` C8 flag it as scope/architecture drift. (Code-quality Review does not match the diff against the plan; it will not catch this.)

## Red Flags — The Gate Has Not Passed

- "The user approved, so the ambiguity is fine now"
- "This public behavior / dependency / boundary choice is small, I'll decide while coding"
- "The docs are close enough to start"
- "The TODO is just a note, not a real blocker"

Each means: stop, classify the item, return to Planning if it touches the active phase.

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

These terms are not automatically failures. Classify each hit as consequential (selected, deferred, out-of-scope, or a stop condition) or as an equivalent local implementation choice delegated to Development.
