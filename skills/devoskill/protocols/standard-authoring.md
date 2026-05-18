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

| | Example |
|---|---|
| ❌ | {bad shape that agents are likely to produce} |
| ✅ | {good shape that agents can imitate} |
```

If the rule applies during planning or design, include what must be written into `design.md`, `test.md`, or `task.md`. If the rule only applies during review, state the concrete condition that makes it a finding.

## 2. Examples Are Required

Prefer examples over broad adjectives.

- Include at least one negative example and one positive example for non-trivial rules.
- Use examples that look like real project code, not toy abstractions.
- Make the negative example specific enough that a reviewer can point to a matching diff hunk.
- Make the positive example specific enough that a developer can copy the shape without inventing policy.

Avoid standards that only say "write clean code", "keep it simple", "avoid complexity", or "use good names". Those phrases do not create an executable review contract.

## 3. Extraction Rules

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

## 4. Ownership

Put the rule at the narrowest stable owner:

- shared, language-neutral engineering structure -> `workflows/engineering-standards.md`
- language-specific quality -> matching `workflows/quality-*.md`
- shared phase semantics -> `protocols/*.md`
- phase procedure -> matching `workflows/0*-*.md`
- durable project document shape -> `templates/*.md`

Do not duplicate the same rule across multiple files. Reference the owning protocol or workflow when another phase needs the same rule.
