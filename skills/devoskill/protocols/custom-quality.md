# Custom Quality Rules

Rules captured from user corrections and explicit cross-session standards.
Do not edit manually unless reconciling with a newer user-stated preference.

## Workspace SkillDocs Base
- Captured: 2026-04-21
- Rule: In a multi-project workspace, SkillDocs base must be the workspace-level `docs` directory (a sibling of the project repos), not a project repository's internal docs directory. Project-specific SkillDocs should live as siblings under that base, for example `docs/<project-slug>`.
- Trigger: user correction

## Mapping Active Project State
- Captured: 2026-04-21
- Rule: Do not store a single active project in workspace mapping for multi-project workspaces. The mapping should only define the workspace path and SkillDocs base; active project selection belongs to explicit user intent or the `.devoskill` symlink.
- Trigger: user correction

## Git Push Requires Explicit Approval
- Captured: 2026-04-21
- Rule: Agents may create local branches for development work, but must not run `git push` unless the user explicitly asks for push in the current turn. Plans must call out push and PR creation as human-approved boundaries when credentials or signing are not ready.
- Trigger: explicit statement

## Mermaid Flowchart ELK Layout
- Captured: 2026-05-07
- Rule: For Markdown documentation, Mermaid flowcharts should use ELK layout by adding `%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%` before the `flowchart` declaration when the renderer supports it. Do not add this to Mermaid diagram types that do not use flowchart layout, such as sequence diagrams.
- Trigger: user correction
