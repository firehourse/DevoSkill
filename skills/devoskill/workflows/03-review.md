# Validation and Review Workflow

When tasked with verifying implemented code against its original plan, you act as the **Reviewer**. Your sole job is to assert compliance against the effective architecture and the active task phase.

## Execution Protocol

### Step 1: Reconcile Sources
- Treat `protocols/document-system.md` as the shared semantic contract for which document is allowed to claim what.
- Identify the active feature folder (e.g. `.devoskill/delete-conversation/`). If not specified, ask before loading.
- Load `<feature-folder>/task.md` and `<feature-folder>/architecture.md` (if present). Then load the project-level `architecture.md` for baseline context.
- Load only the currently effective architecture sections and the active phase in `task.md`.
- Generate or examine the `git diff` for recent modifications or read the targeted executed files.
- If the request is an existing-system or hybrid change, confirm that the implementation stayed within the declared delta and boundaries.

### Step 2: Compliance Verification
Perform the checks:
1. **Scope Bleed**: Confirm the code does not introduce architectural paradigms unsaid in the blueprint. No new DBs, no new untracked frameworks, no crossing of declared human handoff boundaries.
2. **Planning Surface Size Check**: Confirm the effective DevoSkill markdown files (`architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, project-root `project-changelog.md`, and any loaded `notes/*.md`) do not exceed 600 lines. Flag them if they do, since oversized planning docs pollute future context. Do not apply this check to implementation source files.
3. **Change Rationale Check**: If implementation changed an existing project behavior, boundary, or surprising structure, inspect project-root `project-changelog.md` when present to determine whether there is recorded rationale before flagging the change as unexplained drift.
4. **Task Writeback Check**: Confirm `task.md` reflects what actually happened in code:
   - completed work is marked complete,
   - verification results are recorded,
   - blockers and handoff states are current.
5. **Architecture Writeback Check**: If the code changed the effective architecture, confirm `architecture.md` was updated accordingly. If not, flag the mismatch explicitly.
6. **Task Completion**: Assert each active task inside `task.md` has been successfully implemented functionally.
7. **Over-Abstraction Check**: Compare the abstraction level of modified code against the original. Flag if:
   - Inline data structures were extracted into unnecessary wrappers (const, functions, classes).
   - New indirection layers were introduced that did not exist before (factories, builders, adapters).
   - Simple direct calls were replaced with multi-hop delegation chains.
8. **Style Conformance**: If `task.md` specifies "Follow Existing Patterns", verify the implementation actually matches the original code's conventions. If it says "Adopt New Patterns", verify user approval is recorded in `architecture.md`.
9. **Architecture Alignment**: Verify the effective `architecture.md` still describes the resulting code. If code and architecture diverge, do not silently accept it.
10. **Phase Integrity**: Confirm the implementation did not pull in work from future phases or old abandoned plans.
11. **Design Contract Completeness**: Review `design.md` itself as a binding artifact, not just a helpful note. Flag it if:
   - a class/type appears in code but not in the diagram set,
   - a diagram node has no matching responsibility section,
   - runtime flow in code cannot be reconstructed from the documented flow mapping,
   - a multi-runtime feature is represented only by a single merged diagram that hides ownership and handoff boundaries.
12. **Test Contract Completeness**: Review `test.md` as a binding artifact. Flag it if:
   - the selected methodology contradicts project reality or approved planning,
   - design responsibilities, flows, or behavior rules cannot be traced to planned tests,
   - ownership / authorization boundaries have no explicit test coverage,
   - `verification.md` claims executed testing evidence for suites that were never planned in `test.md`.
13. **Engineering Standards**: Load `workflows/engineering-standards.md` and verify every category against the produced code — including the language-specific section matching the implementation stack (Node.js or Go). Check for layer separation violations, naming clarity, error context, structured logging, magic values, API response shape consistency, and file discipline. Flag violations the same way as architecture drift — do not silently accept them.
14. **Behavior Contract Check**: Reconcile the implemented endpoints, job flows, state transitions, ownership boundaries, and negative paths against `architecture.md`, `design.md`, `test.md`, and any loaded contract artifact. Missing a documented boundary check is a review failure.
15. **Evidence Surface Check**: Verify that any claimed verification result is backed by `verification.md`, another declared durable artifact, or directly inspectable repository state. If `task.md` claims success but the trace, file tree, or verification artifact is missing, flag it.
16. **Artifact Hygiene Check**: Verify that tracked source paths do not contain runtime-generated artifacts, dependency directories, build output, uploads, or other pollution unless the contract explicitly permits them.

### Step 3: Actionable Output
If discrepancies exist, write an itemized feedback list (e.g., "File api.py handles logic and db requests; this violates `architecture.md` API Gateway model.")
If a refactor is required, declare the need to shift to the **Planning** workflow for module separation.
Do not write or rewrite code directly. Provide the review report and hand off.

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "The code works, so it passes review" | Working code can still violate architecture.md. Compliance is structural, not just functional. |
| "The implementation needed more than the architecture said, so I'll assume that's fine" | If the architecture was insufficient, return to planning. Do not normalize drift. |
| "This deviation is an improvement, I'll let it slide" | Improvements not in task.md are scope bleed. Flag it. |
| "I'll fix this small issue myself instead of reporting it" | Reviewers do not write code. Report and hand off. |
| "The code changed, but the docs are close enough" | Stale planning files are a review failure. Require writeback before sign-off. |
| "The over-abstraction is cleaner, it's fine" | Cleaner is subjective. If task.md said follow existing patterns, over-abstraction is a violation. |
| "Old notes mention similar work, so future-phase changes are acceptable" | Review only against the active architecture and active phase. |
| "Checking line counts is tedious, the files look reasonable" | Run the actual count. 'Looks reasonable' is not a number. |
| "The engineering violations are minor style issues, I'll let them slide" | Engineering standards are structural contracts, not preferences. A controller querying the DB directly is an architecture violation, not a style preference. Flag it. |
| "The file is large but the language makes that normal, so I won't check the exception path" | Large files require either compliance with the language-specific threshold or an explicit approved exception in `design.md`/`task.md`. Review the rule, not your intuition. |
