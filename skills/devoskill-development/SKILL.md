---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill Development

Use this skill only after planning exists and the user has explicitly approved implementation.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Development`.

If the work no longer matches development, stop and reroute instead of continuing.

## Load Order
1. If workspace mapping is missing or broken, read `../devoskill-workspace-setup/SKILL.md`; otherwise skip workspace setup.
2. Read `../devoskill/workflows/02-development.md`
3. Read `../devoskill/workflows/engineering-standards.md` — load the language-specific section matching the implementation stack
4. Load only the active phase in `task.md` and the effective architecture sections it references

## Required Behavior
- Do not begin code changes without explicit implementation approval.
- Keep checking that the work is still active implementation. If the user asks for planning, drift validation, or performance diagnosis, reroute.
- Follow the active phase in `task.md` linearly.
- Respect human handoff points and do not guess through missing schema, contracts, or credentials.
- For existing code, obey maintenance constraints, style conformance rules, and anti-over-abstraction rules.
- Treat `design.md`, `task.md`, verification artifacts, and repository state as a single implementation contract. If they diverge, stop and reconcile instead of coding through the inconsistency.
