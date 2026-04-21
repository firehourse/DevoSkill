# Workspace Project Resolution Protocol

Use this protocol when deciding which SkillDocs project is currently active inside a workspace.

## Authority Order
1. Explicit user instruction about the active project
2. Existing `.devoskill` symlink in the current project root
3. Clear repository-local evidence that identifies a single project slug under `<workspace_path>/docs/<project>`
4. Ask the user if multiple plausible projects remain

## Rules
- Treat `skilldocs_base_path` as workspace-level state.
- The active project's SkillDocs root must resolve to `<workspace_path>/docs/<project>`.
- Do **not** treat `project_name` inside `workspace-map.local.json` as the authoritative active project for every future session.
- Do **not** write `project_name` into new or repaired workspace mapping files.
- If `project_name` exists in the mapping file, treat it as legacy pollution and ignore it for active-project selection.
- During active work, the current project root's own `.devoskill` is the authoritative local pointer to the current SkillDocs project.
- Do not walk upward and reuse an ancestor directory's `.devoskill` for a child project.
- If `.devoskill` points outside `<workspace_path>/docs/<project>`, classify it as workspace repair and do not use it unless the user explicitly confirms that exception.
- Do not rewrite `.devoskill` just because a legacy `project_name` field exists in the mapping file.
