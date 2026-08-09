# Planning Design Contract Workflow

Use this step when generating `design.md`.

## Rules
- `design.md` is the compact execution contract, not a narrative summary.
- Start from `../templates/design.contract.md` for mandatory anchors, audience rules, source inputs, completion rules, and split rules.
- Existing-system and hybrid work may adapt to the real codebase, but must still satisfy the required design contract sections.
- For greenfield work, combine `design.contract.md` with the stack-specific template.
- Before drawing class diagrams or boundary maps, apply the relevant stack-specific planning skill or protocol so the diagram shape reflects the real implementation style. For Rails, `../protocols/rails-maintenance-mode.md` decides whether the Rails segment uses a prose Boundary Map or a concrete class diagram.
- When a stack-specific quality workflow exists, pull consequential constraints into `design.md` up front. Public naming, error/lifecycle ownership, and architecturally significant module boundaries must be explicit; incidental helper names and private decomposition stay adaptive.
- Keep reviewer-facing design content portable across environments. Use repo-relative paths and stable symbols; put machine-local paths or operator conveniences only in feature-level `notes/local.md` or another explicitly local note.
- For existing/hybrid work, scan only the minimum useful surface:
  - dependency manifest
  - entry point
  - one complete vertical slice
  - types/domain directory listing
  - shared utility files

## Required Sections
- source inputs
- relevant existing structure and planned stable boundaries
- one or more diagrams covering all implementation boundaries
- `Class Responsibilities`
- `Flow Mapping`
- behavior contract
- test derivation hooks sufficient for `test.md` to map the design into executable coverage
- verification artifact section
- explicit phase-approved exceptions

## Cross-Stack / Multi-Binary Rule
- If the feature spans multiple stacks, runtimes, binaries, apps, or independently deployable boundaries, apply `../templates/design.contract.md` Cross-Stack / Multi-Binary Rule before finalizing `design.md`.
- Do not downgrade non-Rails runtime boundary requirements because the Rails segment uses a prose `Boundary Map`; the shared contract owns required topology, Mermaid `classDiagram`, method/function signatures, responsibilities, and flow traceability.
- For Rails segments, the Boundary Map must name error/rescue ownership when the flow depends on `rescue_from`, API error helpers, custom exception classes, result objects, or exception reporting.
- If a runtime-specific diagram is omitted, record it as an `Approved Exceptions` entry exactly as required by the shared contract.

## Minimum Bar
- `design.md` can be understood by the human owner without reading skill files or replaying chat
- reviewer-facing sections contain no machine-local absolute paths or host-specific assumptions
- topology graph alone is insufficient
- class diagram without responsibilities is insufficient
- class diagram without runtime flow mapping is insufficient
- mixed-stack or multi-binary design that fails the shared Cross-Stack / Multi-Binary Rule is insufficient
- Rails `Boundary Map` prose used to replace required non-Rails runtime Mermaid `classDiagram` sections is insufficient
- stack-specific quality constraints that materially shape implementation are missing from `design.md`
- one merged multi-runtime diagram that hides ownership boundaries is insufficient
- if a future developer cannot answer "which component or boundary owns this next?" from `design.md`, planning is incomplete
- if `design.md` freezes private helper/class/file details that do not affect the approved contract, it is over-specified and should be reduced
- if a future developer cannot derive a concrete `test.md` from `design.md`, planning is incomplete
