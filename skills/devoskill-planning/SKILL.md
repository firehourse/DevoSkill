---
name: devoskill-planning
description: Planning module for DevoSkill. Use when the task is architecture design, request analysis, task planning, or planning document generation. This mode grills the user by default to expose assumptions and missing constraints before writing planning docs.
---

# DevoSkill Planning

Use this skill when the current request is about planning rather than implementation.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Planning`.

If the work no longer matches planning, stop and return to the correct primary mode instead of continuing.

## Load Order
1. If workspace mapping is missing or broken, read `../devoskill-workspace-setup/SKILL.md`; otherwise skip workspace setup.
2. Read `../devoskill/workflows/01-planning.md`
3. Read `../devoskill/protocols/thinking-phase.md`
4. Read `../devoskill-grill/SKILL.md` as the default interaction style for planning interviews
5. After classifying the request, read exactly one of:
   - `../devoskill/protocols/planning-greenfield.md`
   - `../devoskill/protocols/planning-existing.md`
   - `../devoskill/protocols/planning-hybrid.md`

## Required Behavior
- Complete the Thinking Phase before writing or rewriting `architecture.md` or `task.md`.
- Plan by grilling the user one high-value question at a time until assumptions, constraints, and boundaries are explicit enough to write effective docs.
- Keep checking that the task is still in planning mode. If the user pivots to code changes, review, or runtime debugging, reroute instead of continuing to plan.
- Use the canonical workspace mapping state and `.devoskill` symlink rules only when they are actually needed.
- Keep planning output limited to the effective architecture, explicit contracts, and the active executable phase.
- Externalize harness behavior into durable natural-language artifacts: inputs, allowed read surface, stop conditions, verification contract, and writeback contract must be explicit in the planning docs rather than implied in chat.
- After planning documents are updated, stop and wait for explicit user approval before implementation begins.
