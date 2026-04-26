# Design Template Contract

Use this file as the small, mandatory contract for every `design.md`.
Stack-specific templates provide detail and examples, but they do not replace this contract.

## Audience Contract
- `design.md` must be readable by the human owner without opening skill files or replaying chat.
- `design.md` is part of the reviewer-facing portable planning surface. Use repo-relative paths, stable symbols, route names, command names, and document-relative references.
- Do not put machine-local absolute paths, local-only credentials, personal shell aliases, editor paths, or host-specific paths in reviewer-facing sections.
- If local convenience is useful for the human owner, put it in feature-level `notes/local.md` or another explicitly local note, then reference it as non-authoritative local context.

## Required Anchors
Every `design.md` must contain these anchors unless an explicit phase-approved exception states why the anchor is not applicable:

- `Source Inputs`
- `Relevant Structure`
- `Boundary Diagram` or `Boundary Map`
- `Responsibilities`
- `Flow Mapping`
- `Behavior Contract`
- `Test Derivation Hooks`
- `Verification Artifacts`
- `Approved Exceptions`

## Source Inputs
This section records where the design came from. Keep it short and typed.

- Architecture:
- Study:
- Changelog:
- Code read surface:
- User-provided inputs:
- Local operator notes, if any:

Reviewer-facing source inputs must be portable. Local operator notes are convenience references only and do not approve implementation behavior.

## Completion Rules
- A future developer can answer which component handles the next implementation step from `Responsibilities` and `Flow Mapping`.
- A future reviewer can compare code against explicit boundaries without inferring intent from chat.
- `Test Derivation Hooks` are specific enough to create or validate `test.md`.
- `Verification Artifacts` are specific enough to create or validate `verification.md`.
- Every local-only reference is isolated to local notes and excluded from reviewer-facing proof.

## Split Rules
- Keep the contract small. Put examples, stack-specific naming rules, and detailed diagrams in stack-specific or section-specific template modules.
- If a generated `design.md` becomes too large, split background into `study/`, rationale into `project-changelog.md`, local convenience into `notes/local.md`, and phase-local abandoned context into `notes/`.
