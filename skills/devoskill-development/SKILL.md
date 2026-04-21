---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill Development

Use this skill only after planning exists and the user has explicitly approved implementation.
Do not use it for architecture discovery, compliance-only validation, or benchmark-first debugging.

Assume the entry router has already:
- resolved bootstrap state or explicitly sent you into workspace setup,
- classified the request as `Development`.

If the work no longer matches development, stop and reroute instead of continuing.

## Load Order
1. If workspace mapping is missing or broken, read `../devoskill-workspace-setup/SKILL.md`; otherwise skip workspace setup.
2. Read `../devoskill/workflows/02-development.md`
3. Read `../devoskill/workflows/engineering-standards.md` — load the language-specific section matching the implementation stack
4. Load only the active phase in `task.md` and the effective architecture sections it references
5. If Go code is in scope, read `../devoskill/protocols/go-implementation-mode.md` before choosing abstractions or package boundaries
6. If Ruby/Rails code is in scope, read `../devoskill/protocols/rails-maintenance-mode.md` before changing style, callbacks, service boundaries, or lifecycle behavior
7. If any `../devoskill/protocols/custom-*.md` files exist, read them — they contain project-specific or user-captured standing rules that apply to this session

Do not read planning, review, or performance workflows from development unless the task actually reroutes.

## Required Behavior
- Do not begin code changes without explicit implementation approval.
- Keep checking that the work is still active implementation. If the user asks for planning, drift validation, or performance diagnosis, reroute.
- Follow the active phase in `task.md` linearly.
- Respect human handoff points and do not guess through missing schema, contracts, or credentials.
- For existing code, obey maintenance constraints, style conformance rules, and anti-over-abstraction rules.
- Do not write code without an explicit `task.md`.
- Treat `design.md`, `task.md`, verification artifacts, and repository state as a single implementation contract. If they diverge, stop and reconcile instead of coding through the inconsistency.
