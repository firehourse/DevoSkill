# Standard Authoring Protocol

Use this protocol when adding or revising DevoSkill engineering standards, quality checks, review checks, or stack-specific implementation rules.

Its job is to keep standards reviewable and executable by agents. A standard is not complete if it only states taste in abstract prose.

## 1. Rule Shape

Each standard should answer one primary question and use this shape unless a shorter checklist is clearly enough:

```markdown
## {Rule Name}

**Principle:** {one or two sentences explaining the decision rule}

Required check:
- {what Development, Review, or Quality must inspect}
- {what must be fixed or flagged}

| | Example | Why |
|---|---|---|
| ❌ | {bad shape that agents are likely to produce} | {the failure it causes} |
| ✅ | {good shape that agents can imitate} | {what it fixes} |
```

Every negative example states the failure it causes in the Why column, so the reader learns the rule, not just the syntax.

**Pick the container by content type.** Use the table above for rule, shape, or behavior comparisons. For code examples, prefer inline `# ❌ BAD` / `# ✅ GOOD` comments inside one code block — a table fragments code and breaks copy-paste:

```ruby
# ❌ BAD: raw interpolation in a <script> tag — breaks out on </script>
"<%= raw user_value.to_json %>"
# ✅ GOOD: json_escape neutralizes </script> and U+2028/U+2029
"<%= raw json_escape(user_value.to_json) %>"
```

If the rule applies during planning or design, include what must be written into `design.md`, `test.md`, or `task.md`. If the rule only applies during review, state the concrete condition that makes it a finding.

## 2. Examples Are Required

Prefer examples over broad adjectives.

- Include at least one negative example and one positive example for non-trivial rules.
- Use examples that look like real project code, not toy abstractions.
- Make the negative example specific enough that a reviewer can point to a matching diff hunk.
- Make the positive example specific enough that a developer can copy the shape without inventing policy.
- One excellent, realistic example beats several mediocre ones. Do not pad the table to look thorough; add a row only when it teaches a distinct failure.

Avoid standards that only say "write clean code", "keep it simple", "avoid complexity", or "use good names". Those phrases do not create an executable review contract.

## 3. Discipline And Rule Standards

A standard that enforces a gate or a must/never rule has to resist rationalization — agents under pressure look for loopholes. For these, the ❌-✅ table alone is not enough. Also add:

**Close every loophole explicitly.** Do not just state the rule; name the specific workarounds and forbid them.

| | Example | Why |
|---|---|---|
| ❌ | "Don't keep untested code." | A bare rule leaves obvious escapes open. |
| ✅ | "Don't keep untested code. No exceptions: not as 'reference', not 'adapted while writing tests', not commented out. Delete means delete." | Each named escape is pre-closed. |

**Rationalization table.** List the actual excuses (from real reviews/sessions, not hypotheticals) and counter each:

| Excuse | Reality |
|--------|---------|
| "It's a one-line cleanup" | One line outside the touched surface is still scope bleed. |
| "I'm following the spirit, not the letter" | Violating the letter of the rule is violating the spirit. |

**Red Flags self-check.** A short list of thoughts that signal a violation is about to happen, so the agent can catch itself:

```markdown
## Red Flags — If You Think This, Stop
- "This extra section is reviewer-relevant"
- "I'll just tidy this adjacent method while I'm here"
```

`workflows/03-review.md`'s "Red Flags — If You Think This, You Are Violating Protocol" table is the in-repo exemplar to copy. These devices are formatting only; they sit inside DevoSkill's existing router/standard model and do not import any external testing methodology.

## 4. Extraction Rules

When writing standards about readability or decomposition, distinguish meaningful extraction from cosmetic extraction.

Extraction is good when it:
- names a real domain operation,
- hides noisy technical detail that distracts from the primary flow,
- isolates a boundary such as parsing, storage, logging, error normalization, authorization, or external I/O,
- or makes a repeated invariant impossible to spell differently.

Extraction is bad when it:
- wraps a one-line expression with no new domain meaning,
- creates a chain of tiny methods that forces the reader to jump around to understand one flow,
- turns local direct code into indirection solely to make the top-level method shorter,
- or hides ordering, transaction, lifecycle, cache, TTL, or error semantics that reviewers need to see.

## 5. Ownership

Put the rule at the narrowest stable owner:

- shared, language-neutral engineering structure -> `workflows/engineering-standards.md`
- language-specific quality -> matching `workflows/quality-*.md`
- shared phase semantics -> `protocols/*.md`
- phase procedure -> matching `workflows/0*-*.md`
- durable project document shape -> `templates/*.md`

Do not duplicate the same rule across multiple files. Reference the owning protocol or workflow when another phase needs the same rule.
