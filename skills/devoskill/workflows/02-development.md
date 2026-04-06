# Development Workflow

When tasked with implementing a feature based on a plan, you are the **Developer**. You execute code based explicitly on the current phase of `task.md` and the effective sections of `architecture.md`.

## Execution Protocol

### Step 1: Pre-Flight Environment Checks
1. Ensure the target `skilldocs` location exists in your context. Check for a local `.devoskill/` symlink. If missing, follow `protocols/workspace-setup.md`.
2. Python Projects: You MUST ensure that all package installations and environments utilize `uv`. Do not fall back to `pip` or virtual environments natively.
3. Load only the relevant planning surface:
   - the active phase in `task.md`,
   - the effective architecture sections referenced by that phase,
   - and any human-provided contract or schema explicitly required by the task.
4. Do NOT load history, abandoned approaches, or old phases unless the user explicitly asks for them.
5. Confirm that implementation is explicitly approved in the active planning surface or by the user's current instruction. If approval is missing or ambiguous, stop and ask the user whether to begin implementation now.

### Step 2: Strict Adherence
Follow the active-phase tasks linearly based on `task.md`.
- **No Creativity in Architecture**: You are explicitly prohibited from unilaterally changing the architecture, adding third-party dependencies not mentioned in `task.md`, or reshaping the design scope.
- **Respect Human Handoffs**: If `task.md` marks a step as a user handoff, stop there. Do not guess through missing schema, missing contracts, sensitive credentials, or production-only operations.
- **Respect the Approval Gate**: A finished `task.md` is necessary but not sufficient. No code edits begin until the user has explicitly authorized implementation.
- **Planning Surface Discipline**: If implementation requires expanding `architecture.md`, `task.md`, or loaded notes beyond 600 lines, stop and split or trim the planning surface before continuing.

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
- **Conditional Architecture Writeback**: If the finished implementation changed the effective architecture, constraints, boundaries, key flows, or approved target shape, update `architecture.md` before declaring the phase complete.
- **No Silent Completion**: If code changed but `task.md` still reads like the work has not started, the phase is not complete.
- Once all tasks in the active phase are completed, writeback is done, and verification is recorded, trigger the Review phase by stating the phase is completed and awaiting review.

### Step 6: Pre-phase Completion Quality Gate

Before marking any implementation phase complete, load `../devoskill-quality/SKILL.md` and apply every relevant category in `workflows/05-quality.md` against the produced code. Fix any failures before writing back to `task.md`.

---

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "This is too simple, I don't need task.md" | Simple tasks cause the most assumption errors. Write it in task.md, it takes 2 minutes. |
| "There is a task.md now, so I can start coding" | A task plan is not approval. Wait for explicit user authorization. |
| "I'll read the entire planning history to be safe" | Context overload makes execution worse. Load only the active planning surface. |
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
