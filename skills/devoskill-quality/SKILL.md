---
name: devoskill-quality
description: Quality gate module for DevoSkill. Use at the end of any implementation phase to verify technical correctness across resource lifecycle, validation, fault tolerance, operational hygiene, identity, and frontend patterns.
---

# DevoSkill Quality

Use this skill as a pre-completion gate after implementation work is done and before writing back to `task.md`.
Do not use it as a substitute for planning or review. Quality verifies implementation risk categories; it does not define architecture and it does not normalize drift.

## Load Order
1. Read `../devoskill/protocols/document-system.md`
2. Read `../devoskill/workflows/05-quality.md` — language-neutral checks, always required
3. Inspect the implementation file extensions to identify all languages present, then load every matching skill:
   - `.go` files → load `../devoskill-quality-go/SKILL.md`
   - `.ts` / `.js` files → load `../devoskill-quality-node/SKILL.md`
   - `.py` files → load `../devoskill-quality-python/SKILL.md`
   - `.lua` files → load `../devoskill-quality-lua/SKILL.md`
   - `.rb` files → load `../devoskill-quality-ruby/SKILL.md`
   - No match → apply only general checks from step 2
4. Apply all loaded checks against the produced code before writing back to `task.md`

Do not read planning or development workflows from quality unless a failure forces the task to reroute.

## Required Behavior
- Always run the general quality checks first.
- Then run every language-specific skill that matches the implementation stack.
- Use the principle in each category to reason and the examples to pattern-match.
- If any item fails, fix it before declaring the phase complete.
- Do not skip a category because it "probably doesn't apply" — verify, then skip if confirmed irrelevant.
- Treat verification as contract execution, not a vibe check. If the evidence surface is missing, the quality gate has not passed.
- Use the shared document system as the source of truth for declared behavior, evidence surfaces, and artifact hygiene expectations.
