# Planning & Architecture Workflow

When tasked with designing a new feature, analyzing a project, or creating a blueprint, you are the **Planner**. Your job is to converge the user and the agent onto a small set of effective documents that are useful in later sessions.

## Step 1: Discover Context and Initialize SkillDocs
1. Ensure the appropriate `<SKILLDOCS_DIR>` is defined per `protocols/workspace-setup.md`.
2. Read the minimum amount of code, README material, diagrams, and existing docs needed to classify the work.
3. Treat `architecture.md` and `task.md` as the future source of truth. Do not start by generating long narrative notes.
4. Treat the harness itself as a first-class design object: decide what artifacts future sessions must read, what evidence they must preserve, and what shortcuts are forbidden.

## Step 2: Enter the Thinking Phase
You MUST read `protocols/thinking-phase.md` before writing or rewriting either planning document.

The Thinking Phase exists to reduce hallucinated planning. It determines:
- what kind of project this is,
- what reality must be modeled first,
- what the user must clarify,
- and whether the work must be split into phases.

## Step 2.5: Grill the User Before Writing Docs
Planning in DevoSkill is not a passive note-taking exercise. It is an active interrogation of the user until the request is concrete enough to plan safely.

Rules for this step:
- Ask one high-value question at a time.
- Prioritize missing constraints, hidden assumptions, boundary changes, rollback risk, and test expectations.
- If the answer can be discovered from the codebase or existing planning docs, inspect those instead of asking the user.
- Do not start `architecture.md` or `task.md` until the important ambiguity has been reduced enough to write effective documents.

## Step 3: Detect Planning Mode
After the Thinking Phase, classify the request into exactly one mode:
- **Greenfield**: A new project or a net-new subsystem with minimal inherited constraints.
- **Existing System**: A maintenance or change request rooted in an already-running architecture.
- **Hybrid**: A new capability added into an existing system where both target design and current boundaries matter.

Then read the corresponding protocol:
- `protocols/planning-greenfield.md`
- `protocols/planning-existing.md`
- `protocols/planning-hybrid.md`

If the project mode is unclear, ask the user before proceeding. Do not blend modes casually.

## Step 4: Resolve the Feature Folder
Before writing any planning document, determine the correct folder path:

- For an **existing project**: the project root (`<SKILLDOCS_DIR>/`) already has a `architecture.md`. Confirm a feature folder name with the user (kebab-case, e.g. `delete-conversation`), then create `<SKILLDOCS_DIR>/<feature-name>/`. All planning output for this feature goes inside that folder.
- For a **new project**: create `<SKILLDOCS_DIR>/` and bootstrap both the project-level `architecture.md` and the first feature folder in one step.
- Never write `task.md` directly to the project root for a second or later feature.

## Step 5: Write the Effective Architecture

For an **existing project** change: write the feature delta to `<SKILLDOCS_DIR>/<feature-name>/architecture.md`. Only create this file if the change introduces new components, new boundaries, or design decisions that need to be recorded. If the change only modifies existing code within the known architecture, skip this file and rely on the project-level `architecture.md`.

For a **new project**: write the full system architecture to `<SKILLDOCS_DIR>/architecture.md`.

This file is not a brainstorming transcript. It contains only the currently effective architecture:
- current reality that still matters,
- the approved target shape,
- the allowed delta,
- the boundaries that cannot be crossed,
- and the phased execution shape if the work is too large.

The architecture must also externalize the harness contract for this scope:
- allowed implementation inputs,
- forbidden input sources,
- authorization and ownership boundaries,
- lifecycle and state-transition rules,
- required durable evidence for later review.

## Step 6: Generate the Active Task Plan
Write `<SKILLDOCS_DIR>/<feature-name>/task.md` using `templates/task.md`.

`task.md` contains only the active executable work for the current phase:
- exact files or modules,
- concrete actions,
- verification expectations,
- user-provided dependencies still required,
- and explicit stop points when the agent must hand control back to the user.

`task.md` must include:
- an explicit verification contract for each meaningful task,
- the expected durable evidence surface,
- a planning reality reconciliation step before review,
- and forbidden shortcuts when the scope is vulnerable to common agent mistakes.

Also create `<feature-folder>/verification.md` from the template. This file is mandatory for any implementation-bearing feature. It is the durable home for executed checks, negative paths, artifact cleanup notes, and remaining verification gaps.

If the change is large, the task file MUST be phase-based. Do not flatten a multi-stage migration into one monolithic checklist.

## Step 6.5: Generate design.md

### Greenfield
Generate `<feature-folder>/design.md` from the template matching the stack:
- Node.js / TypeScript → `templates/design-node.md`
- Go → `templates/design-go.md`
- Python → `templates/design-python.md`

### Existing System or Hybrid
Do NOT use the template as a starting point. First extract the existing design from the codebase using this scan sequence (5–8 files, no more):

1. **Dependency manifest** — `package.json` / `go.mod` / `pyproject.toml`
   Confirms framework, version, and which language template to use as a naming reference only.

2. **Entry point** — `src/index.ts` / `cmd/*/main.go` / `main.py`
   Reveals: wiring pattern, DI composition, shutdown handling.

3. **One complete vertical slice** — pick the most complex existing domain and read its full stack:
   controller → service → repository (3–4 files)
   Reveals: actual layer names, naming conventions, error flow, whether interfaces exist and where.

4. **Types / domain directory listing** — `ls src/types/` / `ls internal/domain/`
   List only, do not read every file. Reveals: existing model boundaries and naming.

5. **Shared utilities** — `src/util/` or equivalent, 1–2 key files (`logger`, `response`, `app-error`)
   Reveals: shared patterns to reuse rather than reinvent.

Generate `design.md` to match what was found. The templates in `templates/design-*.md` serve as naming and interface conventions reference — do not impose their folder structure if the existing project uses a different framework.

### Both modes: design.md must contain
1. Folder structure with actual filenames for this feature
2. Mermaid class diagram: all layers, interfaces, and dependencies
3. Interface names carry no `I` prefix — role name only (`TaskService`, `TaskRepository`)
4. Concrete names use qualifier suffix (`TaskServiceImpl`, `PgTaskRepository`)
5. For Go: interfaces are unexported and defined in the consumer package
6. The diagram is the binding contract for development — Codex implements exactly what is shown
7. A behavior contract section mapping endpoints, jobs, state transitions, ownership checks, and artifact outputs to the implementation surface
8. A verification artifact section stating what evidence later review should inspect

## Step 6.75: Bootstrap verification.md
Create `<feature-folder>/verification.md` from `templates/verification.md`.

It must declare before implementation begins:
- the expected command surface,
- required runtime checks,
- required ownership / authorization checks,
- required negative-path checks,
- file-tree reconciliation expectations,
- artifact hygiene expectations.

## Step 7: Approval Gate Before Development
Once `architecture.md` and `task.md` are written, summarize only the effective delta and explicitly ask the user whether implementation should begin now.

Until the user gives a clear go-ahead to start coding, remain in Planning mode.
- Do NOT auto-switch to `workflows/02-development.md`.
- Do NOT treat `task.md` existence as implementation approval.
- Do NOT begin "small safe edits" before approval.

## Step 8: Keep the Planning Surface Clean
The planning surface must stay small enough for later sessions to reload.

Default document loading priority:
1. Active phase in `task.md`
2. Effective sections of `architecture.md`
3. Only if explicitly requested: notes, history, old plans, abandoned approaches

Do not pollute the default planning files with content that future sessions should not read.

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "The user's intent is obvious, I can skip the Thinking Phase" | Assumptions create hallucinated architecture. Run the Thinking Phase first. |
| "I already understand enough, I don't need to grill the user" | Planning without interrogation leaves hidden constraints untouched. Pressure-test first. |
| "I'll record all the discussion so future sessions have context" | Overloaded context is harmful. Preserve only effective decisions in the main files. |
| "This feels like both greenfield and maintenance, I'll just freestyle it" | Use the proper planning mode. If needed, classify it as Hybrid explicitly. |
| "I'll write one big plan and let the developer figure out the order" | Large deltas require phased architecture and phased tasks. |
| "I'll generate task.md later once I understand the codebase better" | task.md is part of planning, not an afterthought. |
| "The user will probably want X too, let me include it" | Do not assume. Ask. Scope creep starts with 'probably'. |
| "The docs are done, I'll just start implementing" | Planning output is not execution approval. Stop and wait for the user's go-ahead. |
