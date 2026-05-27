# Rails Maintenance Mode Protocol

Use this shared protocol during Planning, Development, Review, Debug/Performance, and Ruby quality checks whenever Ruby on Rails code is in scope.

This file is the single source of truth for Rails maintenance style. Phase skills and quality workflows should reference it instead of duplicating style, abstraction, or lifecycle examples.

## 1. Default Mode

Default to **Conservative Rails Maintenance** for existing Rails code:

- Follow the repository's Rails version, RuboCop configuration, naming, comments, string/hash style, callback style, and local idioms.
- Preserve transaction order, locking, callbacks, validations, cache keys, TTLs, background job enqueue timing, and integration side effects.
- Prefer the existing abstraction boundary in the touched area: controller, concern, model callback/scope, service object, policy, helper, or query object.
- Make the smallest behavior-preserving change that satisfies the task.

Use **Explicit Modernization** only when the task or architecture document says to change style, boundaries, framework idioms, or lifecycle behavior.

## 2. Readability Allowance Within The Touched Surface

`protocols/surgical-change-boundary.md` owns the general rule (Decision Test + allowed-vs-scope-bleed examples). This section adds the Rails-specific bounds; it is still Conservative Rails Maintenance, not Explicit Modernization, so it needs no extra task/architecture authorization.

**Principle:** Conservative does not mean copying legacy idiom you are already rewriting — touched-surface readability is welcome. But in Rails the behavior-invariant half of the Decision Test is strict: callback order, `after_commit`/`after_save` timing, transaction and lock boundaries, validation order, cache keys, TTLs, and job-enqueue points are behavior, not style. Leave them exactly as-is unless §1 plus explicit approval says otherwise.

Required check:
- Apply the `surgical-change-boundary.md` Decision Test first.
- Treat any move that changes when data becomes visible, or when a job/callback observes state, as lifecycle change rather than cleanup — even if it "reads better".
- Keep readability edits to naming, guard clauses, and nesting inside the method you are already touching; do not extract a concern/service to look modern (see `standard-authoring.md §4`).

| | Example | Why |
|---|---|---|
| ✅ | Early-return guard replacing the nested `if/else` in the action you are already editing. | behavior-preserving readability |
| ❌ | Reordering `after_commit` enqueues or merging two transactions because it "flows better". | changes lifecycle timing |
| ❌ | Extracting a concern or service out of a controller you only needed to touch one line in. | scope bleed, new boundary unapproved |

## 3. Routing Examples

| Code area | Mode | Reason |
|---|---|---|
| Order, registration, payment, inventory, ticketing, quota, or cache path | Conservative Rails Maintenance | Lifecycle ordering and side effects are part of correctness. |
| Model callbacks, validations, transactions, locks, `after_commit` jobs | Conservative Rails Maintenance | Moving code can change when data becomes visible or jobs observe state. |
| Controller action in an old namespace with local conventions | Conservative Rails Maintenance | Matching surrounding style reduces review and regression risk. |
| Isolated new feature folder with approved design.md structure | Explicit Modernization | The planning contract authorized a new boundary. |
| Framework upgrade, RuboCop migration, service extraction task | Explicit Modernization | The requested work is style or architecture change. |

## 4. Planning Design Gate

When planning Rails work, classify the touched area before writing `design.md` or drawing diagrams:

- Use the stack-specific `design-ruby.md` surface for Rails work.
- Prefer a Rails Boundary Map when the real code is organized around controllers, Grape APIs, concerns, models, callbacks, service objects, policies, helpers, jobs, or application-level rescue handlers.
- Include error handling as an explicit boundary when the feature depends on `rescue_from`, API error helpers, custom exception classes, result objects, or shared exception reporting.
- Do not invent class diagrams that imply a new object model for legacy Rails code. A class diagram is useful only when it reflects real implementation boundaries or an explicitly approved modernization.
- Record whether expected business failures are result-based or exception-based, where system exceptions are rescued, and which layer normalizes the caller-visible response.

## 5. Review Gate

Wrong mode choice is a quality issue:

- Do not flag readability cleanup that stays inside the §2 touched-surface allowance and preserves behavior and lifecycle timing — it is authorized by this protocol, not scope bleed. Still flag cleanup that reaches untouched methods/files or that changes lifecycle/timing.
- Flag syntax modernization, broad service extraction, concern rewrites, or callback movement that is unrelated to the task.
- Flag changes that alter transaction, locking, callback, cache, job enqueue, or integration timing without explicit approval.
- Require the task or architecture document to name the modernization boundary before accepting new architectural layers in legacy Rails code.
- Flag Rails designs or implementations that hide error handling behind generic prose when the touched flow depends on a concrete rescue handler, API error helper, custom exception class, result object, or exception reporting path.
