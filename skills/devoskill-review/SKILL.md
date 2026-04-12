---
name: devoskill-review
description: Review module for DevoSkill. Use when reviewing implementation against architecture.md and task.md.
---

# DevoSkill Review

Use this skill when the request is to verify implementation compliance against the approved documents.
Do not use it for new planning, direct coding, or exploratory debugging.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Review`.

If the work no longer matches review, stop and reroute instead of continuing.

## Load Order
1. Read `../devoskill/workflows/03-review.md`
2. Read `../devoskill/workflows/engineering-standards.md` — load the language-specific section matching the implementation stack
3. Identify the active feature folder (e.g. `.devoskill/delete-conversation/`); ask if not specified
4. Load `<feature-folder>/task.md` (active phase only) and `<feature-folder>/architecture.md` if present
5. Load project-level `architecture.md` for baseline context

Do not read planning or development workflows from review unless the work actually reroutes.

## Required Behavior
- Keep checking that the task is still validation/compliance work. If the user pivots into planning, coding, or performance debugging, reroute.
- Review for scope bleed, architecture drift, phase integrity, and file size violations.
- Treat `architecture.md` and `task.md` as the source of truth, not "working code".
- If code and architecture diverge, return a concrete discrepancy list instead of normalizing the drift.
- Verify the durable evidence surface as part of review. A phase is not complete if claims in `task.md` cannot be traced to repository state or persisted verification artifacts.
