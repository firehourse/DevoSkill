---
name: devoskill-workspace-setup
description: Workspace setup module for DevoSkill. Use when configuring skilldocs paths, project folders, or .devoskill symlinks.
---

# DevoSkill Workspace Setup

Use this skill when initializing or repairing the SkillDocs layout for a workspace or project.

## Load Order
1. Read `../devoskill/config/workspace-map.example.json`
2. Read `../devoskill/protocols/workspace-setup.md`

## Required Behavior
- Resolve the mapped SkillDocs base path from `config/workspace-map.local.json` when present.
- If no local mapping exists, derive it from the current workspace and persist it into the local mapping file for future sessions.
- Derive or confirm a concrete project folder under that base path.
- Reuse existing project folders when present instead of re-bootstrapping blindly.
- Ensure the local `.devoskill` symlink points at the project-specific SkillDocs directory.
