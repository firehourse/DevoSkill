---
name: devoskill-review
description: Review module for DevoSkill. Use when the immediate next action is an independent code-quality defect hunt over implemented code.
---

# DevoSkill Review

Use this skill when the request is to review implemented code for defects and quality on its own merits.
Do not use it for new planning, direct coding, or exploratory debugging.

Review is **not** plan-conformance checking. Two concerns moved out so Review cannot degenerate into diff-matching:
- **Plan conformance** (scope bleed, surgical-diff, style, phase integrity, design/test/behavior contract, change-packet) → Development's Plan Conformance Checkpoint (`workflows/02-development.md` Step 6).
- **Closeout** (doc-sync, evidence surface, task completion, hygiene, decoupled scope/architecture re-verify) → `workflows/closeout-review.md`.

Review hunts what is wrong, missing, or better in the **code itself**.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Review`.

If the work no longer matches review, stop and reroute instead of continuing.

## Execution Order — Just-In-Time Loading

Read each file immediately before the step that depends on it. Do not pre-load every file at phase entry; see doctrine § 2.

### Step R1 — Enter the review workflow (hard gate)

Read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/03-review.md` FIRST — before reading any standards file (R4/R5) and before emitting any MUST/SHOULD/MAY verdict. This file owns the review posture (independent defect hunt) and the severity scheme.

Hard precondition — until R1 is done you MAY NOT read `engineering-standards.md` / `rails-maintenance-mode.md` / `quality-ruby.md` as "the review style", nor emit a verdict. Those are the code standards applied **inside** the Step-2 defect hunt (03-review Step 2 check 4), not a posture to cite before hunting. The gate clears once you have read 03-review.md and can state the change's intent in two sentences.

### Step R2 — Identify and enumerate the feature folder

Identify the active feature folder (e.g. `.devoskill/<feature-slug>/`); ask the user if not specified.

Then enumerate the folder with `ls`. **Read every `.md` file present** for intent before forming judgments (e.g. `task.md`, `architecture.md`, `design.md`, `test.md`, `verification.md`, `PR.md`, ad-hoc memos, `notes/*.md`), unless the user has explicitly scoped the review to a subset. The plan is read for intent, not as a checklist — see R1.

### Step R3 — Anchor against effective architecture

Load the active phase in `task.md` and the relevant sections of feature + project `architecture.md` — only enough to understand the change's intent in two sentences. Then set the plan aside and review the code on its own merits.

### Step R4 — Load engineering standards for the touched stack

As part of the Step-2 defect hunt (03-review Step 2 check 4), read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/engineering-standards.md` — focus on the language-specific section matching the implementation, and apply § 11 per decision-bearing hunk.

### Step R5 — Language-specific review (conditional)

Read the matching mode protocol + quality workflow just before reviewing each stack's code, applying them as the code-standard pass of the defect hunt:

- Go: `{DEVOSKILL_ROOT}/skills/devoskill/protocols/go-implementation-mode.md`
- Ruby / Rails: `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rails-maintenance-mode.md` + `{DEVOSKILL_ROOT}/skills/devoskill/workflows/quality-ruby.md`

### Step R6 — Operational gates (conditional)

Before judging any operational boundary (push, PR creation, external system updates), read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/operational-gates.md`.

### Step R7 — Project/domain skill (conditional)

If the work is project/domain-specific, load the matching project skill just-in-time based on repo/path context or explicit user intent. If that project skill exposes registry-based discovery, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rule-registry-routing.md`.

### Step R8 — Closeout (conditional, final decoupled pass)

If the review is the handoff gate (not just a mid-work code read), run `{DEVOSKILL_ROOT}/skills/devoskill/workflows/closeout-review.md` as the final decoupled pass over doc-sync, evidence, and scope/architecture drift. Skip it if Development already ran closeout and nothing changed since.

---

Do not read planning or development workflows from review unless the work actually reroutes.

## Required Behavior

- Keep checking that the task is still a code-quality defect hunt. If the user pivots into planning, coding, or performance debugging, reroute.
- Hunt the code on its own merits: correctness, edge cases the plan never mentioned, security/resource safety, code-standard violations, and ineffective tests. A bug is a finding regardless of whether the plan covered the area.
- Read the plan for intent only; do not match the diff against it (that is Development's conformance checkpoint).
- Return a concrete, severity-tagged finding list (MUST/SHOULD/MAY); name the file/line and, for SHOULD/MAY convolution, name the simpler direction in one line.
- Do not write or rewrite code — report and hand off.
- If conformance or closeout concerns surface, note them and point at the owning module rather than absorbing those checklists into the hunt.
- When a review depends on project/domain rules, treat the project skill as the authority for that concern.

---

## Strongest-Attention Rules

Re-read these on every reroute into Review and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **Read 03-review.md before any standards file; defect hunt before everything.** `rails-maintenance` / `quality-ruby` / `engineering-standards` are the code standards applied inside the hunt, never cited as "our review style" before hunting. Anchoring on them is the diff-matcher failure mode doctrine §11 forbids.
2. **Review the code on its own merits, not against the plan.** Plan-matching moved to Development's conformance checkpoint. An edge case the plan never mentioned is MORE suspect, not out of scope.
3. **Return a concrete, severity-tagged finding list.** Each finding is tagged MUST/SHOULD/MAY and names the file/line. Vague "looks fine / looks off" is not a review.
4. **Enumerate the feature folder with `ls`.** Do not assume `task.md` + `architecture.md` are exhaustive — read every `.md` in the folder for intent unless the user explicitly scoped the review.
5. **Doc-sync / writeback / evidence is closeout, not Review.** Note such concerns and point at `closeout-review.md`; do not absorb them into the code hunt.
6. **Project skill is the authority for project/domain rules.** Do not invent project rules from DevoSkill shared protocols when a dedicated project skill owns the concern.
