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
4. If any `../devoskill/protocols/custom-*.md` files exist, read them — they contain user-captured standing rules that apply to this session

Do not read planning, development, or review workflows from debug/performance unless the task actually reroutes.

## Required Behavior
- Establish measurable baselines before proposing optimizations.
- Keep checking that the task is still debugging/performance work. If the user actually needs planning, coding, or review, reroute.
- Persist only effective benchmark and optimization changes back into planning docs.
- If the optimization changes architecture boundaries, return to planning before implementation continues.
