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

| | Example |
|---|---|
| ❌ | `def create; @order = Order.new(params); @order.charge_card; @order.send_confirmation; end` |
| ✅ | `def create; result = OrderService.new(order_params).call; render json: result; end` |
| ❌ | Chained ActiveRecord queries built inline in controller actions |
| ✅ | Named scopes or query objects (`OrderQuery.new.pending.for_user(current_user)`) |

---

## 3. Service Objects

**Principle:** Service objects encapsulate one business operation. They accept plain Ruby values, not request params or ActiveRecord objects they don't own. They return a result object with `success?`, `value`, and `errors` — never raise for expected failures.

| | Example |
|---|---|
| ❌ | `class OrderService; def initialize(params); @params = params; end` — leaks HTTP boundary |
| ✅ | `class OrderService; def initialize(user_id:, amount:, items:)` — explicit domain types |
| ❌ | `def call; raise "payment failed" if ...` — raises for expected domain failure |
| ✅ | `def call; return Result.failure("insufficient_funds") if ...` |

---

## 4. ActiveRecord Query Discipline

**Principle:** Never load a full collection to filter in Ruby — always push filtering, ordering, and limiting to SQL. `pluck` over `map(&:attribute)`. Avoid N+1 queries — use `includes` or `preload` when associations are accessed in a loop.

| | Example |
|---|---|
| ❌ | `User.all.select { |u| u.active? }` — loads all rows |
| ✅ | `User.where(active: true)` |
| ❌ | `orders.each { |o| o.user.name }` — N+1 |
| ✅ | `orders.includes(:user).each { |o| o.user.name }` |
| ❌ | `User.all.map(&:id)` |
| ✅ | `User.pluck(:id)` |

---

## 5. Strong Parameters

**Principle:** `params.permit` must be called explicitly for every controller action that writes to the database. `params.require(:model).permit!` is banned — it allows mass assignment of any attribute. Nested attributes must be explicitly permitted with the full key path.

| | Example |
|---|---|
| ❌ | `User.create(params[:user])` |
| ❌ | `params.require(:user).permit!` |
| ✅ | `params.require(:user).permit(:name, :email, addresses_attributes: [:street, :city])` |

---

## 6. Background Jobs

**Principle:** Jobs must be idempotent — running the same job twice must not cause duplicate side effects. Jobs accept only primitive IDs, not full objects. Enqueue from service objects, not from models or callbacks. `after_commit` is the correct hook for enqueuing — `after_save` runs inside the transaction.

| | Example |
|---|---|
| ❌ | `NotifyUserJob.perform_later(user)` — serializes full object, stale on retry |
| ✅ | `NotifyUserJob.perform_later(user.id)` |
| ❌ | `after_save :enqueue_notification` — runs before commit, job may read uncommitted data |
| ✅ | `after_commit :enqueue_notification, on: :create` |

---

## 7. Structured Logging

**Principle:** Use `Rails.logger` with tagged or structured output. `puts` and `p` are banned in production paths. Log at the appropriate level — `debug` for diagnostic loops, `info` for state transitions, `warn` for recoverable anomalies, `error` for failures with context.

| | Example |
|---|---|
| ❌ | `puts "Processing order #{order.id}"` |
| ✅ | `Rails.logger.info("order processing started", order_id: order.id, user_id: user.id)` |
| ❌ | `Rails.logger.error(e.message)` — no context |
| ✅ | `Rails.logger.error("payment failed", order_id: order.id, error: e.message)` |

---

## 8. Error Handling and Rescue

**Principle:** Rescue the narrowest exception class. `rescue StandardError` at controller level must render a structured error response — never expose backtraces or raw exception messages to clients. Domain errors use custom exception classes, not generic `RuntimeError`.

| | Example |
|---|---|
| ❌ | `rescue => e; render json: { error: e.backtrace }` |
| ✅ | `rescue PaymentError => e; render json: { error: { code: e.code, message: e.message } }, status: :unprocessable_entity` |
| ❌ | `raise "order not found"` — string message, not typed |
| ✅ | `raise OrderNotFoundError.new(order_id: id)` |

---

## 9. Database Migrations

**Principle:** Migrations must be reversible. Every `change` migration that cannot be auto-reversed must implement `up` and `down`. Adding a `NOT NULL` column to a large table requires a default or a multi-step migration (add nullable → backfill → add constraint). Never remove a column that is still referenced in code.

| | Example |
|---|---|
| ❌ | `add_column :users, :status, :string, null: false` on a populated table with no default |
| ✅ | Add with default first, backfill in a separate step, then remove the default |
| ❌ | `remove_column :orders, :legacy_id` before the column reference is removed from all models and queries |
| ✅ | Deploy code change removing reference first, then deploy migration |
