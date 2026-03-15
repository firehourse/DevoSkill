---
name: DevoSkill
description: A standardized prompt-based framework for document-driven software development and AI agent orchestration.
---

# DevoSkill: Core Principles

This is the entry point for DevoSkill. It defines the absolute minimum constraints and acts as a directory to load other specialized instructions when needed.

## 1. Global Constraints
- **File Limits:** No single file (code or markdown) shall exceed 600 lines. Refactor immediately if crossed.
- **Workspace Registry:** Before any file generation or planning, you MUST read `config/workspace-registry.md` to dynamically map the current workspace to its designated `skilldocs` directory.
- **Python Ecosystem:** If utilizing Python, `uv` is mandatory for dependency and script execution.
- **No Idle Summaries:** Maintain project state exclusively via file modifications in the mapped `skilldocs`.
- **Pre-Requisite Planning:** Do not write code without an explicit `task.md`.

## 2. Dynamic Workflow Routing
When presented with a user request, identify the appropriate phase and read the corresponding documentation to proceed.

- **For New Project Planning / Architecture Design:**
  - Read `workflows/01-planning.md`
- **For Executing Development Tasks:**
  - Read `workflows/02-development.md`
- **For Diagnostics, Profiling, or Performance Bottlenecks:**
  - Read `workflows/04-performance-debugging.md`
- **For Reviewing Code against Architecture:**
  - Read `workflows/03-review.md`

## 3. Subagent Orchestration & Environment
To properly isolate workspace paths, map the directories for document persistence (`skilldocs`), and interface with subagents:
- For Workspace/Directories Configuration (`skilldocs`, `.devoskill`): Read `protocols/workspace-setup.md`
- For Subagent Orchestration (Planning, Developing): Read `protocols/subagent-orchestration.md`
