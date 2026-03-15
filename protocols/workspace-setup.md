# Workspace Setup & Directory Rules

To prevent repository pollution and maintain state across different Developer and Reviewer sessions, all planning documentation MUST be centralized and accessed via a strict set of rules.

## 1. The SkillDocs Repository
All architecture and task files must be written to or read from a centralized location outside the target project's repository.
- Location: The global directory is dynamically determined based on the user's workspace root, generally: `<WORKSPACE_ROOT>/skilldocs/<Project_Name>/`.
- Persistence: AI Agents NEVER generate rambling conversational summaries. The source of truth across sessions is strictly the state of the `.md` documents within the `<Project_Name>` folder.

## 2. The Local `.devoskill` Symlink
During active development, it is highly inconvenient to navigate back and forth to an external directory. We solve this via local symlinking.
- Initial Setup: When starting development in a target project, the AI (or User) should create a symbolic link targeting the centralized documentation.
  Command: `ln -s <WORKSPACE_ROOT>/skilldocs/<Project_Name> .devoskill`
- Git Rules: Once created, append `.devoskill` to the target project's `.gitignore` file to ensure the symlink is never tracked by git.

## 3. Creating a New Project Profile
When an AI transitions into Planning mode for a new project:
1. Identify the project name and the workspace root.
2. `mkdir -p <WORKSPACE_ROOT>/skilldocs/<Project_Name>`
3. Bootstrap `task.md` and `architecture.md` according to the core `DevoSkill/templates/`.
