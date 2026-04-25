# Rule Registry Routing Protocol

Use this protocol when a project/domain skill exposes a lightweight rules registry and phase-local discovery files instead of loading all concern rules up front.

Its purpose is to give DevoSkill one shared routing model for project-specific engineering rules without forcing DevoSkill shared protocols to own those rules.

## Design Intent
- keep the first read surface thin
- let filenames and lightweight registry entries advertise available rules
- load detailed concern rules only when the current action actually needs them
- depend on precise initial prompts so project, phase, and current action are classified correctly

## Required Project Skill Shape
- one project/domain skill entrypoint
- one lightweight `registry.md` describing available rules
- one or more phase-local discovery files, such as `phases/design.md`
- one or more detailed concern files under `protocols/`

## Routing Algorithm
1. Classify the project/domain from repo/path context or explicit user intent.
2. Classify the active DevoSkill phase first.
3. Load the project skill entrypoint, then the matching phase-local discovery file only.
4. Read the lightweight `registry.md` or equivalent thin rules index to learn:
   - available rule filenames
   - supported phases
   - trigger hints
   - intended use moments
5. Do not read detailed concern files yet.
6. As the current action becomes concrete, such as naming a class, defining a failure contract, or reviewing a boundary, load only the matching concern file.
7. If more than one concern appears relevant, load the smallest set whose triggers match the current action.

## Classification Surface
- `project/domain` answers: which skill tree owns the rules
- `phase` answers: which discovery file to read first
- `current action` answers: which concern file to load now

Do not collapse these into one step. Wrong phase or wrong project selection causes the later concern routing to drift.

## Registry Minimum Bar
Each lightweight rules registry should make the following visible without requiring concern-file reads:
- rule filename
- supported phase or phases
- trigger hints
- short "use when" description

## Anti-Patterns
- reading every concern file just because the registry exists
- putting full rule bodies into the registry
- skipping project/phase classification and jumping directly to concern filenames
- treating the registry as a substitute for a precise initial prompt

## Persistence Rule
- Shared/company-level rules still belong in DevoSkill shared protocols when appropriate.
- Project/domain rules belong in the project/domain skill that owns them.
- The registry protocol standardizes routing; it does not centralize rule ownership.
