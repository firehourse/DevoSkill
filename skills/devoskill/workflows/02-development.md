# Development Workflow

When tasked with implementing a feature based on a plan, you are the **Developer**. You execute code based explicitly on the current phase of `task.md` and the effective sections of `architecture.md`.

## Execution Protocol

### Step 1: Pre-Flight Environment Checks
1. Ensure the target `skilldocs` location exists in your context. Check for a local `.devoskill/` symlink. If missing, follow `protocols/workspace-setup.md`.
2. Identify the active feature folder. The project root's `.devoskill` symlink points to `<workspace_path>/docs/<project>`. The active feature folder is a named subdirectory inside it (e.g. `.devoskill/delete-conversation/`). If the user has not specified which feature is active, ask before loading any planning files.
3. Python Projects: Follow `templates/design-python.md` — `uv` is the only allowed package manager.
4. Load only the relevant planning surface in this order:
   - `<feature-folder>/design.md` — folder structure and class diagram; this is the binding implementation contract
   - `<feature-folder>/test.md` — the binding testing contract derived from `design.md`
   - the active phase in `<feature-folder>/task.md`
   - `<feature-folder>/verification.md` — the required evidence contract and output surface
   - `<feature-folder>/architecture.md` if it exists, then project-level `architecture.md` for baseline context
   - any human-provided contract or schema explicitly required by the task
5. Read `protocols/implementation-readiness-gate.md` and apply it to the active planning surface before writing any file. If the gate fails, stop and return to Planning even when the user has approved implementation.
6. Before writing any file, verify that its name and location match `design.md` exactly. If a discrepancy exists, update `design.md` and confirm with the user before proceeding.
7. Before coding, derive a short implementation checklist from the planning contract:
   - behavior contract entries,
   - authorization and ownership boundaries,
   - state transitions and lifecycle rules,
   - test suites and scenarios that must exist,
   - verification artifacts that must exist at the end.
8. Do NOT load `study/`, `project-changelog.md`, abandoned approaches, or old phases unless the user explicitly asks for them or the task needs reusable context or change rationale.
9. Confirm that implementation is explicitly approved in the active planning surface or by the user's current instruction. If approval is missing or ambiguous, stop and ask the user whether to begin implementation now.
10. Treat `protocols/document-system.md` as the shared contract for which document owns architecture, active work, design intent, evidence, and history.

### Step 2: Strict Adherence
Follow the active-phase tasks linearly based on `task.md`.
- **No Creativity in Architecture**: You are explicitly prohibited from unilaterally changing the architecture, adding third-party dependencies not mentioned in `task.md`, or reshaping the design scope.
- **Engineering Standards**: All produced code must conform to `workflows/engineering-standards.md`. Layer hierarchy (Router → Controller → Service → Repository), primary flow clarity, naming clarity, error context, structured logging, no magic values, API response shape, and file discipline are non-negotiable regardless of what task.md says. Language-specific sections and stack-specific quality workflows also apply.
- **Respect Human Handoffs**: If `task.md` marks a step as a user handoff, stop there. Do not guess through missing schema, missing contracts, sensitive credentials, or production-only operations.
- **Respect the Approval Gate**: A finished `task.md` is necessary but not sufficient. No code edits begin until the user has explicitly authorized implementation.
- **Respect Decision Completeness**: Active planning documents must contain one selected path for the active phase. If they present alternatives for you to choose during implementation, stop and return to Planning.
- **Planning Surface Discipline**: If implementation requires expanding `architecture.md`, `task.md`, `design.md`, `verification.md`, or loaded notes beyond 600 lines, stop and split or trim the documentation surface before continuing. Do not treat this as a limit on implementation source files.
- **Test Contract Discipline**: Do not improvise testing strategy during implementation. Follow `test.md` unless planning is updated first.
- **Behavior Contract Discipline**: Implement every documented endpoint, state transition, ownership rule, and stop condition exactly as written. Missing a negative path or boundary check is a contract failure, not an optional enhancement.
- **Artifact Hygiene Discipline**: Build outputs, dependency directories, uploads, traces, and generated assets must live only where the planning contract allows. Do not leave runtime artifacts in the tracked source tree unless the contract explicitly calls for them.

### Step 3: Maintenance & Refactoring Constraints
When modifying or refactoring **existing** code (as opposed to greenfield development), additional rules apply:

- **Chunk-Based Modifications**: Never rewrite an entire file at once. Break changes into logical sections/chunks. Modify one section, verify, then proceed to the next.
- **Style Conformance Gate**: Before rewriting any module, you MUST document in `task.md` whether to:
  1. **Follow Existing Patterns** — match the original codebase's conventions, data structures, and abstraction level, OR
  2. **Adopt New Patterns** — with explicit user approval and justification recorded in `architecture.md`.
  If `task.md` does not specify the approach, **ask the user**. Never decide unilaterally.
- **Anti-Over-Abstraction**: You are PROHIBITED from increasing abstraction layers beyond what the original code uses, unless explicitly approved. Specifically:
  - Do NOT extract inline arrays/objects into separate `const` declarations or wrapper functions.
  - Do NOT introduce factory patterns, builder patterns, or indirection layers that did not exist.
  - Do NOT split a simple direct implementation into multi-layer calls "for cleanliness".
  - If the original code uses a flat array of key-value pairs, keep it as a flat array.
- **Refactor Is Not Patch-Stacking**: When the current user request or active `task.md` explicitly includes refactoring, simplification, or readability improvement, do not treat the existing control-flow shape as immutable. Classify existing branches as must-preserve contract, compatibility shim, lifecycle guard, duplicate/redundant branch, or obsolete behavior. Collapse duplicate branches and remove unreachable or superseded code inside the approved touched surface. If the cleanup changes caller-visible behavior, stop and return to Planning so the behavior change is approved instead of hiding it inside implementation.

### Step 4: Architecture Drift Handling
If you discover that the effective architecture is missing a required decision:
- stop implementation,
- update the planner/user on the missing architectural fact,
- return to the Planning workflow,
- and do not silently patch the gap through implementation.

If runtime reality contradicts the effective architecture, the documents must be revised before implementation continues.

### Step 5: Persistence and Clean Execution
Produce functionality matching the requirements.
- **Do not generate conversational summaries**: Persist project state by updating the planning files, not by writing long chat recaps.
- **Mandatory Task Writeback**: After each meaningful implementation step, update `task.md` to reflect reality:
  - mark completed tasks and verification status,
  - record blockers or pending user handoffs,
  - update the active phase summary if the current execution state changed.
- **Mandatory Test Writeback**: If implementation changes approved test scope, methodology, or traceability, update `test.md` before declaring the phase complete.
- **Conditional Architecture Writeback**: If the finished implementation changed the effective architecture, constraints, boundaries, key flows, or approved target shape, update `architecture.md` before declaring the phase complete.
- **Mandatory Evidence Writeback**: If the task or design contract requires durable verification artifacts, create or update them before declaring the task complete.
- **Verification File Is Mandatory**: Raw checks, command outputs, test execution results, negative-path results, ownership tests, and cleanup notes belong in `verification.md`. Do not compress them into `task.md`.
- **Planning Reality Reconciliation**: Before marking the phase ready for review, compare `architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, and the actual file tree. If any of them disagree about active scope, artifact locations, delivered state, or cleanup status, reconcile them first.
- **File-Tree Reconciliation Is Concrete Work**: List the declared tree from `design.md`, inspect the actual tree, and record any unexpected artifacts in `verification.md`. Remove or relocate them before declaring the phase complete unless the contract explicitly allows them.
- **No Silent Completion**: If code changed but `task.md` still reads like the work has not started, the phase is not complete.
- Once all tasks in the active phase are completed, writeback is done, and verification is recorded, run the Plan Conformance Checkpoint (Step 6), the Quality Gate (Step 7), and Closeout (Step 8). Only after those pass do you declare the phase completed and awaiting review.

### Step 6: Plan Conformance Checkpoint (self-check, mid + at completion)

Conformance to the approved plan is the Developer's own responsibility, not the Reviewer's — Review hunts code defects, it does not match the diff against the plan. Run this checkpoint **twice**: periodically mid-implementation (so drift is caught early, not at the end) and once at phase completion before the quality gate. These checks are already enforced piecewise in Steps 2/3/5; this step consolidates them into one named pass so nothing is silently skipped. Findings here are **fixed by you**, not just flagged — you are the author.

Required check:
- **Scope bleed**: every changed hunk traces to the user request, an active `task.md` item, the behavior/design contract, or allowed cleanup. No unauthorized paradigms, dependencies, or boundary crossings. Apply `protocols/surgical-change-boundary.md`.
- **Surgical-diff boundary**: inspect the diff against the `task.md` boundary; revert scope-bleed, keep only touched-surface readability that passes the Decision Test.
- **Style conformance**: if `task.md` said "Follow Existing Patterns", the code matches surrounding conventions; if "Adopt New Patterns", approval is recorded in `architecture.md`.
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
| "The docs say A or B, so I will pick the cleaner one" | Development docs must be decision-complete. Return to Planning and get the active path selected. |
| "I'll read `study/`, `project-changelog.md`, and old notes to be safe" | Context overload makes execution worse. Load only the active planning surface unless reusable context or change rationale is required. |
| "Let me write the code first, I'll update docs later" | "Later" never comes. Docs first, code second. No exceptions. |
| "The code is done, I don't need to touch task.md" | Execution without writeback leaves the planning surface stale. Update `task.md` before claiming progress. |
| "The code drifted a bit, but architecture.md can stay as-is" | Effective architecture must describe the resulting system. Update it or return to planning. |
| "I'll just tweak the architecture slightly" | You are the Developer, not the Planner. STOP and return to Planning workflow. |
| "The schema is probably X, I'll continue" | Missing contracts belong to the human handoff boundary. Ask instead of guessing. |
| "This dependency would be perfect, let me add it" | If it's not in task.md, it's forbidden. Period. |
| "The planning doc is only 580 lines, I can keep stuffing context into it" | 580 lines = split phases or move history out now, before the planning surface becomes unusable. |
| "Let me refactor this while I'm here" | Out-of-scope refactoring is scope bleed. Only touch what task.md says. |
| "This code would be cleaner if I extracted it into a function" | Did the original code use that pattern? If not, you are over-abstracting. Stop. |
| "I'll reorganize the data structures for better readability" | Structural changes require user approval via architecture.md. You cannot decide this. |
| "I'll do a quick full rewrite, it's faster" | Chunk-based modifications only. Full rewrites cause silent regressions. |
| "The existing pattern is ugly, let me improve it" | Match existing patterns unless task.md explicitly says otherwise. Your taste is irrelevant. |
