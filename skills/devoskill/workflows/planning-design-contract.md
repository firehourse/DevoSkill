# Planning Design Contract Workflow

Use this step when generating `design.md`.

## Rules
- `design.md` is the compact execution contract, not a narrative summary.
- Existing-system and hybrid work may adapt to the real codebase, but must still satisfy the required design contract sections.
- For greenfield work, start from the stack-specific template.
- For existing/hybrid work, scan only the minimum useful surface:
  - dependency manifest
  - entry point
  - one complete vertical slice
  - types/domain directory listing
  - shared utility files

## Required Sections
- actual file/folder structure
- one or more diagrams covering all implementation boundaries
- `Class Responsibilities`
- `Flow Mapping`
- behavior contract
- verification artifact section
- explicit phase-approved exceptions

## Minimum Bar
- topology graph alone is insufficient
- class diagram without responsibilities is insufficient
- class diagram without runtime flow mapping is insufficient
- one merged multi-runtime diagram that hides ownership boundaries is insufficient
- if a future developer cannot answer "which class handles this next?" from `design.md`, planning is incomplete
