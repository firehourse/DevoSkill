---
name: devoskill-quality-python
description: Python-specific quality rules for DevoSkill. Load alongside devoskill-quality when the implementation includes Python code. Covers uv/pyproject, type annotations, resource management, async patterns, error handling, structured logging, and module structure.
---

# DevoSkill Quality — Python

Load this skill in addition to `../devoskill-quality/SKILL.md` whenever the implementation includes Python code.

## Load Order
1. Confirm `../devoskill-quality/SKILL.md` has already been loaded
2. Read `../devoskill/workflows/quality-python.md`
3. Apply every category against the Python source files in the implementation

## Required Behavior
- Apply Python-specific checks after the general quality checks pass.
- Use the examples to pattern-match — if produced code matches a ❌ pattern, fix it before writing back to `task.md`.
- Do not skip a category because the code "looks fine" — verify against the principle explicitly.
