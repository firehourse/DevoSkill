---
name: DevoSkill
description: A standardized prompt-based framework for document-driven software development and AI agent orchestration. Use when the user describes a project, says what they are trying to do, and needs the agent routed to planning, implementation, review, debugging, or capturing standing rules with minimal context loading.
---

# DevoSkill: Bootstrap-First Router

This is the entry point for DevoSkill.

Its job is to register the available routes, choose the current one, and reroute whenever the immediate next action changes.

It is not the place to preload implementation standards, planning templates, quality gates, or support modules "just in case".

## 0. Primary Modes
DevoSkill has five primary project-phase modes and one lightweight exception route. These are the routes available across the whole session.

- `Planning` -> `../devoskill-planning/SKILL.md`
  Use when the immediate next action is deciding scope, architecture, task shape, or rewriting docs.
- `Development` -> `../devoskill-development/SKILL.md`
  Use when the immediate next action is changing code for approved work.
- `Review` -> `../devoskill-review/SKILL.md`
  Use when the immediate next action is validating code against approved documents.
- `Debug/Performance` -> `../devoskill-performance/SKILL.md`
  Use when the immediate next action is diagnosing a measured failure, regression, or bottleneck.
- `Exception / Inquiry` -> `../devoskill-exception/SKILL.md`
  Use when the immediate next action is lightweight lookup, question answering, latest-info research, source verification, or problem clarification without entering a project phase yet.
- `Update` -> `../devoskill-update/SKILL.md`
  Use when the immediate next action is capturing a user-stated correction, style rule, or performance standard into custom skill protocols.

Reroute rule:
- when the current route no longer matches the immediate next action, stop and return to this router mindset
- do not wait for the user to remind you that the phase changed
- after entering a route, read that route file before going deeper
- `Exception / Inquiry` is intentionally lightweight: answer or clarify first, then reroute once the work becomes a real project phase

## 0. Bootstrap First
Before reading any workflow, template, protocol, or support skill, do this guard check first:

1. Check whether the canonical local mapping state already exists at `skills/devoskill/config/workspace-map.local.json`.
2. If it exists, treat workspace path resolution as already established. Do **not** load extra workspace-setup instructions just to reconfirm the same state.
3. If it does not exist, or the current task is explicitly about repairing `skilldocs`, `.devoskill`, or workspace mapping, load `../devoskill-workspace-setup/SKILL.md`.

Use workspace setup as a repair/bootstrap mode, not as default background reading.
Do not treat legacy mapping metadata as the current active-project selection when `.devoskill` or explicit user intent says otherwise.

## 1. Choose And Route
After bootstrap, choose exactly one current route before loading any sibling skill.

If the user only describes the project and desired next step in natural language, infer the route from that description. Do not wait for explicit skill names.
If more than one route seems plausible, pick the immediate next action rather than the broad project goal.

Once the current route is chosen, load only that route file.

Do not preload sibling skills, workflows, templates, quality gates, or support modules before routing.
After routing, let the chosen route file decide what to load next.

## 2. Router Constraints
- **Canonical Workspace Mapping State:** The only canonical local mapping path is `skills/devoskill/config/workspace-map.local.json`. Do not create or rely on duplicate local-state files elsewhere in the repo.
- **No Preload Rule:** Before mode classification is complete, do not read additional workflows, templates, quality rules, or support modules unless bootstrap repair requires them.

## 3. Support Modules
Support modules are phase-local and conditional.

- Do not load a support module because it exists.
- Load a support module only when the active phase skill explicitly calls for it.
- If a support module is not needed for the current step, leave it unread.
- Implementation strategy is not a primary route. For Go work, the Development, Review, Debug/Performance, and Go quality routes conditionally load the shared Go implementation mode protocol to choose high-performance or high-modularity rules inside the active phase.
- Rails maintenance strategy is also phase-local. For Ruby/Rails work, Development, Review, Debug/Performance, and Ruby quality routes conditionally load the shared Rails maintenance mode protocol to choose Conservative Rails Maintenance or Explicit Modernization inside the active phase.
