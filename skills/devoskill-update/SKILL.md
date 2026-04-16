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
1. Read `../devoskill/protocols/skill-evolution.md`
2. Apply capture semantics, classification, and writeback rules from that protocol only.

Do not load planning, development, review, or performance workflows.

## Required Behavior
- Apply the noise filter before capturing anything. If the rule does not qualify, do not write.
- Scan existing `custom-*.md` files first. Append to an existing file if the rule fits its scope.
- Classify and name the file independently using the logic in `skill-evolution.md`. Do not ask the user for the file name.
- Only create or append to `custom-*.md` files inside `skills/devoskill/protocols/`. No other file may be created or modified.
- After writeback, report what was written and to which file. Stop — do not continue into implementation.
