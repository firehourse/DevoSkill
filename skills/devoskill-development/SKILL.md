---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill Development

## Entry Gate (check before anything else)

**STOP. Do not proceed until all conditions are met:**

1. A `task.md` exists in the active project skilldocs.
2. Its active goal matches the user's current request and the selected repository/worktree; an old approved task for another feature does not qualify.
3. The user has explicitly approved implementation in this session, or `task.md` has an active phase with approved status.

If any condition is not met:
- Do not load any workflow or read any file below.
- Route back to `Planning` and tell the user exactly what is missing (no task.md / stale or mismatched task / no explicit approval).

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

### Step D3 — Establish Git isolation

Before the first code or tracked-file mutation in a Git repository, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/git-worktree-isolation.md` and create or resume the task's dedicated worktree. Read-only work does not require one.

### Step D4 — Load engineering standards for the touched stack

Before writing or modifying any code, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/engineering-standards.md` — focus on the language-specific section matching the implementation stack.

### Step D5 — Load language-specific implementation mode (conditional)

Before choosing abstractions or package boundaries:

- If Go code is in scope, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/go-implementation-mode.md`.
- If Ruby/Rails code is in scope, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rails-maintenance-mode.md` before changing style, callbacks, service boundaries, or lifecycle behavior.

### Step D6 — Open the active phase

Load only the active phase in `task.md` and the effective architecture sections it references. Do not load past phases or non-referenced architecture sections.

### Step D7 — Operational gates (conditional)

Before any code step that may touch operational boundaries (push, PR creation, external system updates), read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/operational-gates.md`.

### Step D8 — Project/domain skill (conditional)

If the work is project/domain-specific, load the matching project skill just-in-time based on repo/path context or explicit user intent. If that project skill exposes registry-based discovery, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rule-registry-routing.md`.

### Step D9 — Conformance checkpoint, quality gate, closeout (before declaring complete)

Plan conformance is the Developer's own responsibility — Review no longer matches the diff against the plan. Run, in order, before declaring the phase ready for review:

1. **Plan Conformance Checkpoint** (`workflows/02-development.md` Step 6) — also run it periodically mid-implementation, not only at the end, so drift is caught early. Fix scope bleed, surgical-diff, style, architecture alignment, phase integrity, and contract-completeness findings yourself.
2. **Quality gate** — reroute through `{DEVOSKILL_ROOT}/skills/devoskill-quality/SKILL.md`. Not optional.
3. **Closeout** — run `{DEVOSKILL_ROOT}/skills/devoskill/workflows/closeout-review.md`: doc-sync, evidence, task completion, hygiene, plus a decoupled re-verify of scope bleed / architecture drift. Resolve its MUST findings before writeback.

---

Do not read planning, review, or performance workflows from development unless the task actually reroutes.

## Required Behavior

- Do not begin code changes without explicit implementation approval.
- Run code-changing work in a dedicated task worktree; keep the primary checkout untouched.
- Keep checking that the work is still active implementation. If the user asks for planning, drift validation, or performance diagnosis, reroute.
- Treat the active phase as the outcome and boundary contract, not an immutable implementation script. Reconcile it against repository reality at every new session and meaningful discovery.
- Respect human handoff points and do not guess through missing schema, contracts, or credentials.
- For existing code, preserve external contracts and project conventions while improving the touched design when a focused refactor makes it simpler, more modular, more readable, or easier to test.
- Do not write code without an explicit `task.md`.
- Treat `design.md`, `task.md`, verification artifacts, and repository state as one living contract. Reconcile local implementation-detail drift in the documents and continue; reroute only when the better path changes approved behavior, boundaries, dependencies, risk, or scope.
- Load the relevant project skill when the implementation depends on domain-specific rules.

---

## Strongest-Attention Rules

Re-read these on every reroute into Development and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **No code without a matching `task.md` + explicit approval.** A stale task for another feature is not authority to continue it.
2. **Worktree before mutation.** Create or resume the task's dedicated worktree and leave the primary checkout untouched.
3. **The plan defines intent and constraints, not the prettiest code shape.** Re-anchor to current code, choose the best in-contract implementation, and write it back.
4. **Design + task + repo state are one living contract.** Reconcile implementation-detail drift; stop only for changes to approved behavior, boundaries, dependencies, risk, or scope.
5. **Stop at human handoff boundaries** — missing schema, credentials, production state, sensitive flags. Do not guess through.
6. **Conformance → quality → closeout, all mandatory before writeback.** Plan conformance is your self-check (Review won't do it); run it mid-implementation and at completion. Do not mark a phase complete until the conformance checkpoint, `devoskill-quality`, and `closeout-review` have run and their MUST findings are fixed.
