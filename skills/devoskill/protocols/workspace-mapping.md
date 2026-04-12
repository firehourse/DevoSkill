# Workspace Mapping Protocol

Use this protocol when resolving where SkillDocs live for the current workspace.

## Rules
- Use `config/workspace-map.local.json` when present.
- If no mapping exists, derive one from the current workspace and persist it to the canonical local mapping file.
- If no mapping exists but `.devoskill` already points to a valid SkillDocs project, derive the base path from the symlink target's parent directory and treat that as sufficient bootstrap evidence for the current session.
- The canonical mapping file owns workspace-level base-path resolution, not permanent active-project selection.
- `skilldocs_base_path` is authoritative.
- `project_name`, if present, is legacy/advisory state only unless the current session has no better active-project signal.
- The mapping file is machine-local state and must remain untracked.
- Ignore duplicate local-state files outside the canonical path.
- Never claim the mapping file was written unless the write actually succeeded.
