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

## Load Order
1. If workspace mapping is missing or broken, read `../devoskill-workspace-setup/SKILL.md`; otherwise skip workspace setup.
2. Read `../devoskill/workflows/04-performance-debugging.md`
3. Load only the effective architecture and active task sections needed for the measured bottleneck
4. If Go code is in scope, read `../devoskill/protocols/go-implementation-mode.md` and default measured hot paths to high-performance mode unless the architecture explicitly chooses modularity
5. If Ruby/Rails code is in scope, read `../devoskill/protocols/rails-maintenance-mode.md` before changing transaction, callback, cache, job, or integration lifecycle behavior
6. Read shared/company-level `../devoskill/protocols/custom-*.md` only when the current debug/performance step matches the load conditions defined in `../devoskill/protocols/skill-evolution.md` Section 5
7. If the work is project/domain-specific, load the matching project skill just-in-time based on repo/path context or explicit user intent
8. If that project skill exposes registry-based discovery, read `../devoskill/protocols/rule-registry-routing.md` and follow its `phase -> project/domain -> registry -> current action -> concern` model

Do not read planning, development, or review workflows from debug/performance unless the task actually reroutes.

## Required Behavior
- Establish measurable baselines before proposing optimizations.
- Keep checking that the task is still debugging/performance work. If the user actually needs planning, coding, or review, reroute.
- Persist only effective benchmark and optimization changes back into planning docs.
- If the optimization changes architecture boundaries, return to planning before implementation continues.
