# Workspace Setup & Directory Rules

To prevent repository pollution and maintain state across different Developer and Reviewer sessions, all planning documentation MUST be centralized and accessed via a strict set of rules.

## 1. The SkillDocs Repository & Registry
All architecture and task files must be written to or read from a centralized location outside the target project's repository.
- **Location Mapping**: Since DevoSkill may be used across multiple workspaces on the same machine, the global directory is dynamically determined. You MUST read `config/workspace-registry.md` to map the current workspace to its designated `skilldocs` storage path.
- **Persistence**: AI Agents NEVER generate rambling conversational summaries. The source of truth across sessions is strictly the state of the `.md` documents within the `skilldocs/<Project_Name>` folder.
- **History Location**: If non-default history, decision notes, or abandoned planning artifacts must be preserved, store them under `skilldocs/<Project_Name>/notes/`. Do not mix them into the default planning surface.
- **Project Folder Rule**: The mapped registry path is the base SkillDocs root, not the final project folder. The agent MUST derive or confirm a concrete `<Project_Name>` and work inside `<MAPPED_SKILLDOCS_PATH>/<Project_Name>`.

## 2. The Local `.devoskill` Symlink
During active development, it is highly inconvenient to navigate back and forth to an external directory. We solve this via local symlinking.
- **Initial Setup**: When starting development in a target project, the AI (or User) should create a symbolic link targeting the centralized documentation.
  Command: `ln -s <MAPPED_SKILLDOCS_PATH>/<Project_Name> .devoskill`
- **Git Rules**: Once created, append `.devoskill` to the target project's `.gitignore` file to ensure the symlink is never tracked by git.

## 3. Creating a New Project Profile
When an AI transitions into Planning mode for a new project:
1. Identify the project name and the workspace root.
   - Default to the repository or target folder name if the user does not provide a better project name.
   - If multiple candidate project names exist, ask the user instead of guessing.
2. Cross-reference `config/workspace-registry.md`. If the current workspace is not listed, ask the user for a path, add it to the registry table, and commit the update to DevoSkill.
3. Ensure the mapped base directory exists first, then execute `mkdir -p <MAPPED_SKILLDOCS_PATH>/<Project_Name>`.
4. If `<MAPPED_SKILLDOCS_PATH>/<Project_Name>` already exists, reuse it and update only the effective planning files instead of re-bootstrapping blindly.
5. Bootstrap `task.md` and `architecture.md` according to the core `DevoSkill/templates/`.
6. Create or refresh the local `.devoskill` symlink to point at `<MAPPED_SKILLDOCS_PATH>/<Project_Name>`.
7. If historical notes are needed, create `mkdir -p <MAPPED_SKILLDOCS_PATH>/<Project_Name>/notes` and keep those files outside the default planning load path.
