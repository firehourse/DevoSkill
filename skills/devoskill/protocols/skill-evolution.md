# Skill Evolution Protocol

This protocol defines when and how the agent captures user-stated rules and internalizes them directly into the owning DevoSkill file. There is no separate `custom-*.md` capture layer: a rule that deserves to persist deserves to live where future sessions already look.

It is the single authority for capture semantics, ownership resolution, and writeback behavior. Do not duplicate these rules in `devoskill-update/SKILL.md` or any other skill.

## 1. What Qualifies for Capture

Capture a rule when the user:
- explicitly corrects agent behavior and the correction applies across sessions (not just this task)
- states a style, naming, structural, or performance rule as a standing preference
- confirms a non-default approach and expects it to persist

Do NOT capture:
- one-off task decisions that only apply to the current feature
- rules already present in existing DevoSkill skill files or protocols (verify before writing)
- vague preferences without actionable content ("I like clean code")
- agent-internal routing or planning decisions

If uncertain, do not capture. Only capture when the rule is clearly cross-session and user-stated.

## 2. Ownership Resolution

Internalize the rule at its narrowest stable owner (same ladder as `standard-authoring.md § Ownership`):

| Rule content | Owner |
|---|---|
| Project/domain-specific workflow or code concern | the matching dedicated skill (e.g. `kktix-*-rules`), via its registry |
| Shared language-neutral engineering structure | `workflows/engineering-standards.md` |
| Language-specific quality | the matching `workflows/quality-*.md` |
| Phase procedure (how review/development/planning behaves) | the matching `workflows/0*-*.md` |
| Shared phase semantics or cross-phase contract | the matching `protocols/*.md` (create one only if no existing protocol owns the concern) |
| Durable document shape | the matching `templates/*.md` |
| How DevoSkill files themselves are authored | `docs/DevoSkill/doctrine.md` |
| Operational approval boundaries (push, PR, external systems) | `protocols/operational-gates.md` |

## 3. Writeback Behavior

- Edit the owning file directly, following `standard-authoring.md` rule shape (Principle / Required check / ❌-✅) when the rule is an executable standard; a single behavioral line in the right section is enough for small rules.
- The internalized rule must be indistinguishable from native framework content — no "captured from user" markers in the rule body. Provenance belongs in the commit message and, when the workspace keeps one, the project changelog.
- If the rule contradicts existing content, reconcile in place: update or remove the older statement. Two conflicting statements in one framework is drift.
- After writeback, report what was internalized and into which file, then stop — do not continue into implementation.

## 4. Scope Boundary With Doctrine/Maintenance

Update internalizes a single user-stated rule into an existing owner. When the rule requires changing route taxonomy, load order, file boundaries, or the anchoring mechanism, reroute to `Doctrine/Maintenance` — that is a framework redesign, not a rule capture.
