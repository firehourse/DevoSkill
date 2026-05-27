# Subagent Orchestration & Interaction

This protocol defines how a primary Agent should delegate tasks to, context-switch with, or simulate Subagents within the DevoSkill environment. This ensures clarity, precise context boundary management, and strict separation of concerns.

## 0. Subagent Router Bootstrap (Non-Negotiable)

**Subagents must run the DevoSkill router themselves; they do not inherit the orchestrator's route.**

Harness-spawned subagents typically do not see workspace-level `CLAUDE.md` reliably, and `UserPromptSubmit`-style anchoring hooks do not fire on subagent invocations. A subagent that is handed a "file list + task" without route discipline runs without doctrine § 2 attention anchoring, doctrine § 11 router-first invariant, or any of the per-phase Required Behavior. That is a silent regression of the whole framework for the duration of the delegated task.

Therefore every subagent prompt the orchestrator emits must open with a router-bootstrap preamble. Use this template verbatim, replacing `{ROUTE}` with the route the orchestrator has already classified the subtask into and `{DEVOSKILL_ROOT}` with the absolute path to the local DevoSkill clone:

```text
You are operating inside DevoSkill. Before doing anything else:

1. Read `{DEVOSKILL_ROOT}/skills/devoskill/SKILL.md` (router).
2. Confirm the route is `{ROUTE}` for this subtask. If you would classify it differently, stop and report back to the orchestrator instead of acting on a wrong route.
3. Read `{DEVOSKILL_ROOT}/skills/devoskill-{route}/SKILL.md` and apply its load order and Strongest-Attention Rules.
4. Announce the route at the top of your first reply so the orchestrator can verify (e.g. "Subagent route: Review").
5. Only after steps 1-4, act on the task below.
```

Orchestrator obligations:
- Always supply `{DEVOSKILL_ROOT}` as an absolute path; do not assume the subagent resolves it from environment.
- State the classified `{ROUTE}` explicitly in the prompt — the subagent verifies, it does not classify from scratch.
- If the subagent reports back with a different route, treat that as a routing dispute and re-classify in the parent context before re-delegating; do not silently accept the subagent's route override.
- Subagents that are explicitly read-only research helpers (e.g. an `Explore` agent looking up file paths) may skip steps 2-3 only when the orchestrator's prompt names the read-only research scope; the bootstrap preamble itself still appears.

Subagent obligations:
- The visible route announcement is mandatory even when the answer is short.
- If the subtask reroutes mid-execution (e.g. Inquiry resolves into a needed Update), stop and return control — do not silently switch routes inside the delegated task.
- Strongest-Attention Rules from the route's SKILL.md still apply inside the subagent, including any output-shape, file-write, or destructive-action constraints.

This is doctrine § 11 ("Router first, details later") applied to the subagent boundary. The same router invariant that governs the primary agent governs every delegated task.

### Red Flags — Emit the Bootstrap Anyway

- "It's just a small read task"
- "The subagent already has the context"
- "We're in a hurry, skip the preamble"
- "It's read-only, the route doesn't matter"

Each still produces a route-less subagent — a silent framework regression. The preamble is cheap; emit it.

## 1. Interaction Primitives

When invoking a Subagent (e.g., `planner`, `developer`, `reviewer`), you must:
1. **Explicitly Specify the Target Files:** A Subagent only needs the *exact* subset of documents relevant to its task. Do not pass the entire project space.
2. **Define the Expected Output:** The Subagent must return discrete file modifications (`task.md`, `architecture.md`, `src/*.py`)—not a conversational summary.
3. **Assert the Planning Surface Limit:** Every Subagent call implicitly carries the `< 600 lines per effective DevoSkill markdown file` constraint for `architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, project-root `project-changelog.md`, loaded `study/*.md`, and loaded notes. This constraint is for documentation only, not implementation source files.
4. **Pass Only Effective Planning Context:** Default context is the active phase in `task.md`, the effective sections of `architecture.md`, and any directly required code or contracts. Do not pass project `study/` or `project-changelog.md` unless the task explicitly requires reusable context or change rationale.
5. **Respect Human Handoffs:** If schema, credentials, production state, or sensitive operations depend on the user, the subagent must stop at that boundary.

## 2. Core Subagent Definitions & Required Contexts

### The Planner Subagent
**Role:** Generates effective architecture and active task plans (`architecture.md`, `task.md`).
**Required Inputs:**
- User intent/specifications.
- Thinking Phase classification.
- If existing or hybrid project: current reality and allowed delta.
- Standard Template: `{DEVOSKILL_ROOT}/skills/devoskill/templates/architecture.md`.

### The Developer Subagent
**Role:** Executes code line-by-line exactly as dictated by the pre-approved `task.md`.
**Required Inputs:**
- The active phase in `task.md`.
- The effective architecture sections referenced by that phase.
- Ensure the project root's `.devoskill/` symlink exists and points to `<workspace_path>/docs/<project>`.
- *Strict Rule:* The Developer does not alter the architecture. If architecture changes are required, it must halt and return control to the Orchestrator/Planner.

### The Reviewer Subagent
**Role:** Reviews the git diffs against the effective `architecture.md` and active `task.md` to ensure structural alignment.
**Required Inputs:**
- The updated source code (or diffs).
- The effective architecture sections.
- The active task phase.

## 3. Session Isolation Mechanism
When communicating with the user or transitioning between phases, explicitly state:
*"Delegating to [Subagent Name] with context [File List]. Output expects [File Updates]."*

## 4. Context Budget Rule
The orchestrator is responsible for preventing context explosion.

- Prefer passing file excerpts, phase summaries, and specific interfaces over entire repositories.
- Prefer the current phase over all phases.
- Prefer feature planning docs over `study/` when the feature already promoted the needed facts.
- Prefer effective architecture over `project-changelog.md`.
- If a subagent needs more context, expand narrowly and explicitly instead of sending everything.
