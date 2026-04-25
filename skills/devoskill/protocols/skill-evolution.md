# Skill Evolution Protocol

This protocol defines when and how the agent captures shared/company-level user-stated rules and writes them back into DevoSkill custom protocol files.

It is the single authority for capture semantics, classification, and writeback behavior. Do not duplicate these rules in `devoskill-update/SKILL.md` or any other skill.

## 1. What Qualifies for Capture

Capture a rule when the user:
- explicitly corrects agent behavior and the correction applies across sessions (not just this task)
- states a shared/company-level style, naming, or structural rule as a standing preference
- states a shared/company-level performance standard or optimization requirement as a standing expectation
- confirms a non-default approach and expects it to persist

Do NOT capture:
- one-off task decisions that only apply to the current feature
- rules already present in existing DevoSkill skill files or protocols
- vague preferences without actionable content ("I like clean code")
- agent-internal routing or planning decisions
- project/domain-specific workflow or code-concern rules that belong in a dedicated skill

If uncertain, do not capture. Only capture when the rule is clearly cross-session, user-stated, and belongs to the shared/company-level layer.

## 2. Classification

Before creating any file, first decide whether the rule belongs to the shared/company-level layer or to a project/domain skill.

- Shared/company-level rule:
  - scan existing `custom-*.md` files under `skills/devoskill/protocols/`
  - if the rule fits an existing file's scope, append there instead of creating a new one
- Project/domain-specific rule:
  - do not write it into DevoSkill shared custom protocols
  - route it to the matching dedicated skill, or tell the user that the project/domain skill must be updated instead

If no existing file fits, determine the target name using this logic:

1. Is the rule language- or runtime-specific (e.g. Go, Node, Python)?
   - Yes → `custom-{language}-{category}.md` (e.g. `custom-go-quality.md`, `custom-node-performance.md`)
   - No → `custom-{category}.md`

2. Map rule content to category using this table:

| Rule content | Category |
|---|---|
| Naming conventions, formatting, code style, lint rules, file structure | `quality` |
| Testing standards, test structure, coverage expectations | `quality` |
| Security or auth patterns | `quality` |
| Performance budgets, optimization patterns, caching strategy, latency expectations | `performance` |

3. If the rule spans multiple categories, pick the dominant one.

The agent decides the shared/company-level file name independently. Do not ask the user for the file name.

## 3. Naming Constraint (Non-Negotiable)

The Update phase may ONLY create or append to files whose name matches `custom-*.md` inside `skills/devoskill/protocols/` when the captured rule belongs to the shared/company-level layer.

Do not force project/domain rules into DevoSkill shared custom files. Those rules belong in dedicated skills outside this writeback surface.

## 4. Writeback Format

When writing a shared/company-level rule to a `custom-*.md` file:

**First rule of that category** — create the file with this header, then append the rule:

```markdown
# Custom {Category} Rules

Rules captured from user corrections and explicit cross-session standards.
Do not edit manually unless reconciling with a newer user-stated preference.
```

**Each captured rule** — append as a single entry:

```markdown
## {short rule title}
- Captured: {YYYY-MM-DD}
- Rule: {one or two sentences, actionable and specific}
- Trigger: {user correction | user confirmation | explicit statement}
```

Keep rules short and actionable. Do not write explanatory prose or rationale unless the user explicitly provided it.

## 5. Load Behavior for Other Phases

DevoSkill phase skills do not scan all custom protocol files by default.

- Shared/company-level `custom-*.md` files are loaded only when one of these conditions is true:
  - the current step depends on a cross-project/company-level operational boundary, such as branch/push/PR/external-action permissions
  - the current step depends on a shared naming/style/structure rule that is not owned by the active project/domain skill
  - the current step depends on a shared quality/performance expectation that applies across projects
  - the active project/domain skill explicitly says a shared DevoSkill custom rule must also be consulted
- Shared/company-level `custom-*.md` files are **not** loaded when the current step can be resolved by:
  - the active project/domain skill
  - stack-specific DevoSkill protocols or workflows
  - the active planning/design/test/verification surface alone
- Project/domain rules must be loaded from the matching dedicated skill based on repo/path context or explicit user intent.

Shared DevoSkill custom files are only one mechanism for future-session influence; project/domain skills are the authority for their own scoped rules.
