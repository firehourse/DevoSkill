# Workspace Project Resolution Protocol

Use this protocol when deciding which SkillDocs project is currently active inside a workspace.

## Authority Order
1. Explicit user instruction about the active project
2. Existing local `.devoskill` symlink target
3. Clear repository-local evidence that only one project is intended
4. Ask the user if multiple plausible projects remain

## Rules
- Treat `skilldocs_base_path` as workspace-level state.
- Do **not** treat `project_name` inside `workspace-map.local.json` as the authoritative active project for every future session.
- If `project_name` exists in the mapping file, treat it as legacy or advisory state only.
- During active work, `.devoskill` is the authoritative local pointer to the current SkillDocs project.
- If `.devoskill` and the mapping file disagree, prefer the symlink for the current session and classify the situation as workspace repair rather than silently switching projects.
- Do not rewrite `.devoskill` just because a legacy `project_name` field exists in the mapping file.
