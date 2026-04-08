---
name: devoskill-planning
description: Planning module for DevoSkill. Use when the task is architecture design, request analysis, task planning, or planning document generation. This mode grills the user by default to expose assumptions and missing constraints before writing planning docs.
---

# DevoSkill Planning

Use this skill when the current request is about planning rather than implementation.

## Load Order
1. Read `../devoskill/protocols/workspace-setup.md`
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
- Use the local workspace mapping state and `.devoskill` symlink rules.
- Keep planning output limited to the effective architecture, explicit contracts, and the active executable phase.
- Externalize harness behavior into durable natural-language artifacts: inputs, allowed read surface, stop conditions, verification contract, and writeback contract must be explicit in the planning docs rather than implied in chat.
- After planning documents are updated, stop and wait for explicit user approval before implementation begins.
