---
name: devoskill-grill
description: Support module for DevoSkill planning. Use inside planning when interrogating the user about a plan, design, refactor, boundary decision, or implementation approach before writing planning docs.
---

# DevoSkill Grill

Use this skill inside planning when the agent needs a compact reference for how to pressure-test the user before writing planning docs.

## Load Order
1. Read `../devoskill-thinking-phase/SKILL.md`
2. Load only the minimum code, docs, or active planning surface needed to challenge the current idea

## Required Behavior
- Ask one high-value question at a time.
- Prioritize hidden assumptions, missing constraints, boundary violations, rollback risk, and test gaps.
- If the answer can be discovered from the codebase or planning docs, inspect them instead of asking the user.
- Keep pushing until the remaining uncertainty is low enough to recommend a concrete next step.
- Hand control back to `../devoskill-planning/SKILL.md` once the key ambiguity has been reduced enough to write effective docs.
