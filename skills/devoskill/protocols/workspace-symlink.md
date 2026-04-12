# Workspace Symlink Protocol

Use this protocol when creating or validating `.devoskill`.

## Rules
- `.devoskill` points to the project-specific SkillDocs root, not a feature folder.
- If missing during active work, create or refresh it after mapping and project-folder resolution.
- Add `.devoskill` to the target project's `.gitignore`.
- Symlink correctness is a workspace concern, not a planning decision.
- During active work, `.devoskill` is the authoritative local pointer to the current SkillDocs project.
- If `.devoskill` and legacy mapping metadata disagree, do not auto-switch projects without clear user intent or an explicit repair step.
