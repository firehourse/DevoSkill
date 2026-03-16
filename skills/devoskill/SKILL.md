---
name: DevoSkill
description: A standardized prompt-based framework for document-driven software development and AI agent orchestration.
---

# DevoSkill: Core Principles

This is the entry point for DevoSkill. It defines the absolute minimum constraints and acts as a directory to load other specialized instructions when needed.

## 1. Global Constraints
- **Planning Document Limits:** Effective planning and note files (`architecture.md`, `task.md`, and files under `notes/`) should stay under 600 lines each. Split or trim them immediately if crossed.
- **Workspace Mapping State:** Before any file generation or planning, resolve the current workspace's `skilldocs` location from the local state file `config/workspace-map.local.json` when it exists. If it does not exist, dynamically derive the mapping, then write it back to that local file for later sessions.
- **Python Ecosystem:** If utilizing Python, `uv` is mandatory for dependency and script execution.
- **No Idle Summaries:** Maintain project state exclusively via file modifications in the mapped `skilldocs`.
- **Pre-Requisite Planning:** Do not write code without an explicit `task.md`.

## 2. Dynamic Workflow Routing
When presented with a user request, identify the appropriate phase and load the corresponding sibling skill first. Each sibling skill then points to the exact workflow and protocol documents required for that phase.

- **For New Project Planning / Architecture Design:**
  - Read `../devoskill-planning/SKILL.md`
- **For Executing Development Tasks:**
  - Read `../devoskill-development/SKILL.md`
- **For Maintaining, Refactoring, or Modifying Existing Code:**
  - Read `../devoskill-development/SKILL.md`
- **For Diagnostics, Profiling, or Performance Bottlenecks:**
  - Read `../devoskill-performance/SKILL.md`
- **For Reviewing Code against Architecture:**
  - Read `../devoskill-review/SKILL.md`

## 3. Shared Support Modules
Load these support skills when the phase requires them:
- For Workspace/Directories Configuration (`skilldocs`, `.devoskill`): Read `../devoskill-workspace-setup/SKILL.md`
- For Thinking Phase classification and boundary confirmation: Read `../devoskill-thinking-phase/SKILL.md`
- For Subagent Orchestration (Planning, Developing): Read `protocols/subagent-orchestration.md`
