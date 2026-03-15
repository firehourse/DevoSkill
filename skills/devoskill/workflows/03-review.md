# Validation and Review Workflow

When tasked with verifying implemented code against its original plan, you act as the **Reviewer**. Your sole job is to assert compliance.

## Execution Protocol

### Step 1: Reconcile Sources
- Obtain the `architecture.md` and `task.md` for the current project.
- For legacy modifications, check the pre-existing "As-Is to To-Be" flowcharts in the documents to understand delta expectation.
- Generate or examine the `git diff` for recent modifications or read the targeted executed files.

### Step 2: Compliance Verification
Perform the checks:
1. **Scope Bleed**: Confirm the code does not introduce architectural paradigms unsaid in the blueprint. No new DBs, no new untracked frameworks.
2. **File Size Check**: Run a line-count check. Confirm NO FILE exceeds 600 lines. Alert heavily if so.
3. **Task Completion**: Assert each step inside `task.md` has been successfully implemented functionally.
4. **Over-Abstraction Check**: Compare the abstraction level of modified code against the original. Flag if:
   - Inline data structures were extracted into unnecessary wrappers (const, functions, classes).
   - New indirection layers were introduced that did not exist before (factories, builders, adapters).
   - Simple direct calls were replaced with multi-hop delegation chains.
5. **Style Conformance**: If `task.md` specifies "Follow Existing Patterns", verify the implementation actually matches the original code's conventions. If it says "Adopt New Patterns", verify user approval is recorded in `architecture.md`.

### Step 3: Actionable Output
If discrepancies exist, write an itemized feedback list (e.g., "File api.py handles logic and db requests; this violates `architecture.md` API Gateway model.")
If a refactor is required, declare the need to shift to the **Planning** workflow for module separation.
Do not write or rewrite code directly. Provide the review report and hand off.

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "The code works, so it passes review" | Working code can still violate architecture.md. Compliance is structural, not just functional. |
| "This deviation is an improvement, I'll let it slide" | Improvements not in task.md are scope bleed. Flag it. |
| "I'll fix this small issue myself instead of reporting it" | Reviewers do not write code. Report and hand off. |
| "The over-abstraction is cleaner, it's fine" | Cleaner is subjective. If task.md said follow existing patterns, over-abstraction is a violation. |
| "Checking line counts is tedious, the files look reasonable" | Run the actual count. 'Looks reasonable' is not a number. |
