---
name: devoskill-quality-go
description: Go-specific quality and engineering rules for DevoSkill. Load alongside devoskill-quality when the implementation includes Go code. Covers signal handling, context propagation, goroutine lifecycle, concurrency, deferred cleanup, structured logging (slog), package structure, and interface placement.
---

# DevoSkill Quality — Go

Load this skill in addition to `../devoskill-quality/SKILL.md` whenever the implementation includes Go code.

## Load Order
1. Confirm `../devoskill-quality/SKILL.md` has already been loaded
2. Read `../devoskill/workflows/quality-go.md`
3. Apply every category against the Go source files in the implementation

## Required Behavior
- Apply Go-specific checks after the general quality checks pass.
- Use the examples to pattern-match — if produced code matches a ❌ pattern, fix it before writing back to `task.md`.
- Do not skip a category because the code "looks fine" — verify against the principle explicitly.
