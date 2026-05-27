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

## Execution Order — Just-In-Time Loading

Read each file immediately before the step that depends on it. Do not pre-load every file at phase entry; see doctrine § 2.

### Step R1 — Enter the review workflow

Before forming any review judgment, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/03-review.md`. This file owns the review workflow contract.

### Step R2 — Identify and enumerate the feature folder

Identify the active feature folder (e.g. `.devoskill/<feature-slug>/`); ask the user if not specified.

Then enumerate the folder with `ls`. **Read every `.md` file present** before forming review judgments (e.g. `task.md`, `architecture.md`, `design.md`, `test.md`, `verification.md`, `PR.md`, ad-hoc design memos, `notes/*.md`), unless the user has explicitly scoped the review to a subset. Do not assume `task.md` + `architecture.md` are exhaustive — feature folders often contain PR drafts, post-review changelogs, or ad-hoc memos that the user expects you to consult.

### Step R3 — Anchor against effective architecture

Load the active phase in `task.md`, the relevant sections of feature `architecture.md`, then project-level `architecture.md` for baseline context.

### Step R4 — Load engineering standards for the touched stack

Before judging structural compliance, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/engineering-standards.md` — focus on the language-specific section matching the implementation.

### Step R5 — Language-specific review (conditional)

Read the matching mode protocol + quality workflow just before reviewing each stack's code:

- Go: `{DEVOSKILL_ROOT}/skills/devoskill/protocols/go-implementation-mode.md` (was the implementation mode chosen correctly?)
- Ruby / Rails: `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rails-maintenance-mode.md` + `{DEVOSKILL_ROOT}/skills/devoskill/workflows/quality-ruby.md` (did the change preserve existing style, lifecycle, error boundaries, and Ruby/Rails quality rules?)

### Step R6 — Cross-project / shared rules (conditional)

Before judging any cross-project / company-level operational boundary (push, PR creation, external system updates), consult `{DEVOSKILL_ROOT}/skills/devoskill/protocols/custom-INDEX.md` and open only the section the index points to.

### Step R7 — Project/domain skill (conditional)

If the work is project/domain-specific (e.g. a downstream project skill), load the matching project skill just-in-time based on repo/path context or explicit user intent. If that project skill exposes registry-based discovery, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rule-registry-routing.md`.

---

Do not read planning or development workflows from review unless the work actually reroutes.

## Required Behavior

- Keep checking that the task is still validation/compliance work. If the user pivots into planning, coding, or performance debugging, reroute.
- Review for scope bleed, architecture drift, phase integrity, and file size violations.
- Treat `architecture.md` and `task.md` as the source of truth, not "working code".
- If code and architecture diverge, return a concrete discrepancy list instead of normalizing the drift.
- Verify the durable evidence surface as part of review. A phase is not complete if claims in `task.md` cannot be traced to repository state or persisted verification artifacts.
- When a review depends on project/domain rules, treat the project skill as the authority instead of searching DevoSkill shared custom files for that concern.

---

## Strongest-Attention Rules

Re-read these on every reroute into Review and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **`architecture.md` + `task.md` are source of truth, not "working code".** If code disagrees with docs, the code is the deviation; do not normalize drift.
2. **Return a concrete discrepancy list.** Each finding names the file/line on the code side and the section on the doc side. Vague "looks fine / looks off" is not a review.
3. **Enumerate the feature folder with `ls`.** Do not assume `task.md` + `architecture.md` are exhaustive — read every `.md` in the folder unless the user explicitly scoped the review.
4. **Trace every `task.md` claim to evidence.** If a claim cannot be traced to repo state or `verification.md`, the phase is not complete.
5. **Project skill is the authority for project/domain rules.** Do not invent project rules from DevoSkill shared protocols when a dedicated project skill owns the concern.
