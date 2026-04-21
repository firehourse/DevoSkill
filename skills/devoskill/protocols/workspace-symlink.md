# Workspace Symlink Protocol

Use this protocol when creating or validating `.devoskill`.

## Rules
- A project root's `.devoskill` points to `<workspace_path>/docs/<project>`, not a feature folder.
- If missing during active work, create or refresh it after mapping and project-folder resolution.
- Add `.devoskill` to the target project's `.gitignore`.
- Symlink correctness is a workspace concern, not a planning decision.
- During active work, the project root's own `.devoskill` is the authoritative local pointer to the current SkillDocs project.
- Do not use an ancestor directory's `.devoskill` as the active project pointer for a child project.
- If `.devoskill` points outside `<workspace_path>/docs/<project>`, treat it as repair drift instead of silently following it.
