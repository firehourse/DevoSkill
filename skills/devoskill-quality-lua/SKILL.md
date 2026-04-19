---
name: devoskill-quality-lua
description: Lua-specific quality rules for DevoSkill. Load alongside devoskill-quality when the implementation includes Lua code. Covers module patterns, pcall/error handling, nil guards, Neovim API usage, timer lifecycle, namespace/extmark hygiene, and magic string avoidance.
---

# DevoSkill Quality — Lua

Load this skill in addition to `../devoskill-quality/SKILL.md` whenever the implementation includes Lua code.

## Load Order
1. Confirm `../devoskill-quality/SKILL.md` has already been loaded
2. Read `../devoskill/workflows/quality-lua.md`
3. Apply every category against the Lua source files in the implementation

## Required Behavior
- Apply Lua-specific checks after the general quality checks pass.
- Use the examples to pattern-match — if produced code matches a ❌ pattern, fix it before writing back to `task.md`.
- Do not skip a category because the code "looks fine" — verify against the principle explicitly.
