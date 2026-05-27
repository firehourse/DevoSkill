# Quality Workflow — Go

Apply after `05-quality.md`. Fix any failures before writing back to `task.md`.

---

## 1. Implementation Mode

**Principle:** Every Go change must choose high-performance or high-modularity mode before introducing abstractions. Apply the shared protocol at `../protocols/go-implementation-mode.md` for the touched area. Hot paths default to high-performance mode unless architecture explicitly documents a modular boundary.

Required check:
- State the selected mode for the touched Go area.
- Use the routing examples and review gate in `go-implementation-mode.md`.
- Fix wrong-mode abstraction before continuing with the remaining Go checks.

---

## 2. Signal Handling and Root Context

**Principle:** The process root context must be derived from OS signal interception, not from `context.Background()`. This lets every goroutine and loop that accepts a context exit cleanly on SIGTERM without being force-killed.

| | Example | Why |
|---|---|---|
| ❌ | `ctx := context.Background()` — SIGTERM is never observed | SIGTERM ignored, forces SIGKILL |
| ✅ | `ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM); defer stop()` | signal cancels root context |
| ❌ | `select {}` as the main block — process has no shutdown path | blocks forever, no drain |
| ✅ | `<-ctx.Done()` as the main block — exits cleanly when signal arrives | unblocks on signal |

---

## 3. Context Propagation

**Principle:** `context.Background()` must never be used inside a request handler or any function that operates on behalf of a specific request or job. Use the request-scoped or job-scoped context so cancellation propagates correctly. The only valid uses of `context.Background()` are at process startup and in the signal-handling root.

| | Example | Why |
|---|---|---|
| ❌ | `pubsub := redis.Subscribe(context.Background(), ch)` inside a request handler | cancellation never propagates |
| ✅ | `pubsub := redis.Subscribe(r.Context(), ch)` | unsubscribes when request ends |
| ❌ | `db.Exec(context.Background(), query, args...)` inside a job handler | query outlives cancelled job |
| ✅ | `db.Exec(jobCtx, query, args...)` | query cancels with the job |

---

## 4. Goroutine and Cancel Lifecycle

**Principle:** Every `context.WithCancel` must have a matching `defer cancel()` in the same function scope to prevent context leaks. The cancel function must be called even when the goroutine exits early. Storing cancel functions in a map requires explicit cleanup on both normal completion and cancellation.

| | Example | Why |
|---|---|---|
| ❌ | `ctx, cancel := context.WithCancel(parent)` with no `defer cancel()` | context leak, goroutine lingers |
| ✅ | `ctx, cancel := context.WithCancel(parent); defer cancel()` | cancel always released |
| ❌ | `cancelMap[id] = cancel` with cleanup only on success path — leaks on error | error path leaks cancel entry |
| ✅ | `defer func() { cancelMap.Delete(id); cancel() }()` — always runs | cleanup on every exit path |

---

## 5. Concurrency Patterns

**Principle:** Use `sync.WaitGroup` to wait for a known set of goroutines to finish. Use a buffered channel as a semaphore to cap concurrent goroutines. The loop bound and the semaphore capacity serve different purposes — the loop bound is the total work count, the semaphore capacity is the parallelism limit. Both must be driven by the correct variable.

| | Example | Why |
|---|---|---|
| ❌ | `sem := make(chan struct{}, limit)` but loop runs `for i := 0; i < 5; i++` — `limit` only affects semaphore size, not goroutine count | work count conflated with parallelism |
| ✅ | Total work count from a slice length; `sem` capacity from the configurable limit | bound and limit separated |
| ❌ | `go func() { ... }()` with no mechanism to detect completion or propagate errors | leaked goroutine, swallowed errors |
| ✅ | `var wg sync.WaitGroup; wg.Add(1); go func() { defer wg.Done(); ... }(); wg.Wait()` | completion awaited deterministically |

---

## 6. Deferred Cleanup

**Principle:** Cleanup calls (`Close`, `Rollback`, `Unlock`) must be deferred immediately after acquisition so they run even if the function returns early due to an error. Relying on cleanup only at the end of a function body is fragile — early returns skip it.

| | Example | Why |
|---|---|---|
| ❌ | `tx, _ := db.Begin(ctx)` ... `tx.Rollback(ctx)` only at the end — skipped on early return | early return leaks transaction |
| ✅ | `tx, _ := db.Begin(ctx); defer tx.Rollback(ctx)` — runs regardless of exit path | rollback on every exit path |
| ❌ | `conn.Close()` called manually in each error branch | missed branch leaks connection |
| ✅ | `defer conn.Close()` immediately after `conn` is acquired | close guaranteed once |

---

## 7. Structured Logging

Use `log/slog` for all log output. `log.Printf`, `log.Fatalf`, and `fmt.Println` are banned in service code. Every log call includes named key-value fields; bare format strings are not sufficient.

| | Example | Why |
|---|---|---|
| ❌ | `log.Printf("task failed: %v", err)` — unstructured, no fields | not queryable by field |
| ✅ | `slog.Error("task failed", "task_id", taskID, "error", err)` | structured, attributable |
| ❌ | `fmt.Println("starting worker")` | bypasses logger, no level |
| ✅ | `slog.Info("worker started", "queue", cfg.TaskQueue, "concurrency", cfg.WorkerConcurrency)` | leveled with context fields |

---

## 8. Package Structure and Constructors

Package names are lowercase single words with no underscores. Each package has one coherent responsibility. Types with external dependencies are always created via a `NewXxx` constructor — never by bare struct literal at the call site.

| | Example | Why |
|---|---|---|
| ❌ | `package user_service` / `package httpAndDB` | non-idiomatic, mixed responsibility |
| ✅ | `package service` / `package store` — one word, one responsibility | idiomatic, coherent scope |
| ❌ | `h := Handler{db: db, log: log}` — bare struct literal with injected deps | skips validation, unwired deps |
| ✅ | `h := NewHandler(db, log)` — constructor validates and wires | invariants enforced at creation |

---

## 9. Interface Placement

Interfaces are defined by the consumer, not the implementer. Every struct field holding an external dependency is typed as an interface declared in the same file — never as a concrete pointer. This prevents import cycles and keeps interfaces minimal.

| | Example | Why |
|---|---|---|
| ❌ | `type Worker struct { store *postgres.Store; broker *rabbit.Client }` — concrete pointers | hard-coupled, unmockable |
| ✅ | `type Worker struct { store taskStore; broker messageQueue }` with interfaces declared in `processor.go` | consumer-owned narrow contract |
| ❌ | Interface defined in the repository package and imported by the service | import cycle, leaky interface |
| ✅ | Interface defined in the service/consumer package, satisfied by the repository | dependency inverted at consumer |

---

## 10. Comment & Doc-Comment Style

**Principle:** Go quality also includes godoc and inline-comment intent. Apply `quality-comments.md` to every touched Go file. The principles are language-neutral, but Go has two extra-strict rules: every exported identifier carries a doc comment whose first sentence starts with the identifier name (godoc renders that sentence as the entry summary), and order-sensitive sequences (defer placement, named return assignment, response-write vs. observability) carry a comment naming the hazard the order prevents.

Required check:
- Exported function/method/type/constant without godoc-shaped doc comment → finding.
- Comment that paraphrases the next statement instead of stating contract / invariant / trade-off → finding.
- Any defer/recover/named-return interaction whose ordering matters → require an inline comment naming the hazard.
- Fail-mode keyword (`fail-open`, `fail-closed`, `fail-fast`) required on any deliberate catch-and-continue or hard-stop on missing state.

See `quality-comments.md` for the nine-rule executable contract and ❌/✅ examples mined from a production Go HTTP service.

---

## 11. Ownership and Stream Authorization

**Principle:** Go services that broker SSE, WebSocket, queue replay, or resource-scoped background operations must validate ownership before opening the stream or replaying buffered data. Identity setup and resource authorization are separate steps; doing the first does not satisfy the second.

| | Example | Why |
|---|---|---|
| ❌ | Controller ensures a cookie-based user ID exists, then subscribes to `task:{id}` directly | identity checked, ownership not |
| ✅ | Controller/service validates the user can access `task:{id}` before subscribing or replaying data | ownership gate before stream |
| ❌ | Replay buffer or cancel side channel is treated as an internal detail and skips the resource boundary | side channel leaks others' data |
| ✅ | Buffered summaries, live events, and cancel signals all respect the same ownership contract | uniform authorization boundary |
