# Document Reviewability Protocol

Use this protocol when validating whether the document system is strong enough for later development, review, or quality work.

## Minimum Bar
- The human owner can understand the produced planning documents without reading DevoSkill skill files or replaying chat.
- Development can determine which file/class/flow to implement next from `design.md` and `task.md`.
- Development and review can determine how the design is supposed to be proven from `test.md`.
- Review can compare code against explicit boundaries instead of inferred chat intent.
- Quality can inspect declared evidence surfaces and artifact hygiene expectations.
- Planning can reuse `study/` for broad current-reality understanding without copying that background into every feature.
- A future session can recover active truth without replaying long chat history.

If that is not possible, planning is incomplete.

## Audience And Path Rules
- Reviewer-facing planning surfaces are portable: `architecture.md`, `task.md`, `design.md`, `test.md`, and `verification.md` use repo-relative paths, stable symbols, route names, command names, and document-relative references.
- Reviewer-facing surfaces do not contain machine-local absolute paths, local-only credentials, personal shell aliases, editor paths, or host-specific assumptions.
- Human/operator convenience may be local, but it belongs in `notes/local.md` or another explicitly local note. Local notes are non-authoritative and must not be required for review.
- If a reviewer needs evidence, put the portable proof in `verification.md`; local reproduction hints may link out to local notes only as optional operator context.
