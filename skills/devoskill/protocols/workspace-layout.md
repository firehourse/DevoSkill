# Workspace Layout Protocol

Use this protocol when deciding the directory structure under SkillDocs.

## Layout
```text
<workspace_path>/docs/<project>/
  architecture.md
  project-changelog.md
  study/
    <topic>.md
  <feature-name>/
    task.md
    design.md
    test.md
    verification.md
    architecture.md   # only when the feature adds meaningful design deltas
    notes/
```

## Rules
- Store SkillDocs under `<workspace_path>/docs/<project>`.
- Project-root `architecture.md` is the stable baseline.
- Project-root `project-changelog.md` records feature/change timestamp rows and the reason behind important decisions. It is loaded only when a task or review needs change rationale.
- Project-root `study/` stores reusable code-reading guides, system/domain studies, and flow maps. It is loaded selectively by Inquiry or Planning, never as a default execution surface.
- Each feature gets its own folder.
- Do not create a second feature `task.md` at the project root.
- Feature names are short kebab-case identifiers.
