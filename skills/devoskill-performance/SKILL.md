---
name: devoskill-performance
description: Performance and debugging module for DevoSkill. Use for diagnostics, profiling, baselining, and optimization planning.
---

# DevoSkill Performance

Use this skill when the task is debugging performance or establishing benchmark-driven optimization work.
Do not use it for speculative architecture planning, approved feature implementation, or compliance-only review.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Debug/Performance`.

If the work no longer matches debugging/performance, stop and reroute instead of continuing.

## Execution Order — Just-In-Time Loading

Read each file immediately before the step that depends on it. Do not pre-load every file at phase entry; see doctrine § 2.

### Step PF1 — Workspace bootstrap (only if broken)

If workspace mapping is missing or broken, read `{DEVOSKILL_ROOT}/skills/devoskill-workspace-setup/SKILL.md` first and repair it. Otherwise skip.

### Step PF2 — Enter the performance workflow

Before measuring or proposing optimizations, read `{DEVOSKILL_ROOT}/skills/devoskill/workflows/04-performance-debugging.md`. This file owns the diagnose-baseline-optimize loop.

### Step PF3 — Anchor against the measured bottleneck

Load only the effective architecture and active task sections needed for the measured bottleneck. Do not load unrelated subsystems just because the project is large.

### Step PF4 — Language-specific lifecycle constraints (conditional)

Just before changing any code, read:

- Go: `{DEVOSKILL_ROOT}/skills/devoskill/protocols/go-implementation-mode.md`. Default measured hot paths to high-performance mode unless the architecture explicitly chooses modularity.
- Ruby / Rails: `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rails-maintenance-mode.md` before changing transaction, callback, cache, job, or integration lifecycle behavior.

### Step PF5 — Operational gates (conditional)

Before any optimization step that may touch operational boundaries (push, PR creation, external system updates), read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/operational-gates.md`.

### Step PF6 — Project/domain skill (conditional)

If the work is project/domain-specific (e.g. KKTIX), load the matching project skill just-in-time based on repo/path context or explicit user intent. If that project skill exposes registry-based discovery, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/rule-registry-routing.md`.

---

Do not read planning, development, or review workflows from debug/performance unless the task actually reroutes.

## Required Behavior

- Establish measurable baselines before proposing optimizations.
- Keep checking that the task is still debugging/performance work. If the user actually needs planning, coding, or review, reroute.
- Persist only effective benchmark and optimization changes back into planning docs.
- If the optimization changes architecture boundaries, return to planning before implementation continues.

---

## Strongest-Attention Rules

Re-read these on every reroute into Debug/Performance and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **No optimization without a measured baseline.** Reproduce the failure / measure the bottleneck before proposing a fix.
2. **Architecture-changing optimizations reroute to Planning.** If the fix crosses an architectural boundary, stop and re-plan.
3. **Reroute if the actual need is not perf work.** Users sometimes describe a coding or review need as "it's slow". Confirm before staying in this route.
4. **Persist effective changes back into planning docs.** Benchmark numbers and adopted optimizations belong in `verification.md` / `architecture.md`, not just chat.
