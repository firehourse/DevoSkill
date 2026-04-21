# Rails Maintenance Mode Protocol

Use this shared protocol during Development, Review, Debug/Performance, and Ruby quality checks whenever Ruby on Rails code is in scope.

This file is the single source of truth for Rails maintenance style. Phase skills and quality workflows should reference it instead of duplicating style, abstraction, or lifecycle examples.

## 1. Default Mode

Default to **Conservative Rails Maintenance** for existing Rails code:

- Follow the repository's Rails version, RuboCop configuration, naming, comments, string/hash style, callback style, and local idioms.
- Preserve transaction order, locking, callbacks, validations, cache keys, TTLs, background job enqueue timing, and integration side effects.
- Prefer the existing abstraction boundary in the touched area: controller, concern, model callback/scope, service object, policy, helper, or query object.
- Make the smallest behavior-preserving change that satisfies the task.

Use **Explicit Modernization** only when the task or architecture document says to change style, boundaries, framework idioms, or lifecycle behavior.

## 2. Routing Examples

| Code area | Mode | Reason |
|---|---|---|
| Order, registration, payment, inventory, ticketing, quota, or cache path | Conservative Rails Maintenance | Lifecycle ordering and side effects are part of correctness. |
| Model callbacks, validations, transactions, locks, `after_commit` jobs | Conservative Rails Maintenance | Moving code can change when data becomes visible or jobs observe state. |
| Controller action in an old namespace with local conventions | Conservative Rails Maintenance | Matching surrounding style reduces review and regression risk. |
| Isolated new feature folder with approved design.md structure | Explicit Modernization | The planning contract authorized a new boundary. |
| Framework upgrade, RuboCop migration, service extraction task | Explicit Modernization | The requested work is style or architecture change. |

## 3. Review Gate

Wrong mode choice is a quality issue:

- Flag syntax modernization, broad service extraction, concern rewrites, or callback movement that is unrelated to the task.
- Flag changes that alter transaction, locking, callback, cache, job enqueue, or integration timing without explicit approval.
- Require the task or architecture document to name the modernization boundary before accepting new architectural layers in legacy Rails code.
