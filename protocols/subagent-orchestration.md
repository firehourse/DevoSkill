# Subagent Orchestration & Interaction

This protocol defines how a primary Agent should delegate tasks to, context-switch with, or simulate Subagents within the DevoSkill environment. This ensures clarity, precise context boundary management, and strict separation of concerns.

## 1. Interaction Primitives

When invoking a Subagent (e.g., `planner`, `developer`, `reviewer`), you must:
1. **Explicitly Specify the Target Files:** A Subagent only needs the *exact* subset of documents relevant to its task. Do not pass the entire project space.
2. **Define the Expected Output:** The Subagent must return discrete file modifications (`task.md`, `architecture.md`, `src/*.py`)—not a conversational summary.
3. **Assert the 600-line Rule:** Every Subagent call implicitly carries the `< 600 lines per file` global constraint.

## 2. Core Subagent Definitions & Required Contexts

### The Planner Subagent
**Role:** Generates software blueprints and atomic task lists (`architecture.md`, `task.md`).
**Required Inputs:**
- User intent/specifications.
- If existing project: `As-Is vs To-Be Diagram` of current flow vs requested delta.
- Standard Template: `DevoSkill/templates/architecture.md`.

### The Developer Subagent
**Role:** Executes code line-by-line exactly as dictated by the pre-approved `task.md`.
**Required Inputs:**
- The finalized `task.md`.
- Ensure `.devoskill/` symlink exists to the centralized `skilldocs/<project_name>` folder.
- *Strict Rule:* The Developer does not alter the architecture. If architecture changes are required, it must halt and return control to the Orchestrator/Planner.

### The Reviewer Subagent
**Role:** Reviews the git diffs against the `architecture.md` to ensure structural alignment.
**Required Inputs:**
- The updated source code (or diffs).
- The `architecture.md` and `task.md` references.

## 3. Session Isolation Mechanism
When communicating with the user or transitioning between phases, explicitly state:
*"Delegating to [Subagent Name] with context [File List]. Output expects [File Updates]."*
