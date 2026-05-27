# Quality Workflow — Ruby on Rails

Apply after `05-quality.md`. Fix any failures before writing back to `task.md`.

---

## 1. Existing Rails Style

**Principle:** Mature Rails code defaults to Conservative Rails Maintenance. Apply the shared protocol at `../protocols/rails-maintenance-mode.md` for style, abstraction, and lifecycle decisions. Explicit Modernization is allowed only when the task or architecture document authorizes it.

Required check:
- State whether the change is Conservative Rails Maintenance or Explicit Modernization.
- Use the routing examples and review gate in `rails-maintenance-mode.md`.
- Fix wrong-mode style, abstraction, or lifecycle changes before continuing with the remaining Ruby checks.

---

## 2. Fat Model / Thin Controller

**Principle:** Controllers handle only HTTP ↔ domain translation. Business logic belongs in service objects or models. A controller action that reaches 15 lines or calls more than one model method directly is a fat controller violation.

| | Example | Why |
|---|---|---|
| ❌ | `def create; @order = Order.new(params); @order.charge_card; @order.send_confirmation; end` | fat controller, untestable |
| ✅ | `def create; result = OrderService.new(order_params).call; render json: result; end` | logic in isolated service |
| ❌ | Chained ActiveRecord queries built inline in controller actions | query logic leaks into HTTP layer |
| ✅ | Named scopes or query objects (`OrderQuery.new.pending.for_user(current_user)`) | reusable, testable |

---

## 3. Service Objects

**Principle:** Service objects encapsulate one business operation. They accept plain Ruby values, not request params or ActiveRecord objects they don't own. They return a result object with `success?`, `value`, and `errors` — never raise for expected failures.

| | Example | Why |
|---|---|---|
| ❌ | `class OrderService; def initialize(params); @params = params; end` — leaks HTTP boundary | service coupled to request shape |
| ✅ | `class OrderService; def initialize(user_id:, amount:, items:)` — explicit domain types | callable outside controllers |
| ❌ | `def call; raise "payment failed" if ...` — raises for expected domain failure | exceptions for control flow |
| ✅ | `def call; return Result.failure("insufficient_funds") if ...` | typed result, no rescue needed |

---

## 4. ActiveRecord Query Discipline

**Principle:** Never load a full collection to filter in Ruby — always push filtering, ordering, and limiting to SQL. `pluck` over `map(&:attribute)`. Avoid N+1 queries — use `includes` or `preload` when associations are accessed in a loop.

| | Example | Why |
|---|---|---|
| ❌ | `User.all.select { |u| u.active? }` — loads all rows | full table into memory |
| ✅ | `User.where(active: true)` | filters in SQL |
| ❌ | `orders.each { |o| o.user.name }` — N+1 | one query per row |
| ✅ | `orders.includes(:user).each { |o| o.user.name }` | eager-loaded in two queries |
| ❌ | `User.all.map(&:id)` | instantiates every record |
| ✅ | `User.pluck(:id)` | single column, no objects |

---

## 5. Strong Parameters

**Principle:** `params.permit` must be called explicitly for every controller action that writes to the database. `params.require(:model).permit!` is banned — it allows mass assignment of any attribute. Nested attributes must be explicitly permitted with the full key path.

| | Example | Why |
|---|---|---|
| ❌ | `User.create(params[:user])` | unfiltered mass assignment |
| ❌ | `params.require(:user).permit!` | permits any attribute |
| ✅ | `params.require(:user).permit(:name, :email, addresses_attributes: [:street, :city])` | explicit allowlist |

---

## 6. Background Jobs

**Principle:** Jobs must be idempotent — running the same job twice must not cause duplicate side effects. Jobs accept only primitive IDs, not full objects. Enqueue from service objects, not from models or callbacks. `after_commit` is the correct hook for enqueuing — `after_save` runs inside the transaction.

| | Example | Why |
|---|---|---|
| ❌ | `NotifyUserJob.perform_later(user)` — serializes full object, stale on retry | snapshot drifts from DB |
| ✅ | `NotifyUserJob.perform_later(user.id)` | reloads fresh record |
| ❌ | `after_save :enqueue_notification` — runs before commit, job may read uncommitted data | job races the transaction |
| ✅ | `after_commit :enqueue_notification, on: :create` | enqueues after data is visible |

---

## 7. Structured Logging

**Principle:** Use `Rails.logger` with tagged or structured output. `puts` and `p` are banned in production paths. Log at the appropriate level — `debug` for diagnostic loops, `info` for state transitions, `warn` for recoverable anomalies, `error` for failures with context.

| | Example | Why |
|---|---|---|
| ❌ | `puts "Processing order #{order.id}"` | bypasses log levels and tagging |
| ✅ | `Rails.logger.info("order processing started", order_id: order.id, user_id: user.id)` | structured, filterable |
| ❌ | `Rails.logger.error(e.message)` — no context | unsearchable, no correlation |
| ✅ | `Rails.logger.error("payment failed", order_id: order.id, error: e.message)` | traceable to the order |

---

## 8. Error Handling and Rescue

**Principle:** Preserve the existing Rails error boundary and make it explicit in `design.md`. Rescue the narrowest exception class. Centralized handlers such as `ApplicationController.rescue_from`, Grape/API error helpers, middleware, and job-level rescue blocks must render or report through the repository's established structured path.

Expected domain failures follow the approved Result / Exception Boundary from `design.md`. If the boundary is exception-based, use custom exception classes, not generic `RuntimeError`. If it is result-based, do not raise for expected failures.

`rescue StandardError` at controller/API level must render a structured error response and report/log with context — never expose backtraces or raw exception messages to clients.

| | Example | Why |
|---|---|---|
| ❌ | `rescue => e; render json: { error: e.backtrace }` | leaks internals, catches everything |
| ✅ | `rescue PaymentError => e; render json: { error: { code: e.code, message: e.message } }, status: :unprocessable_entity` | narrow rescue, safe response |
| ❌ | `raise "order not found"` — string message, not typed | uncatchable by class |
| ✅ | `raise OrderNotFoundError.new(order_id: id)` | typed, rescuable, carries context |
| ❌ | A controller adds an ad hoc broad rescue while the app already has a shared API error handler | duplicate, divergent error paths |
| ✅ | The flow uses the existing shared handler, or `design.md` records why this action needs a local rescue boundary | one consistent boundary |

---

## 9. Database Migrations

**Principle:** Migrations must be reversible. Every `change` migration that cannot be auto-reversed must implement `up` and `down`. Adding a `NOT NULL` column to a large table requires a default or a multi-step migration (add nullable → backfill → add constraint). Never remove a column that is still referenced in code.

| | Example | Why |
|---|---|---|
| ❌ | `add_column :users, :status, :string, null: false` on a populated table with no default | fails/locks on existing rows |
| ✅ | Add with default first, backfill in a separate step, then remove the default | no lock, no NULL violation |
| ❌ | `remove_column :orders, :legacy_id` before the column reference is removed from all models and queries | running code hits a dropped column |
| ✅ | Deploy code change removing reference first, then deploy migration | no stale references at cutover |
