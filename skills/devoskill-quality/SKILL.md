---
name: devoskill-quality
description: Quality gate module for DevoSkill. Use at the end of any implementation phase to verify technical correctness across resource lifecycle, validation, fault tolerance, operational hygiene, identity, and frontend patterns.
---

# DevoSkill Quality

Use this skill as a pre-completion gate after implementation work is done and before writing back to `task.md`.

## Load Order
1. Read `../devoskill/workflows/05-quality.md` — language-neutral checks, always required
2. For each language present in the implementation, load the matching language skill:
   - Go code → load `../devoskill-quality-go/SKILL.md`
   - Node.js / TypeScript code → load `../devoskill-quality-node/SKILL.md`
3. Apply all loaded checks against the produced code before writing back to `task.md`

## Required Behavior
- Always run the general quality checks first.
- Then run every language-specific skill that matches the implementation stack.
- Use the principle in each category to reason and the examples to pattern-match.
- If any item fails, fix it before declaring the phase complete.
- Do not skip a category because it "probably doesn't apply" — verify, then skip if confirmed irrelevant.
- Treat verification as contract execution, not a vibe check. If the evidence surface is missing, the quality gate has not passed.
