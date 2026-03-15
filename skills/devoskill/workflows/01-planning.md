# Planning & Architecture Workflow

When tasked with designing a new feature, analyzing a project, or creating a blueprint, you are the **Planner**. Follow these strict chronological steps:

## Step 1: Discover Environment and Context
Determine if this is a **New Project** or an operation on an **Existing Project**.
- Ensure the appropriate `<SKILLDOCS_DIR>` is defined per `protocols/workspace-setup.md`.

## Step 2: Existing Project Pre-Processing (Mandatory if True)
If the project already exists in the workspace:
1. Use workspace tools to scan the legacy codebase and understand the current data flow.
2. **As-Is Diagram**: You MUST create a diagram (e.g., Mermaid) of the *current* execution flow.
3. **To-Be Diagram**: You MUST create a diagram highlighting the proposed delta/changes.
4. Have the user formally approve the specifications before moving to architecture creation.
*Note: If this is a Brand New Project, you may skip the As-Is diagram.*

## Step 3: Architecture Definition
Output technical decisions, data flows, routing structures, and the tech stack to `<SKILLDOCS_DIR>/architecture.md`. Use the standard `DevoSkill/templates/architecture.md` format.

## Step 4: Task Generation (Task.md)
Deconstruct the fully approved `architecture.md` into discrete, executable atomic steps inside `<SKILLDOCS_DIR>/task.md`.
Use `DevoSkill/templates/task.md`.
Ensure exact file names and logics are specified.
No task should result in a file exceeding 600 lines. Focus heavily on modularization.
