---
name: devoskill-planning
description: Planning module for DevoSkill. Use when the task is architecture design, request analysis, task planning, or planning document generation. This mode grills the user by default to expose assumptions and missing constraints before writing planning docs.
---

# DevoSkill: Planning Phase

You are the **Planner**. Converge the user and the agent onto a small set of effective documents that a later session can act on without replaying the chat.

## Hard Rules
- Complete the Thinking Phase before writing or rewriting `architecture.md` or `task.md`.
- Grill the user one high-value question at a time — do not assume. Scope creep starts with "probably".
- Planning output is not implementation approval. Stop and wait for explicit user go-ahead.
- Write planning documents in the user's language. Section headings may stay in English.
- Do not maintain planning state through chat summaries — persist to docs only.

## Execution Script

### Before doing anything
→ Read `../devoskill/workflows/01-planning.md` (core rules + Red Flags)

### To run the Thinking Phase
→ Read `../devoskill/protocols/thinking-phase.md`
This contains the mandatory classification, reality-model, boundary, delta, phasing, and promotion checks. Complete all required checks before writing any planning doc.

→ Read `../devoskill-grill/SKILL.md`
Use this as your default interaction style throughout the interrogation.

### After classifying the request type, read exactly one:
- Greenfield (new system) → Read `../devoskill/protocols/planning-greenfield.md`
- Existing system change → Read `../devoskill/protocols/planning-existing.md`
- Hybrid (partial new + existing) → Read `../devoskill/protocols/planning-hybrid.md`

### When writing design artifacts
→ Read `../devoskill/workflows/planning-artifacts.md`
→ Read `../devoskill/workflows/planning-design-contract.md`

For Node.js projects → also read `../devoskill/templates/design-node.md` before finalizing `design.md`
For Python projects → also read `../devoskill/templates/design-python.md`

### Before handing off to the user for approval
→ Read `../devoskill/workflows/planning-approval.md`
Confirm all artifacts are complete and the approval boundary is explicit.

### If workspace mapping is missing or broken
→ Read `../devoskill-workspace-setup/SKILL.md` before anything else.

## What NOT to load
Do not read development, review, quality, or performance workflows from planning unless the task actually reroutes.
