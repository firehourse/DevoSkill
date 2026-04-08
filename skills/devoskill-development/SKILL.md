---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill Development

Use this skill only after planning exists and the user has explicitly approved implementation.

## Load Order
1. Read `../devoskill/protocols/workspace-setup.md`
2. Read `../devoskill/workflows/02-development.md`
3. Read `../devoskill/workflows/engineering-standards.md` — load the language-specific section matching the implementation stack
4. Load only the active phase in `task.md` and the effective architecture sections it references

## Required Behavior
- Do not begin code changes without explicit implementation approval.
- Follow the active phase in `task.md` linearly.
- Respect human handoff points and do not guess through missing schema, contracts, or credentials.
- For existing code, obey maintenance constraints, style conformance rules, and anti-over-abstraction rules.
- Treat `design.md`, `task.md`, verification artifacts, and repository state as a single implementation contract. If they diverge, stop and reconcile instead of coding through the inconsistency.
