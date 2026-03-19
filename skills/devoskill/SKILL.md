---
name: DevoSkill
description: A standardized prompt-based framework for document-driven software development and AI agent orchestration. Use when the user describes a project, says what they are trying to do, and needs the agent routed to planning, implementation, review, or debugging with minimal context loading.
---

# DevoSkill: Core Principles

This is the entry point for DevoSkill. It defines the absolute minimum constraints and acts as a directory to load other specialized instructions when needed.

## Quick Start
- If the user says what project they are in and what they need next, route from that description instead of waiting for skill keywords.
- Use `../devoskill-planning/SKILL.md` when the user needs architecture, scope, task breakdown, or approval-ready planning artifacts. Planning always uses a grilling style to pressure-test the user’s request before documents are written.
- Use `../devoskill-development/SKILL.md` when the user wants implementation work on an already approved task.
- Use `../devoskill-review/SKILL.md` when the user wants validation, comparison against intended architecture, or drift checking.
- Use `../devoskill-performance/SKILL.md` when the user is chasing bottlenecks, failures, or measured runtime issues.

## 1. Global Constraints
- **Planning Document Limits:** Effective planning and note files (`architecture.md`, `task.md`, and files under `notes/`) should stay under 600 lines each. Split or trim them immediately if crossed.
- **Workspace Mapping State:** Before any file generation or planning, resolve the current workspace's `skilldocs` location from the local state file `config/workspace-map.local.json` when it exists. If it does not exist, dynamically derive the mapping, then write it back to that local file for later sessions.
- **Python Ecosystem:** If utilizing Python, `uv` is mandatory for dependency and script execution.
- **No Idle Summaries:** Maintain project state exclusively via file modifications in the mapped `skilldocs`.
- **Pre-Requisite Planning:** Do not write code without an explicit `task.md`.

## 2. Dynamic Workflow Routing
When presented with a user request, identify the appropriate phase and load the corresponding sibling skill first. Each sibling skill then points to the exact workflow and protocol documents required for that phase.

Route based on three things from the user's natural-language description:
1. **Project state**: new project, existing system, approved task, broken system, or uncertain situation
2. **Immediate intent**: plan, build, review, debug, or clarify
3. **Requested output**: architecture, `task.md`, code changes, discrepancy list, benchmark/debug result, or focused questions

Prefer the smallest skill that matches the request. Do not load extra modes "just in case."

Examples of natural routing:
- "I have project X and need a phased rollout plan" -> `../devoskill-planning/SKILL.md`
- "I have project X, task Y is approved, please implement it" -> `../devoskill-development/SKILL.md`
- "I changed project X, help me check whether it drifted from the plan" -> `../devoskill-review/SKILL.md`
- "Project X is slow or failing under load, help me find the bottleneck" -> `../devoskill-performance/SKILL.md`
- "I have project X and an idea, help me figure out what I'm missing" -> `../devoskill-planning/SKILL.md` using grilling questions before planning docs

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
- For planning-time user interrogation and assumption pressure-testing: Read `../devoskill-grill/SKILL.md` only as a support module inside planning
- For Subagent Orchestration (Planning, Developing): Read `protocols/subagent-orchestration.md`
