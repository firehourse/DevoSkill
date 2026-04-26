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

## Minimum Bar
- `design.md` can be understood by the human owner without reading skill files or replaying chat
- reviewer-facing sections contain no machine-local absolute paths or host-specific assumptions
- topology graph alone is insufficient
- class diagram without responsibilities is insufficient
- class diagram without runtime flow mapping is insufficient
- stack-specific quality constraints that materially shape implementation are missing from `design.md`
- one merged multi-runtime diagram that hides ownership boundaries is insufficient
- if a future developer cannot answer "which class handles this next?" from `design.md`, planning is incomplete
- if a future developer cannot derive a concrete `test.md` from `design.md`, planning is incomplete
