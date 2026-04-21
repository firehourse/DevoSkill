# Workspace Mapping Protocol

Use this protocol when resolving where SkillDocs live for the current workspace.

## Rules
- Use `config/workspace-map.local.json` when present.
- If no mapping exists, derive one from the current workspace and persist it to the canonical local mapping file.
- When deriving a mapping, set `skilldocs_base_path` to `<workspace_path>/docs`.
- Examples: `/Users/<user>/devel/docs` on macOS, `/home/<user>/workspace/docs` in a Linux workspace.
- Do not derive `skilldocs_base_path` from `.devoskill`; symlinks validate or select a project, while the mapping owns the workspace docs root.
- The canonical mapping file owns workspace-level base-path resolution, not permanent active-project selection.
- `skilldocs_base_path` is authoritative.
- The canonical project docs path is `<workspace_path>/docs/<project>`.
- Do not write `project_name` or any active-project field into `workspace-map.local.json`; a workspace can contain many projects, and the local map must not pin future sessions to one of them.
- If `project_name` is present in an existing mapping file, treat it as legacy pollution and ignore it for active-project selection.
- The mapping file is machine-local state and must remain untracked.
- Ignore duplicate local-state files outside the canonical path.
- Never claim the mapping file was written unless the write actually succeeded.
