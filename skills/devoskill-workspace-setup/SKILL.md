---
name: devoskill-workspace-setup
description: Workspace setup module for DevoSkill. Use when configuring skilldocs paths, project folders, or .devoskill symlinks.
---

# DevoSkill Workspace Setup

Use this skill when initializing or repairing the SkillDocs layout for a workspace or project.
Do not use it as background reading during normal planning, development, review, or debugging.

Only use this skill when the canonical mapping state is missing or the task is explicitly about workspace setup. If `skills/devoskill/config/workspace-map.local.json` already exists and the task is not a workspace repair, return to the active work mode instead of reading more setup material.

## Load Order
1. Read `../devoskill/config/workspace-map.example.json`
2. Read `../devoskill/protocols/workspace-setup.md`

Do not read planning, development, review, performance, or quality workflows from workspace setup unless the task reroutes after repair.

## Required Behavior
- Resolve the mapped SkillDocs base path from `skills/devoskill/config/workspace-map.local.json` when present.
- If no local mapping exists, derive it from the current workspace and persist it into the canonical local mapping file for future sessions.
- If `.devoskill` already points to a valid SkillDocs project, treat that as enough to derive session-local base-path state even before persistence succeeds.
- Resolve the active project using explicit user intent first, then `.devoskill`, then other local evidence.
- Derive or confirm a concrete project folder under the mapped base path.
- Reuse existing project folders when present instead of re-bootstrapping blindly.
- Ensure the local `.devoskill` symlink points at the project-specific SkillDocs directory.
- Remove or ignore duplicate local-state files outside the canonical path instead of treating them as valid alternatives.
- Keep workspace setup focused on location, mapping, and symlink correctness. It does not own planning decisions or execution rules.
- If mapping metadata and `.devoskill` drift, treat that as repair work. Do not silently switch the active project just because legacy mapping metadata disagrees.
- If writing the canonical mapping file fails, do not say bootstrap persistence succeeded. Report the failure and continue only with clearly labeled session-local derived state if routing can still proceed safely.
