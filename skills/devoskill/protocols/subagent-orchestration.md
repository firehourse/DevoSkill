# Subagent Orchestration & Interaction

This protocol defines how a primary Agent should delegate tasks to, context-switch with, or simulate Subagents within the DevoSkill environment. This ensures clarity, precise context boundary management, and strict separation of concerns.

## 1. Interaction Primitives

When invoking a Subagent (e.g., `planner`, `developer`, `reviewer`), you must:
1. **Explicitly Specify the Target Files:** A Subagent only needs the *exact* subset of documents relevant to its task. Do not pass the entire project space.
2. **Define the Expected Output:** The Subagent must return discrete file modifications (`task.md`, `architecture.md`, `src/*.py`)—not a conversational summary.
3. **Assert the Planning Surface Limit:** Every Subagent call implicitly carries the `< 600 lines per effective DevoSkill markdown file` constraint for `architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, project-root `project-changelog.md`, and loaded notes. This constraint is for documentation only, not implementation source files.
4. **Pass Only Effective Planning Context:** Default context is the active phase in `task.md`, the effective sections of `architecture.md`, and any directly required code or contracts. Do not pass project `project-changelog.md` unless the task explicitly requires change rationale.
5. **Respect Human Handoffs:** If schema, credentials, production state, or sensitive operations depend on the user, the subagent must stop at that boundary.

## 2. Core Subagent Definitions & Required Contexts

### The Planner Subagent
**Role:** Generates effective architecture and active task plans (`architecture.md`, `task.md`).
**Required Inputs:**
- User intent/specifications.
- Thinking Phase classification.
- If existing or hybrid project: current reality and allowed delta.
- Standard Template: `DevoSkill/templates/architecture.md`.

### The Developer Subagent
**Role:** Executes code line-by-line exactly as dictated by the pre-approved `task.md`.
**Required Inputs:**
- The active phase in `task.md`.
- The effective architecture sections referenced by that phase.
- Ensure the project root's `.devoskill/` symlink exists and points to `<workspace_path>/docs/<project>`.
- *Strict Rule:* The Developer does not alter the architecture. If architecture changes are required, it must halt and return control to the Orchestrator/Planner.

### The Reviewer Subagent
**Role:** Reviews the git diffs against the effective `architecture.md` and active `task.md` to ensure structural alignment.
**Required Inputs:**
- The updated source code (or diffs).
- The effective architecture sections.
- The active task phase.

## 3. Session Isolation Mechanism
When communicating with the user or transitioning between phases, explicitly state:
*"Delegating to [Subagent Name] with context [File List]. Output expects [File Updates]."*

## 4. Context Budget Rule
The orchestrator is responsible for preventing context explosion.

- Prefer passing file excerpts, phase summaries, and specific interfaces over entire repositories.
- Prefer the current phase over all phases.
- Prefer effective architecture over `project-changelog.md`.
- If a subagent needs more context, expand narrowly and explicitly instead of sending everything.
