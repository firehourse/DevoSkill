# Workspace Layout Protocol

Use this protocol when deciding the directory structure under SkillDocs.

## Layout
```text
<Project_Name>/
  architecture.md
  <feature-name>/
    task.md
    design.md
    verification.md
    architecture.md   # only when the feature adds meaningful design deltas
    notes/
```

## Rules
- Project-root `architecture.md` is the stable baseline.
- Each feature gets its own folder.
- Do not create a second feature `task.md` at the project root.
- Feature names are short kebab-case identifiers.
