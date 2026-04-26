# Registry Routing Protocol

Use this protocol when a DevoSkill route, project/domain skill, or durable knowledge surface exposes a lightweight registry instead of loading all available files up front.

Its purpose is to give DevoSkill one shared routing model for token-efficient discovery while preserving router-first prompt control.

## Design Intent
- keep the first read surface thin
- let filenames and lightweight registry entries advertise available files
- load detailed files only when the current action actually needs them
- keep the current route or phase instruction close to the latest prompt context
- depend on precise initial prompts so project, phase, current action, and concern are classified correctly
- avoid global indexes that compete with the primary router

## Registry Layers
Registries are selectors, not authorities.

- The primary DevoSkill `SKILL.md` router selects the active phase.
- Phase skills may point to phase-local registries when the next layer contains many optional workflows or concerns.
- Project/domain skills may expose `registry.md` plus phase-local discovery files.
- Durable knowledge surfaces, such as project-root `study/`, may expose `study/registry.md` when there are enough study files that reading filenames or full documents would waste context.

Do not introduce a registry for a small fixed set that the current route can name directly.

## Required Registry Shape
- one clear owner or scope
- one lightweight `registry.md` describing available files
- optional phase-local discovery files, such as `phases/design.md`
- detailed concern, workflow, or study files outside the registry

## Routing Algorithm
1. Classify the active DevoSkill phase first.
2. Classify the project/domain or durable knowledge surface only when the active phase needs that layer.
3. Load the owning entrypoint, then the matching phase-local discovery file only when one exists.
4. Read the lightweight `registry.md` or equivalent thin rules index to learn:
   - available filenames
   - supported phases
   - trigger hints
   - intended use moments
5. Do not read detailed concern files yet.
6. As the current action becomes concrete, such as naming a class, defining a failure contract, reviewing a boundary, or learning a subsystem, load only the matching file.
7. If more than one file appears relevant, load the smallest set whose triggers match the current action.

## Classification Surface
- `phase` answers: which primary route owns the latest instruction context
- `project/domain` answers: which skill tree owns scoped rules
- `knowledge surface` answers: which durable study or document set may contain reusable understanding
- `phase-local discovery` answers: which scoped discovery file to read first
- `current action` answers: which concern, workflow, or study file to load now

Do not collapse these into one step. Wrong phase or wrong project selection causes later concern routing to drift and wastes prompt weight on irrelevant instructions.

## Registry Minimum Bar
Each lightweight registry should make the following visible without requiring detailed-file reads:
- filename
- supported phase or phases
- trigger hints
- short "use when" description

## Anti-Patterns
- reading every detailed file just because the registry exists
- putting full rule bodies into the registry
- skipping project/phase classification and jumping directly to concern filenames
- treating the registry as a substitute for a precise initial prompt
- creating a global index that bypasses the active route
- loading a registry after the detailed files it was meant to select

## Persistence Rule
- Shared/company-level rules still belong in DevoSkill shared protocols when appropriate.
- Project/domain rules belong in the project/domain skill that owns them.
- Reusable system understanding belongs in project-root `study/`; a `study/registry.md` may advertise it but does not replace it.
- The registry protocol standardizes routing; it does not centralize ownership.
