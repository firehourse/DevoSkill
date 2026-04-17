---
name: devoskill-quality
description: Quality gate module for DevoSkill. Use at the end of any implementation phase to verify technical correctness.
---

# DevoSkill: Quality Gate

Run after implementation is complete, before writing back to `task.md`.

## How to apply
Do not load all category files upfront. Read each file **immediately before** applying that category's checks, then fix any failures before moving to the next category. This keeps each rule fresh in context at the moment of application.

## Check Sequence

### 1. Resource Safety
→ Read `../devoskill/workflows/quality-resource-safety.md`
Apply. Fix failures. Then proceed to next category.

### 2. Resilience
→ Read `../devoskill/workflows/quality-resilience.md`
Apply. Fix failures. Then proceed.

### 3. Hygiene
→ Read `../devoskill/workflows/quality-hygiene.md`
Apply. Fix failures. Then proceed.

### 4. Identity
→ Read `../devoskill/workflows/quality-identity.md`
Apply. Fix failures. Then proceed.

### 5. Frontend (only if implementation includes frontend code)
→ Read `../devoskill/workflows/quality-frontend.md`
Apply. Fix failures. Then proceed.

### 6. Node.js / TypeScript (only if implementation includes Node.js code)
→ Read `../devoskill/workflows/quality-node.md`
Apply. Fix failures. Then proceed.

### 7. Go (only if implementation includes Go code)
→ Read `../devoskill-quality-go/SKILL.md`
Apply. Fix failures. Then proceed.

## Done condition
All applicable categories pass with no remaining failures. Write back to `task.md`.
