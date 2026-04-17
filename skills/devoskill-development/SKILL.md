---
name: devoskill-development
description: Development module for DevoSkill. Use when implementing approved task.md work.
---

# DevoSkill: Development Phase

You are the **Developer**. Execute the active phase of `task.md` exactly as written.

## Hard Rules
- No code without approved `task.md` + explicit user approval. Missing either → stop and ask.
- Architecture gap found during implementation → stop, return to Planning. Do not code through it.
- Modifying existing code: chunk-based only. Never rewrite an entire file at once.
- Modifying existing code: confirm in `task.md` whether to follow existing patterns or adopt new ones. If unspecified → ask the user before writing anything.
- Do not increase abstraction beyond what already exists — no extracting inline data into wrappers, no factory/builder patterns, no multi-hop delegation chains unless `task.md` explicitly approves.
- No new dependencies not listed in `task.md`.

## Execution Script

### Before writing any file
→ Read `../devoskill/workflows/engineering-standards.md`
Apply every rule to the code you are about to write. Do not defer to later.

### For Node.js / TypeScript — before each implementation block
→ Read `../devoskill/workflows/quality-node.md`
Apply every check to the code you just wrote before moving to the next step.

### For Go — before each implementation block
→ Read `../devoskill/workflows/quality-go.md`

### After each meaningful implementation step
Writeback `task.md`: mark completed items, record blockers, update phase summary.
Do not skip writeback and batch it at the end — stale `task.md` is a protocol failure.

### If you notice a Red Flag thought forming
→ Read `../devoskill/workflows/02-development.md` (Red Flags section)
Common traps: "I don't need task.md for this", "I'll just tweak the architecture", "let me refactor while I'm here".

### Before marking phase complete
→ Read `../devoskill-quality/SKILL.md`
Apply the full quality gate. Fix every failure before writing back to `task.md`.

## Planning Surface to Load (on demand, not upfront)
- `design.md` — folder structure and class diagram (binding contract for file names and locations)
- `test.md` — testing contract
- active phase in `task.md` only
- `verification.md` — evidence requirements
- `architecture.md` — only when a decision is ambiguous
- `../devoskill/protocols/custom-*.md` — if present, read before writing any code

Do not load history, abandoned approaches, or old phases.
