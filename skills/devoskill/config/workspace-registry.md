# Workspace & SkillDocs Registry

This document acts as the dynamic registry mapping physical workspace directories to their designated `skilldocs` storage paths. Since this DevoSkill toolset may be used across multiple workspaces on the same machine, AI Subagents MUST check and update this registry when planning a new project.

## Current Mappings

| Workspace Path (Source Code) | SkillDocs Path (Documentation) |
|---|---|
| `/home/devork/workspace` | `/home/devork/workspace/skilldocs` |

*To register a new Workspace:*
1. Add a row to the table above.
2. The `SkillDocs Path` should typically be placed outside the immediate git repository of the source code (e.g., adjacent to the workspace root or inside a dedicated `~/skilldocs` folder).
