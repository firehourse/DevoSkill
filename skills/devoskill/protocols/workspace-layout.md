# Workspace Layout Protocol

Use this protocol when deciding the directory structure under SkillDocs.

## Layout
```text
<workspace_path>/docs/<project>/
  architecture.md
  project-changelog.md
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
- Each feature gets its own folder.
- Do not create a second feature `task.md` at the project root.
- Feature names are short kebab-case identifiers.
