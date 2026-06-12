---
name: devoskill-update
description: Update module for DevoSkill. Use when the immediate next action is internalizing a user-stated rule, style correction, or performance standard directly into the owning DevoSkill file.
---

# DevoSkill Update

Use this skill when the user states an explicit correction, style rule, or performance standard that should persist across future sessions.

Do not use it for planning, implementation, or review work. If the user's immediate next action shifts to one of those, reroute.

Assume the entry router has already:
- resolved bootstrap state,
- classified the request as `Update`.

## Load Order
1. Read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/skill-evolution.md`
2. Apply capture semantics, ownership resolution, and writeback rules from that protocol only.

Do not load planning, development, review, or performance workflows.

## Required Behavior
- Apply the noise filter before capturing anything. If the rule does not qualify, do not write.
- Resolve the owning file via the ownership table in `skill-evolution.md`; project/domain rules go to the matching dedicated skill, never into DevoSkill shared protocols.
- Edit the owner directly so the rule reads as native framework content; reconcile any contradicting older statement in the same change.
- If the rule requires changing route taxonomy, load order, or file boundaries, reroute to `Doctrine/Maintenance` instead of forcing it into a rule edit.
- After writeback, report what was internalized and to which file. Stop — do not continue into implementation.

---

## Strongest-Attention Rules

Re-read these on every reroute into Update and at any long-session re-anchor.

1. **Internalize at the owner.** There is no `custom-*.md` capture layer. The rule lands in the file future sessions already load for that concern, written as native content.
2. **Project/domain rules go to the project skill.** Never into DevoSkill shared protocols.
3. **Reconcile, don't accumulate.** If the new rule contradicts an existing statement, fix the old one in the same change — two conflicting statements is drift.
4. **Stop after writeback.** Do not slide into implementation in the same turn — that's a reroute the user must request.
