# Planning Design Contract Workflow

Use this step when generating `design.md`.

## Rules
- `design.md` is the compact execution contract, not a narrative summary.
- Start from `../templates/design.contract.md` for mandatory anchors, audience rules, source inputs, completion rules, and split rules.
- Existing-system and hybrid work may adapt to the real codebase, but must still satisfy the required design contract sections.
- For greenfield work, combine `design.contract.md` with the stack-specific template.
- When a stack-specific quality workflow exists, pull the implementation-shaping constraints into `design.md` up front. Naming, error boundaries, lifecycle rules, and file/module structure must be explicit during planning rather than discovered only at the final quality gate.
- Keep reviewer-facing design content portable across environments. Use repo-relative paths and stable symbols; put machine-local paths or operator conveniences only in feature-level `notes/local.md` or another explicitly local note.
- For existing/hybrid work, scan only the minimum useful surface:
  - dependency manifest
  - entry point
  - one complete vertical slice
  - types/domain directory listing
  - shared utility files

## Required Sections
- source inputs
- actual file/folder structure
- one or more diagrams covering all implementation boundaries
- `Class Responsibilities`
- `Flow Mapping`
- behavior contract
- test derivation hooks sufficient for `test.md` to map the design into executable coverage
- verification artifact section
- explicit phase-approved exceptions

## Multi-Stack / Multi-Binary Rule
- If the feature spans multiple stacks, runtimes, binaries, apps, or independently deployable boundaries, apply `../templates/design.contract.md` Cross-Stack / Multi-Binary Rule before finalizing `design.md`.
- A single prose `Boundary Map` is insufficient for mixed-stack work when any Go, Node.js/TypeScript, Python, or other method-signature-driven runtime boundary is in active scope.
- Rails Conservative Maintenance may omit a class diagram only for the Rails segment. It cannot waive class diagrams, method/function signatures, or class-level responsibilities required for non-Rails runtime boundaries in the same feature.
- For each Go, Node.js/TypeScript, Python, or other non-Rails runtime boundary in active scope, require one Mermaid `classDiagram` with method/function signatures and matching responsibility subsections.
- Flow mapping must trace meaningful steps to the concrete method, function, class, interface, protocol, struct, or Rails boundary that owns the step.

## Minimum Bar
- `design.md` can be understood by the human owner without reading skill files or replaying chat
- reviewer-facing sections contain no machine-local absolute paths or host-specific assumptions
- topology graph alone is insufficient
- class diagram without responsibilities is insufficient
- class diagram without runtime flow mapping is insufficient
- mixed-stack prose that hides Go, Node.js/TypeScript, Python, or other method-signature-driven runtime boundaries is insufficient
- Rails `Boundary Map` prose used to replace required non-Rails runtime class diagrams is insufficient
- stack-specific quality constraints that materially shape implementation are missing from `design.md`
- one merged multi-runtime diagram that hides ownership boundaries is insufficient
- if a future developer cannot answer "which class handles this next?" from `design.md`, planning is incomplete
- if a future developer cannot derive a concrete `test.md` from `design.md`, planning is incomplete
