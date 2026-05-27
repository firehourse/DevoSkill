# Surgical Change Boundary — Allowed Cleanup vs Scope Bleed

This protocol answers one question: given a `task.md` surgical change boundary, **which incidental changes count as allowed cleanup, and which are scope bleed?**

It is the single owner of that rule. Development applies it before editing and at diff reconciliation; Review applies it when judging the diff. Phase files and the task template should carry a one-line anchor and point here for the examples instead of restating the rule.

The feature's surgical change boundary itself is defined in `planning-artifacts.md` and `templates/task.md §6`. This file does not redefine the boundary; it decides what may ride along with it.

## Decision Test

A change that was not strictly required by the task is **allowed cleanup** only if both hold:

1. **In the touched surface** — it lives inside the method(s)/lines you are already changing, or their adjacent lines in the same file. Not another file, not an unrelated method or region.
2. **Behavior-invariant** — return values, observable side effects, callback order, transaction/lock boundaries, cache keys, TTLs, job-enqueue timing, and integration effects are provably unchanged.

If either is false, it is **scope bleed**: revert it, or get explicit user approval to expand the boundary.

Readability that passes both — clearer naming, a guard clause, collapsing redundant nesting, deleting a branch your change just made unreachable, fixing a now-false adjacent comment — is welcome, not noise. Stack protocols (e.g. `rails-maintenance-mode.md §2`) may add per-language bounds on top of this test.

## Allowed vs Scope Bleed

| | Example |
|---|---|
| ✅ | Editing `calculate_quota`: replacing the nested `if/else` you are already inside with an early-return guard. |
| ✅ | Renaming a confusing local (`tmp` → `remaining_quota`) inside the method you are already changing. |
| ✅ | Deleting an `else` branch that your change just made unreachable. |
| ✅ | Fixing an adjacent comment in the same method that your change turned into a lie. |
| ✅ | Collapsing `if x == true` → `if x` on the line you are already touching. |
| ❌ | Touching one line in `register`, then running the formatter over the whole file. |
| ❌ | Extracting a new `RegistrationService` / wrapper class "while I'm here". |
| ❌ | Renaming a method and updating its callers across other files when the task did not ask for it. |
| ❌ | Deleting pre-existing dead code unrelated to your change. |
| ❌ | "Improving" an adjacent method you never needed to edit. |
| ❌ | Moving an `after_commit` enqueue earlier, merging two transactions, or changing a cache key — behavior/lifecycle/timing, not readability. |
| ❌ | Tightening an unrelated validation or adding a guard the task did not request. |

## How Each Phase Uses This

- **Development** — apply the Decision Test before editing and again at Surgical Diff Reconciliation. Revert anything in the ❌ column unless the user approved a boundary expansion.
- **Review** — do not flag ✅ changes as scope bleed; flag ❌ changes as findings, naming the file/region and which test it failed (out of touched surface, or behavior/lifecycle/timing change).
