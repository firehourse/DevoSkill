---
name: devoskill-quality-node
description: Node.js/TypeScript-specific quality rules for DevoSkill. Load alongside devoskill-quality when the implementation includes Node.js or TypeScript code. Covers async error handling, RabbitMQ/Redis client patterns, startup sequencing, and HTTP error responses.
---

# DevoSkill Quality — Node.js / TypeScript

Load this skill in addition to `../devoskill-quality/SKILL.md` whenever the implementation includes Node.js or TypeScript code.

## Load Order
1. Confirm `../devoskill-quality/SKILL.md` has already been loaded
2. Read `../devoskill/workflows/quality-node.md`
3. Apply every category against the Node.js / TypeScript source files in the implementation

## Required Behavior
- Apply Node.js-specific checks after the general quality checks pass.
- Use the examples to pattern-match — if produced code matches a ❌ pattern, fix it before writing back to `task.md`.
- Do not skip a category because the code "looks fine" — verify against the principle explicitly.
