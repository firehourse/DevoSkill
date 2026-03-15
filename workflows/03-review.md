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

### Step 3: Actionable Output
If discrepancies exist, write an itemized feedback list (e.g., "File api.py handles logic and db requests; this violates `architecture.md` API Gateway model.")
If a refactor is required, declare the need to shift to the **Planning** workflow for module separation.
Do not write or rewrite code directly. Provide the review report and hand off.
