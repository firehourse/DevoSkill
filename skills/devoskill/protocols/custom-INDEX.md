# Custom Rules Index

This is the cheap-to-load discovery surface for `custom-*.md` shared/company-level rules. Phase SKILL.md files reference it instead of forcing the agent to scan every custom file by default.

## How agents use this file

1. Read this index whenever a planning / development / review / debug step touches a cross-project or company-level operational boundary (branch, commit, push, PR, external system update, shared naming/style, shared performance budget).
2. If a row's trigger applies to the current step, open the linked `custom-*.md` file and read **only the named section**.
3. If no row matches, do not load any `custom-*.md` file for this step.

This resolves the catch-22 where the agent would otherwise have to read every `custom-*.md` to discover whether any rule applies.

## Index

| If the current step does this | Then load | Read this section |
|---|---|---|
| Resolves `skilldocs_base_path` or chooses where to write planning docs | `custom-quality.md` | `## Workspace SkillDocs Base` |
| Reads or writes workspace mapping / active-project state | `custom-quality.md` | `## Mapping Active Project State` |
| Plans, prepares, or executes `git push` (any branch, any remote) | `custom-quality.md` | `## Git Push Requires Explicit Approval` |
| Plans, prepares, or executes a PR creation against a shared remote | `custom-quality.md` | `## Git Push Requires Explicit Approval` |
| Adds a Mermaid flowchart to Markdown docs | `custom-quality.md` | `## Mermaid Flowchart ELK Layout` |

## Index maintenance

When a new rule is appended to `custom-quality.md` (or any other `custom-*.md`) via the `Update` route, also append a row here with the matching trigger. A rule that lives in `custom-*.md` but is not indexed is effectively invisible to future sessions, because phase SKILL.md files only consult the index.

The `Update` route is responsible for both the rule writeback and the index row. Treat a writeback without an index update as incomplete.
