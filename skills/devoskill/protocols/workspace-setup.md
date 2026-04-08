# Workspace Setup & Directory Rules

To prevent repository pollution and maintain state across different Developer and Reviewer sessions, all planning documentation MUST be centralized and accessed via a strict set of rules.

## 1. The SkillDocs Repository & Local Mapping State
All architecture and task files must be written to or read from a centralized location outside the target project's repository.
- **Location Mapping**: Since DevoSkill may be used across multiple workspaces on the same machine, the `skilldocs` base directory is dynamically determined. Use `config/workspace-map.local.json` when present. If the current workspace is missing, derive the mapping from the current workspace and write it back to that local state file for future sessions.
- **Persistence**: AI Agents NEVER generate rambling conversational summaries. The source of truth across sessions is strictly the state of the `.md` documents within the `skilldocs/<Project_Name>` folder.
- **History Location**: If non-default history, decision notes, or abandoned planning artifacts must be preserved, store them under `skilldocs/<Project_Name>/notes/`. Do not mix them into the default planning surface.
- **Project Folder Rule**: The mapped base path is the SkillDocs root, not the final project folder. The agent MUST derive or confirm a concrete `<Project_Name>` and work inside `<MAPPED_SKILLDOCS_PATH>/<Project_Name>`.
- **Git Hygiene**: The local mapping file is machine-specific state and MUST remain untracked. Keep it ignored by git.

## 2. The Local `.devoskill` Symlink
During active development, it is highly inconvenient to navigate back and forth to an external directory. We solve this via local symlinking.
- **Initial Setup**: When starting development in a target project, the AI (or User) should create a symbolic link targeting the centralized documentation.
  Command: `ln -s <MAPPED_SKILLDOCS_PATH>/<Project_Name> .devoskill`
- **Git Rules**: Once created, append `.devoskill` to the target project's `.gitignore` file to ensure the symlink is never tracked by git.

## 3. Project and Feature Folder Structure

Every project has a two-level layout inside `<SKILLDOCS_PATH>/<Project_Name>/`:

```
<Project_Name>/
  architecture.md          # project-level baseline: existing system overview, stable constraints
  <feature-name>/          # one folder per feature, task, or change set
    task.md                # executable work for this feature only
    verification.md        # durable verification evidence for this feature/run
    architecture.md        # feature delta — only needed if the change has its own design decisions
    notes/                 # history, abandoned approaches, decision logs
```

Rules:
- `architecture.md` at the **project root** describes the existing system. It is updated only when the baseline itself changes, not per-feature.
- Each feature or change set gets its **own named folder**. Never add a new `task.md` to the project root for a second feature — create a new folder instead.
- Each feature folder also owns its verification evidence. Do not bury runtime proof only in chat transcripts or the root project docs.
- Feature folder names are short, kebab-case, and describe the change: `delete-conversation`, `add-export-api`, `migrate-auth`.
- A feature-level `architecture.md` is only created when the change introduces new components, boundaries, or design decisions that need to be recorded. Small changes that only modify existing code do not need one.
- The `.devoskill` symlink points to `<Project_Name>/` (project root), not a feature folder.

## 4. Creating a New Project Profile
When an AI transitions into Planning mode for a new project:
1. Identify the project name and the workspace root.
   - Default to the repository or target folder name if the user does not provide a better project name.
   - If multiple candidate project names exist, ask the user instead of guessing.
2. Check `config/workspace-map.local.json` for an existing mapping for the current workspace root.
3. If no mapping exists, derive one dynamically:
   - prefer `<WORKSPACE_ROOT>/docs` when it is acceptable for this workspace,
   - otherwise choose a user-approved adjacent or dedicated SkillDocs base path,
   - then write the resolved mapping into `config/workspace-map.local.json`.
4. Ensure the mapped base directory exists, then create `<MAPPED_SKILLDOCS_PATH>/<Project_Name>/`.
5. If `<Project_Name>/` already exists, reuse it — do not re-bootstrap blindly.
6. Bootstrap `architecture.md` at the project root using `templates/architecture.md`.
7. Create the feature folder: `mkdir -p <Project_Name>/<feature-name>/` and bootstrap `task.md` and `verification.md` inside it using the matching templates.
8. Create or refresh the `.devoskill` symlink to point at `<Project_Name>/` (not the feature folder).
9. Historical notes go under `<Project_Name>/<feature-name>/notes/`, not at the project root.
