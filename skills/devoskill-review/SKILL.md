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
4.5 Enumerate the feature folder with `ls`. For every other `.md` file present (e.g., `design.md`, `test.md`, `verification.md`, `PR.md`, ad-hoc design memos, `notes/*.md`), read it before forming review judgments unless the user has explicitly scoped the review to a subset. Do not assume `task.md` + `architecture.md` are exhaustive — feature folders often contain PR drafts, post-review changelogs, or ad-hoc memos that the user expects you to consult.
5. Load project-level `architecture.md` for baseline context
6. If Go code is in scope, read `../devoskill/protocols/go-implementation-mode.md` and review whether the implementation mode was chosen correctly
7. If Ruby/Rails code is in scope, read `../devoskill/protocols/rails-maintenance-mode.md` and review whether the change preserved the existing Rails style and lifecycle behavior
8. Read shared/company-level `../devoskill/protocols/custom-*.md` only when the current review step matches the load conditions defined in `../devoskill/protocols/skill-evolution.md` Section 5
9. If the work is project/domain-specific, load the matching project skill just-in-time based on repo/path context or explicit user intent
10. If that project skill exposes registry-based discovery, read `../devoskill/protocols/rule-registry-routing.md` and follow its `phase -> project/domain -> registry -> current action -> concern` model

Do not read planning or development workflows from review unless the work actually reroutes.

## Required Behavior
- Keep checking that the task is still validation/compliance work. If the user pivots into planning, coding, or performance debugging, reroute.
- Review for scope bleed, architecture drift, phase integrity, and file size violations.
- Treat `architecture.md` and `task.md` as the source of truth, not "working code".
- If code and architecture diverge, return a concrete discrepancy list instead of normalizing the drift.
- Verify the durable evidence surface as part of review. A phase is not complete if claims in `task.md` cannot be traced to repository state or persisted verification artifacts.
- When a review depends on project/domain rules, treat the project skill as the authority instead of searching DevoSkill shared custom files for that concern.
