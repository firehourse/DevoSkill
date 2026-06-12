---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill Development

## Entry Gate (check before anything else)

**STOP. Do not proceed until both conditions are met:**

1. A `task.md` exists in the active project skilldocs.
2. The user has explicitly approved implementation in this session, or `task.md` has an active phase with approved status.

If either condition is not met:
- Do not load any workflow or read any file below.
- Route back to `Planning` and tell the user exactly what is missing (no task.md / no explicit approval).

---

Use this skill only after planning exists and the user has explicitly approved implementation.
Do not use it for architecture discovery, compliance-only validation, or benchmark-first debugging.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Development`.

If the work no longer matches development, stop and reroute instead of continuing.

## Execution Order — Just-In-Time Loading

Read each file immediately before the step that depends on it. Do not pre-load every file at phase entry; see doctrine § 2.

### Step D1 — Workspace bootstrap (only if broken)

If workspace mapping is missing or broken, read `{DEVOSKILL_ROOT}/skills/devoskill-workspace-setup/SKILL.md` first and repair it. Otherwise skip.

### Step D2 — Enter the development workflow

Before opening the active phase in `task.md`, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/02-development.md`. This file owns the development workflow contract.

### Step D3 — Load engineering standards for the touched stack

Before writing or modifying any code, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/engineering-standards.md` — focus on the language-specific section matching the implementation stack.

### Step D4 — Load language-specific implementation mode (conditional)

Before choosing abstractions or package boundaries:

- If Go code is in scope, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/go-implementation-mode.md`.
- If Ruby/Rails code is in scope, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rails-maintenance-mode.md` before changing style, callbacks, service boundaries, or lifecycle behavior.

### Step D5 — Open the active phase

Load only the active phase in `task.md` and the effective architecture sections it references. Do not load past phases or non-referenced architecture sections.

### Step D6 — Operational gates (conditional)

Before any code step that may touch operational boundaries (push, PR creation, external system updates), read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/operational-gates.md`.

### Step D7 — Project/domain skill (conditional)

If the work is project/domain-specific (e.g. KKTIX), load the matching project skill just-in-time based on repo/path context or explicit user intent. If that project skill exposes registry-based discovery, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rule-registry-routing.md`.

### Step D8 — Before declaring the phase complete

Before writing back to `task.md`, reroute through `{DEVOSKILL_ROOT}/skills/devoskill-quality/SKILL.md`. Quality is a pre-completion gate, not optional.

---

Do not read planning, review, or performance workflows from development unless the task actually reroutes.

## Required Behavior

- Do not begin code changes without explicit implementation approval.
- Keep checking that the work is still active implementation. If the user asks for planning, drift validation, or performance diagnosis, reroute.
- Follow the active phase in `task.md` linearly.
- Respect human handoff points and do not guess through missing schema, contracts, or credentials.
- For existing code, obey maintenance constraints, style conformance rules, and anti-over-abstraction rules.
- Do not write code without an explicit `task.md`.
- Treat `design.md`, `task.md`, verification artifacts, and repository state as a single implementation contract. If they diverge, stop and reconcile instead of coding through the inconsistency.
- Load the relevant project skill when the implementation depends on domain-specific rules.

---

## Strongest-Attention Rules

Re-read these on every reroute into Development and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **No code without `task.md` + explicit approval.** The Entry Gate at the top of this file is the hard contract.
2. **Active phase is the unit of work.** Follow it linearly; do not jump ahead.
3. **Design + task + repo state are one contract.** If any two diverge, stop and reconcile in docs before continuing.
4. **Stop at human handoff boundaries** — missing schema, credentials, production state, sensitive flags. Do not guess through.
5. **Quality gate is mandatory before writeback.** Do not mark a phase complete until `devoskill-quality` has run and any failures are fixed.
