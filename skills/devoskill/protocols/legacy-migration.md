# Legacy Migration Protocol

Primary question: how may legacy material (docs or code) that predates a current standard be brought up to that standard?

**Principle:** legacy is never exempt from current standards. There is no grandfathering. The protection for old material is not "don't touch" — it is "touch under contract": any migration must be deliberate, scoped, and provably behavior-preserving.

## Required Check

- Migration is its own scoped task with an explicit change boundary. Never bundle legacy cleanup into unrelated feature work as a drive-by edit (`surgical-change-boundary.md` still governs feature work).
- **Code:** refactoring and optimization of old code are allowed when observable behavior is unchanged — proven by running the relevant tests before and after (add focused tests first if none exist). Performance claims require a measurement, not an assertion.
- **Docs:** moves, renames, splits, and re-indexing are allowed when no information is lost and every inbound pointer (links, registry rows, `../` references, skill references) is updated in the same change.
- If equivalence cannot be verified, it is not a migration — return to Planning and treat it as a real change with its own contract.
- Record evidence (before/after file lists, test output, grep of inbound references) in `verification.md`, or in the eval `runs.md` when the migration targets DevoSkill itself.

| | Example | Why |
|---|---|---|
| ❌ | "This twin folder is old — permanently exempt, don't touch it" | Debt becomes permanent; old surfaces keep teaching agents the wrong shape. |
| ✅ | Open a scoped migration task: move study-grade files from `notes/` into `study/`, build the registry, grep and update every inbound reference to the old paths, record the evidence, done | Debt shrinks; current state stays correct throughout. |
| ❌ | Reshaping an old folder "while you're in there" inside the same diff as a feature fix | Mixes two contracts; review cannot tell fix from migration, and a migration bug contaminates the feature. |
| ✅ | Feature work keeps its surgical boundary; legacy debt discovered along the way becomes its own migration task | Each change stays independently reviewable and revertible. |

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Nobody reads the old material, no verification needed" | Future sessions will read it. An unverified move is exactly how information gets lost. |
| "It's just moving files, not a change" | Paths are interfaces. A broken pointer is a derived bug. |
| "I'm already in here, might as well fix a bit more" | Anything beyond the migration boundary is scope bleed — return to Planning. |

## Red Flags — If You Think This, Stop

- "It's old, just leave it as is"
- "Move first, fix the references later"
- "The contents are basically the same, merge them into one" (merging risks information loss → keep both, mark the overlap in the registry; merging is a separate change that needs approval)
