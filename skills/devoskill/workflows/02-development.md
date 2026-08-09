# Development Workflow

When tasked with implementing an approved feature, you are the **Developer**. The plan defines the outcome, consequential decisions, and safety boundary; current repository reality determines the best implementation inside that contract.

## Execution Protocol

### Step 1: Pre-Flight Environment Checks
1. For a code-changing task in Git, apply `protocols/git-worktree-isolation.md`. Create or resume the task worktree and confirm it is the current repository root before any mutation. Keep the primary checkout untouched.
2. Ensure the target `skilldocs` location exists in your context. Check for a local `.devoskill/` symlink. If missing, follow `protocols/workspace-setup.md`.
3. Identify the active feature folder. The project root's `.devoskill` symlink points to `<workspace_path>/docs/<project>`. The active feature folder is a named subdirectory inside it (e.g. `.devoskill/delete-conversation/`). If the user has not specified which feature is active, ask before loading any planning files.
4. Python Projects: Follow `templates/design-python.md` — `uv` is the only allowed package manager.
5. Load only the relevant planning surface in this order:
   - `<feature-folder>/design.md` — consequential boundaries, responsibilities, flows, and relevant structure; this is the binding implementation contract
   - `<feature-folder>/test.md` — the binding testing contract derived from `design.md`
   - the active phase in `<feature-folder>/task.md`
   - `<feature-folder>/verification.md` — the required evidence contract and output surface
   - `<feature-folder>/architecture.md` if it exists, then project-level `architecture.md` for baseline context
   - any human-provided contract or schema explicitly required by the task
6. Read `protocols/implementation-readiness-gate.md` and apply it to the active planning surface before writing any file. If the gate fails, stop and return to Planning even when the user has approved implementation.
7. At a new session, after a handoff, and after any meaningful discovery, re-anchor to reality: inspect the task branch, status, current diff, relevant code, and relevant tests before trusting the recorded next step.
8. Before writing a planned file, verify its name and location against `design.md`. A better private/local shape may be selected when it preserves the approved contract; update `design.md` before or with the code. Ask the user only when the change affects approved behavior, architecture boundaries, dependencies, data/security rules, operational risk, or scope.
9. Before coding, derive a short implementation checklist from the planning contract:
   - behavior contract entries,
   - authorization and ownership boundaries,
   - state transitions and lifecycle rules,
   - test suites and scenarios that must exist,
   - verification artifacts that must exist at the end.
10. Do NOT load `study/`, `project-changelog.md`, abandoned approaches, or old phases unless the user explicitly asks for them or the task needs reusable context or change rationale.
11. Confirm that implementation is explicitly approved in the active planning surface or by the user's current instruction. If approval is missing or ambiguous, stop and ask the user whether to begin implementation now.
12. Treat `protocols/document-system.md` as the shared contract for which document owns architecture, active work, design intent, evidence, and history.

### Step 2: Contract-Guided Adaptive Execution

**Principle:** Treat `task.md` as an outcome, constraint, and evidence checklist—not an immutable coding script or a ceiling on code quality. Preserve approved external contracts while using current code and tests to choose the simplest coherent implementation.

Required check — run this **Better Path Check** at session entry, after a failed assumption, and before each meaningful implementation slice:
- Does current repository reality invalidate or supersede an implementation detail in the plan?
- Can the same approved outcome be delivered with less duplication, clearer ownership, better modularity, or a cleaner test seam?
- Does the improvement preserve behavior, architecture boundaries, dependencies, data/security rules, operational risk, and scope?
- If yes, update the effective design/task detail and implement the better path. If no, stop and reroute to Planning or the user.

| | Example | Why |
|---|---|---|
| ❌ | Recreate a planned helper even though the repository now has a better shared boundary for the same operation. | Blind plan obedience duplicates logic and ignores current reality. |
| ✅ | Reuse the current boundary, update `design.md`/`task.md`, and keep the approved behavior and dependency set unchanged. | The contract remains stable while the code improves. |
| ❌ | Add a new framework because it makes the implementation cleaner. | Dependency and architecture changes exceed Development's discretion. |
| ✅ | Extract a focused local module that removes repeated invariants in the active flow without changing public behavior. | This is contract-safe implementation judgment. |

- **Consequential Decisions Stay Fixed**: Do not unilaterally change public behavior, system boundaries, third-party dependencies, authorization/data rules, rollout/operational risk, or feature scope.
- **Surgical Change Discipline**: Before editing, identify the `task.md` surgical change boundary. Every changed hunk must trace to the user request, an active task item, the behavior/design contract, or allowed cleanup. Apply `protocols/surgical-change-boundary.md`: focused, proportionate improvements to the active flow may stay; unrelated churn and unapproved lifecycle/timing/behavior changes may not.
- **Engineering Standards**: All produced code must conform to `workflows/engineering-standards.md` and the touched stack's mode. Apply its layer hierarchy only where the project/stack design calls for it; primary-flow clarity, naming, error context, logging, configuration, API safety, and file responsibility still apply.
- **Respect Human Handoffs**: If `task.md` marks a step as a user handoff, stop there. Do not guess through missing schema, missing contracts, sensitive credentials, or production-only operations.
- **Respect the Approval Gate**: A finished `task.md` is necessary but not sufficient. No code edits begin until the user has explicitly authorized implementation.
- **Respect Decision Completeness**: Active planning documents must select consequential behavior, boundaries, dependencies, risk controls, and verification. If any of those remain alternatives, stop and return to Planning; equivalent private implementation choices are yours to resolve.
- **Planning Surface Discipline**: If implementation requires expanding `architecture.md`, `task.md`, `design.md`, `verification.md`, or loaded notes beyond 600 lines, stop and split or trim the documentation surface before continuing. Do not treat this as a limit on implementation source files.
- **Test Contract Discipline**: Treat `test.md` as the required minimum. Do not drop or replace planned coverage silently; add tests for newly discovered in-scope risks and write the effective coverage back.
- **Behavior Contract Discipline**: Implement every documented endpoint, state transition, ownership rule, and stop condition exactly as written. Missing a negative path or boundary check is a contract failure, not an optional enhancement.
- **Artifact Hygiene Discipline**: Build outputs, dependency directories, uploads, traces, and generated assets must live only where the planning contract allows. Do not leave runtime artifacts in the tracked source tree unless the contract explicitly calls for them.

### Step 3: Maintenance & Refactoring Constraints
When modifying or refactoring **existing** code (as opposed to greenfield development), additional rules apply:

- **Reviewable Modifications**: Prefer cohesive, verifiable chunks. A full-file rewrite is acceptable only when the file is small/generated or the approved task genuinely replaces its responsibility and tests cover the behavior; do not use a rewrite merely to avoid understanding existing lifecycle semantics.
- **Convention With Judgment**: Preserve externally meaningful project conventions and lifecycle semantics. Do not copy a weak local shape merely because it already exists; improve the active flow when the reason is concrete and the result remains idiomatic for the stack.
- **Proportionate Abstraction**: Apply `workflows/engineering-standards.md` and `protocols/surgical-change-boundary.md`. Extract when it names a domain operation, isolates an I/O/error/authorization boundary, centralizes a repeated invariant, or creates a useful test seam. Keep code inline when extraction only adds navigation or hides ordering/lifecycle behavior.
- **Refactor Is Not Patch-Stacking**: When the current user request or active `task.md` explicitly includes refactoring, simplification, or readability improvement, do not treat the existing control-flow shape as immutable. Classify existing branches as must-preserve contract, compatibility shim, lifecycle guard, duplicate/redundant branch, or obsolete behavior. Collapse duplicate branches and remove unreachable or superseded code inside the approved touched surface. If the cleanup changes caller-visible behavior, stop and return to Planning so the behavior change is approved instead of hiding it inside implementation.

### Step 4: Architecture Drift Handling
If a discovery changes approved public behavior, system/component boundaries, dependencies, authorization/data contracts, migration/rollout semantics, operational risk, or feature scope:
- stop implementation,
- update the planner/user on the consequential fact,
- return to the Planning workflow,
- and do not silently patch the gap through implementation.

If the discovery changes only private structure, helper/module ownership inside an approved component, implementation order, or an equivalent test seam, select the better path, reconcile the active documents, and continue without seeking ceremonial re-approval.

If runtime reality contradicts an approved consequential decision, revise and re-approve it before implementation continues.

### Step 5: Persistence and Clean Execution
Produce functionality matching the requirements.
- **Do not generate conversational summaries**: Persist project state by updating the planning files, not by writing long chat recaps.
- **Mandatory Task Writeback**: After each meaningful implementation step, update `task.md` to reflect reality:
  - mark completed tasks and verification status,
  - record blockers or pending user handoffs,
  - record any Better Path decision that changed private implementation detail while preserving the approved contract,
  - update the active phase summary if the current execution state changed.
- **Mandatory Test Writeback**: If implementation changes approved test scope, methodology, or traceability, update `test.md` before declaring the phase complete.
- **Conditional Architecture Writeback**: If the finished implementation changed the effective architecture, constraints, boundaries, key flows, or approved target shape, update `architecture.md` before declaring the phase complete.
- **Mandatory Evidence Writeback**: If the task or design contract requires durable verification artifacts, create or update them before declaring the task complete.
- **Verification File Is Mandatory**: Raw checks, command outputs, test execution results, negative-path results, ownership tests, and cleanup notes belong in `verification.md`. Do not compress them into `task.md`.
- **Planning Reality Reconciliation**: Before marking the phase ready for review, compare `architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, and the actual file tree. If any of them disagree about active scope, artifact locations, delivered state, or cleanup status, reconcile them first.
- **File-Tree Reconciliation Is Concrete Work**: Compare the consequential boundaries and relevant structure in `design.md` with the actual tree. Update `design.md` for a justified in-contract private shape; remove accidental, generated, or out-of-boundary artifacts before declaring the phase complete.
- **Surgical Diff Reconciliation**: Before marking the phase ready for review, inspect the final diff and confirm every changed hunk maps to the surgical change boundary, applying `protocols/surgical-change-boundary.md`. Revert or hand back anything that fails its Decision Test; focused, proportionate active-flow improvements may stay.
- **No Silent Completion**: If code changed but `task.md` still reads like the work has not started, the phase is not complete.
- Once all tasks in the active phase are completed, writeback is done, and verification is recorded, run the Plan Conformance Checkpoint (Step 6), the Quality Gate (Step 7), and Closeout (Step 8). Only after those pass do you declare the phase completed and awaiting review.

### Step 6: Plan Conformance Checkpoint (self-check, mid + at completion)

Conformance to the approved plan is the Developer's own responsibility, not the Reviewer's — Review hunts code defects, it does not match the diff against the plan. Run this checkpoint **twice**: periodically mid-implementation (so drift is caught early, not at the end) and once at phase completion before the quality gate. These checks are already enforced piecewise in Steps 2/3/5; this step consolidates them into one named pass so nothing is silently skipped. Findings here are **fixed by you**, not just flagged — you are the author.

Required check:
- **Scope bleed**: every changed hunk traces to the user request, an active `task.md` item, the behavior/design contract, or allowed cleanup. No unauthorized paradigms, dependencies, or boundary crossings. Apply `protocols/surgical-change-boundary.md`.
- **Surgical-diff boundary**: inspect the diff against the `task.md` boundary; revert scope bleed and keep only active-flow improvements that pass all four Decision Test checks.
- **Implementation quality**: the code follows project/stack conventions where they serve the contract, and any new local abstraction has a concrete responsibility, boundary, invariant, or testability benefit.
- **Architecture alignment**: the resulting code still matches the effective `architecture.md`; if it diverged intentionally, the doc was updated (Step 4 / Step 5).
- **Phase integrity**: no work pulled in from future phases or abandoned plans.
- **Design / test / behavior contract completeness**: every documented class/flow, planned test, ownership/authorization boundary, and negative path is implemented and traceable.
- **Change-packet match** (when the planning surface uses `Behavior Delta` / change-packet terms): implemented behavior matches `Added`/`Changed`, removed behavior is handled, `Non-Goals` were not implemented (`protocols/change-review-packet.md`).

Note: **scope bleed and architecture drift get a decoupled re-verification at closeout** (`workflows/closeout-review.md` C8). A self-check cannot independently catch its own blind spots, so the fresh-eyes pass at handoff is intentional — do not treat this self-check as the last word on those two.

### Step 7: Pre-phase Completion Quality Gate

Before marking any implementation phase complete, load `{DEVOSKILL_ROOT}/skills/devoskill-quality/SKILL.md` and apply every relevant category in `workflows/05-quality.md` against the produced code. Fix any failures before writing back to `task.md`.

### Step 8: Closeout

After the conformance checkpoint and quality gate pass, run `{DEVOSKILL_ROOT}/skills/devoskill/workflows/closeout-review.md` before declaring the phase ready for review or handoff. It verifies doc-sync, evidence surface, task completion, and hygiene, and independently re-verifies scope bleed / architecture drift. Resolve its MUST findings before declaring ready.

---

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "This is too simple, I don't need task.md" | Simple tasks cause the most assumption errors. Write it in task.md, it takes 2 minutes. |
| "There is a task.md now, so I can start coding" | A task plan is not approval. Wait for explicit user authorization. |
| "The docs leave public behavior or a system boundary as A or B, so I will pick the cleaner one" | Consequential decisions must be selected in Planning. Local implementation alternatives inside a fixed contract are Development's responsibility. |
| "I'll read `study/`, `project-changelog.md`, and old notes to be safe" | Context overload makes execution worse. Load only the active planning surface unless reusable context or change rationale is required. |
| "Let me write the code first, I'll update docs later" | "Later" never comes. Docs first, code second. No exceptions. |
| "The code is done, I don't need to touch task.md" | Execution without writeback leaves the planning surface stale. Update `task.md` before claiming progress. |
| "The code drifted a bit, but architecture.md can stay as-is" | Effective architecture must describe the resulting system. Update it or return to planning. |
| "This new dependency only tweaks the architecture slightly" | Dependencies and system boundaries are consequential. STOP and return to Planning. |
| "The schema is probably X, I'll continue" | Missing contracts belong to the human handoff boundary. Ask instead of guessing. |
| "This dependency would be perfect, let me add it" | Dependency changes require Planning and approval; solve within the approved dependency set or reroute. |
| "The planning doc is only 580 lines, I can keep stuffing context into it" | 580 lines = split phases or move history out now, before the planning surface becomes unusable. |
| "The plan is approved, so new repository evidence cannot change my implementation" | Re-run the Better Path Check. Preserve the contract, not stale implementation detail. |
| "Let me refactor this while I'm here" | Apply the surgical boundary: a focused improvement to the active flow with a concrete benefit may stay; unrelated cleanup is scope bleed. |
| "This nearby comment/formatting/dead code is annoying, I'll clean it up" | If the current change did not create it and the user did not ask for it, report it instead of editing it. |
| "This code would be cleaner if I extracted it into a function" | Name the domain operation, boundary, invariant, or test seam it creates. If there is none, keep it inline. |
| "I'll reorganize private data for readability" | Continue only if external behavior/lifecycle stays fixed, the active flow benefits, and the effective design is written back. |
| "I'll do a quick full rewrite because it is faster than understanding the file" | Rewrite only when the responsibility is genuinely replaced and verification covers it; speed alone does not justify regression risk. |
| "The existing pattern is ugly, let me improve it" | Taste alone is insufficient. A bounded improvement with measurable clarity, duplication, ownership, or testability benefit is allowed. |
