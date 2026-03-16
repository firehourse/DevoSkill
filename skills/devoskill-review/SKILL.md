---
name: devoskill-review
description: Review module for DevoSkill. Use when reviewing implementation against architecture.md and task.md.
---

# DevoSkill Review

Use this skill when the request is to verify implementation compliance.

## Load Order
1. Read `../devoskill/workflows/03-review.md`
2. Load the active phase in `task.md`
3. Load only the effective architecture sections needed for that phase

## Required Behavior
- Review for scope bleed, architecture drift, phase integrity, and file size violations.
- Treat `architecture.md` and `task.md` as the source of truth, not "working code".
- If code and architecture diverge, return a concrete discrepancy list instead of normalizing the drift.
