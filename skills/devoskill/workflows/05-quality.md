# Quality Workflow

The quality gate entry point is `../../devoskill-quality/SKILL.md`. Load that skill to run quality checks.

## How quality checks work in DevoSkill

Quality categories are not loaded all at once. Each category file is read **immediately before** applying that category's checks, then failures are fixed before moving to the next category. This follows the just-in-time loading principle in `doctrine.md` Section 2: the rule is freshest — and attention is strongest — at the bottom of the active context, which is exactly when it is about to be applied.

## Category files

Each file is self-contained and should be read on demand:

- `quality-resource-safety.md` — resource lifecycle, config application, input validation
- `quality-resilience.md` — graceful shutdown, fault tolerance, async task state machines
- `quality-hygiene.md` — Redis TTLs, gitignore discipline, verification evidence
- `quality-identity.md` — secure identifiers, authorization surface
- `quality-frontend.md` — frontend async hygiene (load only for frontend code)
- `quality-node.md` — Node.js / TypeScript specific checks (load only for Node.js code)
- `quality-go.md` — Go specific checks (load only for Go code)

## Language-specific skills

Node.js → also load `../../devoskill-quality-node/SKILL.md`
Go → also load `../../devoskill-quality-go/SKILL.md`
