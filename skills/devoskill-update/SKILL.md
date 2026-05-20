---
name: devoskill-update
description: Update module for DevoSkill. Use when the immediate next action is capturing a user-stated rule, style correction, or performance standard into custom skill protocols.
---

# DevoSkill Update

Use this skill when the user states an explicit correction, style rule, or performance standard that should persist across future sessions.

Do not use it for planning, implementation, or review work. If the user's immediate next action shifts to one of those, reroute.

Assume the entry router has already:
- resolved bootstrap state,
- classified the request as `Update`.

## Load Order
1. Read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/skill-evolution.md`
2. Apply capture semantics, classification, and writeback rules from that protocol only.

Do not load planning, development, review, or performance workflows.

## Required Behavior
- Apply the noise filter before capturing anything. If the rule does not qualify, do not write.
- Scan existing `custom-*.md` files first only for shared/company-level rules. If the rule is project/domain-specific, route it to the matching dedicated skill instead of writing it into DevoSkill shared protocols.
- Classify and name the shared/company-level file independently using the logic in `skill-evolution.md`. Do not ask the user for the file name.
- Only create or append to `custom-*.md` files inside `{DEVOSKILL_ROOT}/skills/devoskill/protocols/` when the rule truly belongs to the shared/company-level layer. Do not force project/domain rules into DevoSkill custom files.
- After every shared-rule writeback to `custom-*.md`, append a matching row to `{DEVOSKILL_ROOT}/skills/devoskill/protocols/custom-INDEX.md` so future phase skills can discover the rule via the index. Treat an unindexed writeback as incomplete.
- After writeback, report what was written and to which file. Stop — do not continue into implementation.

---

## Strongest-Attention Rules

Re-read these on every reroute into Update and at any long-session re-anchor.

1. **Index every shared rule.** A rule written to `custom-*.md` without a matching row in `custom-INDEX.md` is invisible to future sessions. Both writebacks land in the same turn.
2. **Project/domain rules do not belong in `custom-*.md`.** Route them to the matching project skill instead. DevoSkill custom protocols are for cross-project / company-level rules.
3. **Stop after writeback.** Do not slide into implementation in the same turn — that's a reroute the user must request.
