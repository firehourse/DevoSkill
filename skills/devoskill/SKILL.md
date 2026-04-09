---
name: DevoSkill
description: A standardized prompt-based framework for document-driven software development and AI agent orchestration. Use when the user describes a project, says what they are trying to do, and needs the agent routed to planning, implementation, review, or debugging with minimal context loading.
---

# DevoSkill: Bootstrap-First Router

This is the entry point for DevoSkill. Its job is not to teach every rule up front. Its job is to:
1. resolve bootstrap state early,
2. classify the current work mode,
3. load only the smallest matching skill,
4. avoid loading unrelated instruction sets.

## 0. Bootstrap First
Before reading any heavy workflow or support skill, do this guard check first:

1. Check whether the canonical local mapping state already exists at `skills/devoskill/config/workspace-map.local.json`.
2. If it exists, treat workspace path resolution as already established. Do **not** load extra workspace-setup instructions just to reconfirm the same state.
3. If it does not exist, or the current task is explicitly about repairing `skilldocs`, `.devoskill`, or workspace mapping, load `../devoskill-workspace-setup/SKILL.md`.

Use workspace setup as a repair/bootstrap mode, not as default background reading.

## 1. Classify Work Mode
After the bootstrap check, classify the user's request into exactly one primary mode before loading any sibling skill:

- `Planning`: define architecture, clarify scope, split work, write or rewrite `architecture.md` / `task.md`, or pressure-test assumptions
- `Development`: implement an already approved task, modify code, or execute a planned change
- `Review`: compare implementation against architecture/task contracts, inspect drift, or perform code review/compliance review
- `Debug/Performance`: investigate failures, regressions, bottlenecks, baselines, or measured runtime issues

If the user only describes the project and desired next step in natural language, infer the mode from that description. Do not wait for explicit skill names.

## 2. Route By Mode
Once a primary mode is chosen, load only the matching sibling skill:

- `Planning` -> `../devoskill-planning/SKILL.md`
- `Development` -> `../devoskill-development/SKILL.md`
- `Review` -> `../devoskill-review/SKILL.md`
- `Debug/Performance` -> `../devoskill-performance/SKILL.md`

Do not preload quality, grill, workspace setup, or other support skills unless the chosen mode explicitly requires them.

## 3. Stay Phase-Aware While Working
After loading a mode-specific skill, keep checking whether the current work still matches that mode.

- If you discover you are actually planning, stop loading development/review details and switch to `Planning`.
- If you discover implementation is approved and the user now wants code changes, switch to `Development`.
- If you discover the request is validation-only, switch to `Review`.
- If you discover the issue is measured failure/bottleneck work, switch to `Debug/Performance`.

Do not continue under the wrong phase just because you already loaded one skill.

## 4. Global Constraints
- **Planning Document Limits:** Effective planning and note files (`architecture.md`, `task.md`, and files under `notes/`) should stay under 600 lines each. Split or trim them immediately if crossed.
- **Canonical Workspace Mapping State:** The only canonical local mapping path is `skills/devoskill/config/workspace-map.local.json`. Do not create or rely on duplicate local-state files elsewhere in the repo.
- **Python Ecosystem:** See `templates/design-python.md` for all Python/uv rules.
- **No Idle Summaries:** Maintain project state exclusively via file modifications in the mapped `skilldocs`.
- **Explicit Contracts:** Treat `architecture.md`, `task.md`, `design.md`, and any required verification artifact as an executable harness contract. Do not treat them as loose narrative notes.
- **Durable Evidence:** Verification claims must be backed by durable artifacts in `skilldocs` or directly inspectable repository state. Avoid status lines that only say "verified" with no checkable surface.
- **Pre-Requisite Planning:** Do not write code without an explicit `task.md`.
- **Engineering Standards:** All code must conform to `workflows/engineering-standards.md`. The minimum required layer structure is Router → Controller → Service → Repository. For Node.js: interfaces and enums in `types/`, no bare string constants in business logic, helpers extracted to `util/`.

## 5. Support Modules
Support modules are phase-local, not global defaults:

- `../devoskill-workspace-setup/SKILL.md`: only when bootstrap state is missing or workspace setup is the task
- `../devoskill-thinking-phase/SKILL.md`: only inside planning when the request still needs classification and boundary confirmation
- `../devoskill-grill/SKILL.md`: only inside planning as the interrogation style
- `../devoskill-quality/SKILL.md`: only as a pre-completion gate at the end of implementation
- `../devoskill-quality-go/SKILL.md`, `../devoskill-quality-node/SKILL.md`: only when quality is running and those languages are present
- `protocols/subagent-orchestration.md`: only when planning or development actually delegates work
