---
name: devoskill-quality-ruby
description: Ruby on Rails-specific quality rules for DevoSkill. Load alongside devoskill-quality when the implementation includes Ruby or Rails code. Covers existing Rails style conformance, fat model/thin controller, service objects, ActiveRecord query discipline, strong parameters, background jobs, structured logging, error handling, and migration safety.
---

# DevoSkill Quality — Ruby on Rails

Load this skill in addition to `../devoskill-quality/SKILL.md` whenever the implementation includes Ruby or Rails code.

## Load Order
1. Confirm `../devoskill-quality/SKILL.md` has already been loaded
2. Read `../devoskill/protocols/rails-maintenance-mode.md`
3. Read `../devoskill/workflows/quality-ruby.md`
4. Apply every category against the Ruby source files in the implementation

## Required Behavior
- Apply Ruby/Rails-specific checks after the general quality checks pass.
- State whether the touched Rails code is Conservative Rails Maintenance or Explicit Modernization before checking style and abstractions.
- Use the examples to pattern-match — if produced code matches a ❌ pattern, fix it before writing back to `task.md`.
- Do not skip a category because the code "looks fine" — verify against the principle explicitly.
