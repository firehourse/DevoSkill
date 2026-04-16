# Skill Evolution Protocol

This protocol defines when and how the agent captures user-stated rules and writes them back into custom protocol files.

It is the single authority for capture semantics, classification, and writeback behavior. Do not duplicate these rules in `devoskill-update/SKILL.md` or any other skill.

## 1. What Qualifies for Capture

Capture a rule when the user:
- explicitly corrects agent behavior and the correction applies across sessions (not just this task)
- states a style, naming, or structural rule as a standing preference
- states a performance standard or optimization requirement as a standing expectation
- confirms a non-default approach and expects it to persist

Do NOT capture:
- one-off task decisions that only apply to the current feature
- rules already present in existing DevoSkill skill files or protocols
- vague preferences without actionable content ("I like clean code")
- agent-internal routing or planning decisions

If uncertain, do not capture. Only capture when the rule is clearly cross-session and user-stated.

## 2. Classification

Before creating any file, scan all existing `custom-*.md` files under `skills/devoskill/protocols/`. If the rule fits an existing file's scope, append there instead of creating a new one.

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

The agent decides the name independently. Do not ask the user for the file name.

## 3. Naming Constraint (Non-Negotiable)

The Update phase may ONLY create or append to files whose name matches `custom-*.md` inside `skills/devoskill/protocols/`.

Do not create, modify, or overwrite any other file in `protocols/` or anywhere else in the DevoSkill skill tree during Update phase execution.

## 4. Writeback Format

When writing to a `custom-*.md` file:

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

Development, Review, and Performance skills load custom protocol files conditionally:
- If any `custom-*.md` files exist under the shared protocols directory, read them before executing.
- If no custom files exist, skip — no change in default behavior.

This conditional load is the only mechanism by which captured rules influence future sessions.
