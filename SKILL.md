---
name: DevoSkill
description: A standardized prompt-based engine for document-driven software development.
---

# DevoSkill: Action-Based Execution Protocol

This guide defines the engineering standard. It is action-based rather than role-based, ensuring consistency regardless of the AI context or session state.

## Global Constraints (Hard Rules For All Actions)
1. **No Code without Specs:** You must refuse to write code if a `task.md` corresponding to the request does not exist.
2. **File Size Limit:** No single markdown or code file shall exceed 600 lines. If a file approaches this limit, immediately trigger a refactor or document split.
3. **No Redundant Summaries:** Do not output lengthy conversational summaries. Rely entirely on updating persistent files (`task.md`, `architecture.md`) to maintain state across sessions.
4. **Python Ecosystem:** When working with Python, you MUST use `uv` for environment setup, dependency management, and script execution.

## File Persistence Strategy (SkillDocs)
To prevent repository pollution and ensure state persistence across sessions, all planning documentation MUST be centralized.
- **Location:** All architecture and task files must be written to or read from a centralized location outside the project repository, generally: `<WORKSPACE_ROOT>/skilldocs/<Project_Name>/`.
- **Symlink Setup:** When starting development in a target project, automatically create a symbolic link (`ln -s <WORKSPACE_ROOT>/skilldocs/<Project_Name> .devoskill`) inside the active project directory, and add `.devoskill` to the `.gitignore`.

---

## Action: "When you are Planning or Architecting"

When the user asks to design a new feature, analyze an existing project, or create a project blueprint, follow these steps:

1. **Discover Context:**
   - Determine if this is a **New Project** or an **Existing Project**.
   - Ascertain the appropriate target `<SKILLDOCS_DIR>`.
2. **Handle Existing Projects:**
   - If the project exists in the workspace, scan the current codebase.
   - You MUST generate an **"As-Is vs To-Be Diagram"** (e.g., Mermaid workflow) highlighting the delta between the current execution flow and the proposed changes.
   - Wait for user approval on the "To-Be" specifications before proceeding.
3. **Define the Architecture:**
   - Output technical decisions, data flows, structures, and stack to `<SKILLDOCS_DIR>/architecture.md`. Use `DevoSkill/templates/architecture.md` (if available) as the standard structure.
4. **Deconstruct the Tasks:**
   - Translate the approved architecture into atomic, executable steps inside `<SKILLDOCS_DIR>/task.md`.
   - Specify exact file names, required functions, or algorithms.

---

## Action: "When you are Developing or Coding"

When the user requests to implement features based on a plan, follow these steps:

1. **Strict Context Alignment:**
   - Read the exact instructions from `<SKILLDOCS_DIR>/task.md` (or the local `.devoskill/task.md` symlink).
   - You are prohibited from unilaterally changing the architecture, scope, or design of the project without revisiting the Planning action.
2. **Environment Pre-flight:**
   - Ensure the `.devoskill` symlink exists locally. If not, generate the `ln -s` command and add to `.gitignore`.
   - Ensure you are utilizing `uv` if working in a Python stack.
3. **Execute and Update:**
   - Produce functional code adhering to the `< 600 lines` constraint.
   - Do not generate sprawling descriptive output text; perform file edits directly.

---

## Action: "When you are Reviewing or Validating"

When a development task is completed and a review is requested, follow these steps:

1. **Reconciliation:**
   - Read the source of truth (`<SKILLDOCS_DIR>/architecture.md` and `task.md`).
   - Reconcile actual source code modifications against these documents.
2. **Validation Checks:**
   - Confirm that the developer action did not deviate from the workflow.
   - Confirm no unauthorized third-party dependencies were introduced.
   - Confirm no file exceeds the 600-line limit.
3. **Actionable Feedback:**
   - Do not re-write or commit code directly during a review action. Provide actionable feedback to the user (e.g., "File X handles business logic and DB communication. Please refactor this to adhere to the API Gateway model defined in `architecture.md`").
