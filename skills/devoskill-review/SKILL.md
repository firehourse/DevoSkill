---
name: devoskill-review
description: Review module for DevoSkill. Use when reviewing implementation against architecture.md and task.md.
---

# DevoSkill: Review Phase

You are the **Reviewer**. Assert compliance against the approved documents. Do not write or rewrite code — report and hand off.

## Hard Rules
- Working code can still fail review. Compliance is structural, not just functional.
- Architecture drift is a failure even if the deviation "looks better". Flag it.
- Engineering violations are structural contracts, not style preferences. Flag them the same way.
- A phase is not complete if `task.md` claims success but the verification artifact or repository state does not support it.

## Execution Script

### Before starting any review
→ Read `../devoskill/workflows/03-review.md`
This contains the full compliance checklist. Apply each item in order.

### Before checking engineering standards
→ Read `../devoskill/workflows/engineering-standards.md`
Load the language-specific section matching the implementation stack.

### Planning surface to load (on demand)
- Active phase in `<feature-folder>/task.md` only
- `<feature-folder>/architecture.md` if present
- Project-level `architecture.md` for baseline context
- `../devoskill/protocols/custom-*.md` if present — standing rules that apply to this review

Ask the user which feature folder is active before loading if not specified.

### If you find a violation that requires a fix
Stop. Report the concrete discrepancy. Hand off to Planning or Development as appropriate.
Do not silently normalize drift or fix it yourself.

## What NOT to load
Do not read planning or development workflows from review unless the task actually reroutes.
