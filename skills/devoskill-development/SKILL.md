---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill Development

Use this skill only after planning exists and the user has explicitly approved implementation.

## Load Order
1. Read `../devoskill/protocols/workspace-setup.md`
2. Read `../devoskill/workflows/02-development.md`
3. Load only the active phase in `task.md` and the effective architecture sections it references

## Required Behavior
- Do not begin code changes without explicit implementation approval.
- Follow the active phase in `task.md` linearly.
- Respect human handoff points and do not guess through missing schema, contracts, or credentials.
- For existing code, obey maintenance constraints, style conformance rules, and anti-over-abstraction rules.
