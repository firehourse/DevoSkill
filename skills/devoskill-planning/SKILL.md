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

## Load Order
1. If workspace mapping is missing or broken, read `../devoskill-workspace-setup/SKILL.md`; otherwise skip workspace setup.
2. Read `../devoskill/workflows/01-planning.md`
3. Read `../devoskill/protocols/thinking-phase.md`
4. Read `../devoskill-grill/SKILL.md` as the default interaction style for planning interviews
5. Read `../devoskill/protocols/study-surface.md` only when existing-system planning needs reusable repository, subsystem, flow, or architecture understanding
6. Read shared/company-level `../devoskill/protocols/custom-*.md` only when the current planning step matches the load conditions defined in `../devoskill/protocols/skill-evolution.md` Section 5
7. After classifying the request, read exactly one of:
   - `../devoskill/protocols/planning-greenfield.md`
   - `../devoskill/protocols/planning-existing.md`
   - `../devoskill/protocols/planning-hybrid.md`
8. If the project uses Go, read `../devoskill/protocols/go-implementation-mode.md`, `../devoskill/templates/design-go.md`, and `../devoskill/workflows/quality-go.md` before finalizing `design.md` or `task.md`
9. If the project uses Node.js or TypeScript, read `../devoskill/templates/design-node.md` and `../devoskill/workflows/quality-node.md` before finalizing `design.md` or `task.md`
10. If the project uses Python, read `../devoskill/templates/design-python.md` and `../devoskill/workflows/quality-python.md` before finalizing `design.md` or `task.md`
11. If the project uses Ruby or Rails, read `../devoskill/protocols/rails-maintenance-mode.md`, `../devoskill/templates/design-ruby.md`, and `../devoskill/workflows/quality-ruby.md` before finalizing `design.md` or `task.md`
12. If the work is project/domain-specific, load the matching project skill just-in-time based on repo/path context or explicit user intent instead of scanning DevoSkill shared custom protocols
13. If that project skill or knowledge surface exposes registry-based discovery, read `../devoskill/protocols/rule-registry-routing.md` and follow its `phase -> project/domain or knowledge surface -> registry -> current action -> concern` model

Do not read development, review, quality, or performance workflows from planning unless the work actually reroutes.

## Required Behavior
- Complete the Thinking Phase before writing or rewriting `architecture.md` or `task.md`.
- Plan by grilling the user one high-value question at a time until assumptions, constraints, and boundaries are explicit enough to write effective docs.
- Keep checking that the task is still in planning mode. If the user pivots to code changes, review, or runtime debugging, reroute instead of continuing to plan.
- Use the canonical workspace mapping state and `.devoskill` symlink rules only when they are actually needed.
- Keep planning output limited to the effective architecture, explicit contracts, and the active executable phase.
- Write planning documents in the user's language. Section headings may stay in English as structural anchors, but the body should match the user's language.
- Do not maintain planning state through conversational summaries. Persist effective state in `architecture.md`, `task.md`, `design.md`, `verification.md`, or `notes/` only when needed.
- Externalize harness behavior into durable natural-language artifacts: inputs, allowed read surface, stop conditions, verification contract, and writeback contract must be explicit in the planning docs rather than implied in chat.
- Use Study as the reusable reality-acquisition layer when planning needs broad existing-system understanding. Promote only change-specific facts from Study into the active planning surface.
- Include shared/company-level operational boundaries from custom protocols in planning docs when they affect execution, such as whether branch creation, commits, push, PR creation, or external system updates are allowed.
- Load project/domain rules from the matching skill when the plan depends on them; do not treat DevoSkill shared custom files as the default home for project-specific concerns.
- Pull stack-specific quality constraints forward into `design.md` when they affect naming, error boundaries, lifecycle behavior, test seams, or file/module structure. Do not defer those decisions entirely to the post-implementation quality gate.
- After planning documents are updated, stop and wait for explicit user approval before implementation begins.
