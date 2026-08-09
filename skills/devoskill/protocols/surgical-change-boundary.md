# Surgical Change Boundary — Allowed Cleanup vs Scope Bleed

This protocol answers one question: given a `task.md` surgical change boundary, **which incidental changes count as allowed cleanup, and which are scope bleed?**

It is the single owner of that rule. Development applies it before editing and at diff reconciliation; Review applies it when judging the diff. Phase files and the task template should carry a one-line anchor and point here for the examples instead of restating the rule.

The feature's surgical change boundary itself is defined in `planning-artifacts.md` and `templates/task.md §6`. This file does not redefine the boundary; it decides what may ride along with it.

## Decision Test

**Principle:** A surgical diff protects the approved outcome from unrelated churn; it does not force a weak implementation shape. Focused refactoring is allowed when it improves the active flow without changing the approved contract.

A hunk is allowed when it is required for an active task. An incidental improvement is **allowed cleanup** only when all four checks pass:

1. **Active-flow surface** — it is inside a file/module named by the task, or a direct caller/callee that must change to keep the active flow coherent. It is not merely nearby in the repository.
2. **Concrete benefit** — it clarifies a domain operation, isolates an I/O/error/authorization boundary, centralizes a repeated invariant, removes duplication created or exposed by this change, or creates a useful test seam.
3. **Contract-invariant** — public behavior, observable side effects, callback order, transaction/lock boundaries, cache keys, TTLs, job timing, and integration effects remain unchanged unless the active task explicitly changes them.
4. **Proportionate shape** — it is the smallest coherent refactor that earns the benefit. It does not start a subsystem-wide modernization or require an unrelated migration.

If any check fails, the hunk is **scope bleed**: revert it, record it as follow-up, or get explicit approval to expand the boundary. When a focused improvement changes the planned private file/module shape, update `design.md` and `task.md`; renewed approval is required only if the consequential contract changes.

## Allowed vs Scope Bleed

| | Example |
|---|---|
| ✅ | Editing `calculate_quota`: replacing the nested `if/else` you are already inside with an early-return guard. |
| ✅ | Renaming a confusing local (`tmp` → `remaining_quota`) inside the method you are already changing. |
| ✅ | Deleting an `else` branch that your change just made unreachable. |
| ✅ | Fixing an adjacent comment in the same method that your change turned into a lie. |
| ✅ | Collapsing `if x == true` → `if x` on the line you are already touching. |
| ✅ | Extracting repeated admission-key construction from the active controller/service flow into one focused helper, then updating the design tree. |
| ✅ | Moving external API error normalization behind a local boundary so every active-flow caller handles it consistently. |
| ❌ | Touching one line in `register`, then running the formatter over the whole file. |
| ❌ | Extracting a `RegistrationService` wrapper that only forwards one call and names no responsibility, invariant, boundary, or test seam. |
| ❌ | Renaming a method and updating its callers across other files when the task did not ask for it. |
| ❌ | Deleting pre-existing dead code unrelated to your change. |
| ❌ | "Improving" an adjacent method you never needed to edit. |
| ❌ | Moving an `after_commit` enqueue earlier, merging two transactions, or changing a cache key — behavior/lifecycle/timing, not readability. |
| ❌ | Tightening an unrelated validation or adding a guard the task did not request. |

## How Each Phase Uses This

- **Development** — apply the Decision Test before editing and again at Surgical Diff Reconciliation. Keep focused improvements that pass all four checks; revert or hand back anything that does not.
- **Review** — do not flag ✅ changes as scope bleed; flag ❌ changes as findings, naming the file/region and which check failed (outside the active-flow surface, no concrete benefit, contract change, or disproportionate scope).
