---
name: devoskill-planning
description: Planning module for DevoSkill. Use when the task is architecture design, request analysis, task planning, or planning document generation. This mode grills the user by default to expose assumptions and missing constraints before writing planning docs.
---

# DevoSkill Planning

Use this skill when the immediate task is to decide, design, scope, or rewrite the plan.
Do not use it for approved coding, compliance-only review, or measured debugging.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Planning`.

If the work no longer matches planning, stop and return to the correct primary mode instead of continuing.

## Execution Order — Just-In-Time Loading

Read each file immediately before the step that depends on it. Do not pre-load every file at phase entry; see doctrine § 2.

### Step P1 — Workspace bootstrap (only if broken)

If workspace mapping is missing or broken, read `{DEVOSKILL_ROOT}/skills/devoskill-workspace-setup/SKILL.md` first and repair it. Otherwise skip and continue.

### Step P2 — Enter the planning workflow

Before opening the user grilling, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/01-planning.md`. This file owns the planning workflow contract for the whole phase.

### Step P3 — Run the Thinking Phase

Before writing or rewriting `architecture.md` or `task.md`, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/thinking-phase.md` and complete the thinking phase. No artifact writes before this step closes.

### Step P4 — Choose the interview style

Before asking the user open-ended questions, read `{DEVOSKILL_ROOT}/skills/devoskill-grill/SKILL.md`. Grilling is the default interaction style for planning interviews.

### Step P5 — Recover reusable reality (existing systems only)

Read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/study-surface.md` only when existing-system planning needs reusable repository, subsystem, flow, or architecture understanding. Skip for greenfield.

### Step P6 — Classify the request and load the matching planning protocol

Before drafting `architecture.md`, classify the request and read **exactly one** of:

- `{DEVOSKILL_ROOT}/skills/devoskill/protocols/planning-greenfield.md`
- `{DEVOSKILL_ROOT}/skills/devoskill/protocols/planning-existing.md`
- `{DEVOSKILL_ROOT}/skills/devoskill/protocols/planning-hybrid.md`

### Step P7 — Pull stack-specific contracts forward

Before finalizing `design.md` or `task.md`, read the matching language quality + design template for every stack present in the implementation:

| Stack present | Read before finalizing design / task |
|---|---|
| Go | `{DEVOSKILL_ROOT}/skills/devoskill/protocols/go-implementation-mode.md` + `{DEVOSKILL_ROOT}/skills/devoskill/templates/design-go.md` + `{DEVOSKILL_ROOT}/skills/devoskill/workflows/quality-go.md` |
| Node.js / TypeScript | `{DEVOSKILL_ROOT}/skills/devoskill/templates/design-node.md` + `{DEVOSKILL_ROOT}/skills/devoskill/workflows/quality-node.md` |
| Python | `{DEVOSKILL_ROOT}/skills/devoskill/templates/design-python.md` + `{DEVOSKILL_ROOT}/skills/devoskill/workflows/quality-python.md` |
| Ruby / Rails | `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rails-maintenance-mode.md` + `{DEVOSKILL_ROOT}/skills/devoskill/templates/design-ruby.md` + `{DEVOSKILL_ROOT}/skills/devoskill/workflows/quality-ruby.md` |

Stack-specific quality constraints that affect naming, error boundaries, lifecycle behavior, test seams, or file/module structure must land in `design.md` — not deferred to the post-implementation quality gate.

### Step P8 — Cross-project / shared rules (conditional)

Before any plan step that may touch cross-project / company-level operational boundaries (push, PR creation, external system updates, shared naming/style), consult `{DEVOSKILL_ROOT}/skills/devoskill/protocols/custom-INDEX.md`. Only open a `custom-*.md` file when the index points to a relevant section.

### Step P9 — Project/domain skill (conditional)

If the work is project/domain-specific (e.g. a downstream project skill), load the matching project skill just-in-time based on repo/path context or explicit user intent. If that project skill exposes registry-based discovery, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rule-registry-routing.md` and follow its `phase -> project/domain or knowledge surface -> registry -> current action -> concern` model.

---

Do not read development, review, quality, or performance workflows from planning unless the work actually reroutes.

## Required Behavior

- Plan by grilling the user one high-value question at a time until assumptions, constraints, and boundaries are explicit enough to write effective docs.
- Keep checking that the task is still in planning mode. If the user pivots to code changes, review, or runtime debugging, reroute.
- Use the canonical workspace mapping state and `.devoskill` symlink rules only when actually needed.
- Keep planning output limited to the effective architecture, explicit contracts, and the active executable phase.
- Write planning documents in the user's language. Section headings may stay in English as structural anchors, but the body should match the user's language.
- Do not maintain planning state through conversational summaries. Persist effective state in `architecture.md`, `task.md`, `design.md`, `verification.md`, or `notes/` only when needed.
- Externalize harness behavior into durable natural-language artifacts: inputs, allowed read surface, stop conditions, verification contract, and writeback contract must be explicit in the planning docs rather than implied in chat.
- Use Study as the reusable reality-acquisition layer when planning needs broad existing-system understanding. Promote only change-specific facts from Study into the active planning surface.
- Include shared/company-level operational boundaries from custom protocols in planning docs when they affect execution.
- Load project/domain rules from the matching skill when the plan depends on them; do not treat DevoSkill shared custom files as the default home for project-specific concerns.

---

## Strongest-Attention Rules

Re-read these on every reroute into Planning and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **Thinking Phase before architecture writes.** Do not write or rewrite `architecture.md` or `task.md` before the thinking phase closes.
2. **One question at a time during grilling.** Do not dump a batch of clarifying questions; expose assumptions iteratively.
3. **Decision-complete output.** The active phase must contain one selected path. Do not hand the developer an "A or B" choice.
4. **Stop and wait for explicit user approval before implementation.** Planning ends at approval, not at "docs look good".
5. **600-line cap on DevoSkill markdown artifacts** (`architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, `notes/*.md`). Split, demote to `notes/`, or move rationale to `project-changelog.md` before crossing the limit.
