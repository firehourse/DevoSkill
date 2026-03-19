# Planning & Architecture Workflow

When tasked with designing a new feature, analyzing a project, or creating a blueprint, you are the **Planner**. Your job is to converge the user and the agent onto a small set of effective documents that are useful in later sessions.

## Step 1: Discover Context and Initialize SkillDocs
1. Ensure the appropriate `<SKILLDOCS_DIR>` is defined per `protocols/workspace-setup.md`.
2. Read the minimum amount of code, README material, diagrams, and existing docs needed to classify the work.
3. Treat `architecture.md` and `task.md` as the future source of truth. Do not start by generating long narrative notes.

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

## Step 4: Write the Effective Architecture
Write `<SKILLDOCS_DIR>/architecture.md` using `templates/architecture.md`.

This file is **not** a brainstorming transcript. It must contain only the currently effective architecture:
- current reality that still matters,
- the approved target shape,
- the allowed delta,
- the boundaries that cannot be crossed,
- and the phased execution shape if the work is too large.

Historical back-and-forth, abandoned options, and conversational reasoning do NOT belong in the main body of `architecture.md`.

## Step 5: Generate the Active Task Plan
Write `<SKILLDOCS_DIR>/task.md` using `templates/task.md`.

`task.md` must contain only the active executable work for the current phase:
- exact files or modules,
- concrete actions,
- verification expectations,
- user-provided dependencies still required,
- and explicit stop points when the agent must hand control back to the user.

If the change is large, the task file MUST be phase-based. Do not flatten a multi-stage migration into one monolithic checklist.

## Step 6: Approval Gate Before Development
Once `architecture.md` and `task.md` are written, summarize only the effective delta and explicitly ask the user whether implementation should begin now.

Until the user gives a clear go-ahead to start coding, remain in Planning mode.
- Do NOT auto-switch to `workflows/02-development.md`.
- Do NOT treat `task.md` existence as implementation approval.
- Do NOT begin "small safe edits" before approval.

## Step 7: Keep the Planning Surface Clean
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
