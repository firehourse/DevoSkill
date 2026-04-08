# Quality Workflow — Go

Apply after `05-quality.md`. Fix any failures before writing back to `task.md`.

---

## 1. Signal Handling and Root Context

**Principle:** The process root context must be derived from OS signal interception, not from `context.Background()`. This lets every goroutine and loop that accepts a context exit cleanly on SIGTERM without being force-killed.

| | Example |
|---|---|
| ❌ | `ctx := context.Background()` — SIGTERM is never observed |
| ✅ | `ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM); defer stop()` |
| ❌ | `select {}` as the main block — process has no shutdown path |
| ✅ | `<-ctx.Done()` as the main block — exits cleanly when signal arrives |

---

## 2. Context Propagation

**Principle:** `context.Background()` must never be used inside a request handler or any function that operates on behalf of a specific request or job. Use the request-scoped or job-scoped context so cancellation propagates correctly. The only valid uses of `context.Background()` are at process startup and in the signal-handling root.

| | Example |
|---|---|
| ❌ | `pubsub := redis.Subscribe(context.Background(), ch)` inside a request handler |
| ✅ | `pubsub := redis.Subscribe(r.Context(), ch)` |
| ❌ | `db.Exec(context.Background(), query, args...)` inside a job handler |
| ✅ | `db.Exec(jobCtx, query, args...)` |

---

## 3. Goroutine and Cancel Lifecycle

**Principle:** Every `context.WithCancel` must have a matching `defer cancel()` in the same function scope to prevent context leaks. The cancel function must be called even when the goroutine exits early. Storing cancel functions in a map requires explicit cleanup on both normal completion and cancellation.

| | Example |
|---|---|
| ❌ | `ctx, cancel := context.WithCancel(parent)` with no `defer cancel()` |
| ✅ | `ctx, cancel := context.WithCancel(parent); defer cancel()` |
| ❌ | `cancelMap[id] = cancel` with cleanup only on success path — leaks on error |
| ✅ | `defer func() { cancelMap.Delete(id); cancel() }()` — always runs |

---

## 4. Concurrency Patterns

**Principle:** Use `sync.WaitGroup` to wait for a known set of goroutines to finish. Use a buffered channel as a semaphore to cap concurrent goroutines. The loop bound and the semaphore capacity serve different purposes — the loop bound is the total work count, the semaphore capacity is the parallelism limit. Both must be driven by the correct variable.

| | Example |
|---|---|
| ❌ | `sem := make(chan struct{}, limit)` but loop runs `for i := 0; i < 5; i++` — `limit` only affects semaphore size, not goroutine count |
| ✅ | Total work count from a slice length; `sem` capacity from the configurable limit |
| ❌ | `go func() { ... }()` with no mechanism to detect completion or propagate errors |
| ✅ | `var wg sync.WaitGroup; wg.Add(1); go func() { defer wg.Done(); ... }(); wg.Wait()` |

---

## 5. Deferred Cleanup

**Principle:** Cleanup calls (`Close`, `Rollback`, `Unlock`) must be deferred immediately after acquisition so they run even if the function returns early due to an error. Relying on cleanup only at the end of a function body is fragile — early returns skip it.

| | Example |
|---|---|
| ❌ | `tx, _ := db.Begin(ctx)` ... `tx.Rollback(ctx)` only at the end — skipped on early return |
| ✅ | `tx, _ := db.Begin(ctx); defer tx.Rollback(ctx)` — runs regardless of exit path |
| ❌ | `conn.Close()` called manually in each error branch |
| ✅ | `defer conn.Close()` immediately after `conn` is acquired |

---

## 6. Structured Logging

Use `log/slog` for all log output. `log.Printf`, `log.Fatalf`, and `fmt.Println` are banned in service code. Every log call includes named key-value fields; bare format strings are not sufficient.

| | Example |
|---|---|
| ❌ | `log.Printf("task failed: %v", err)` — unstructured, no fields |
| ✅ | `slog.Error("task failed", "task_id", taskID, "error", err)` |
| ❌ | `fmt.Println("starting worker")` |
| ✅ | `slog.Info("worker started", "queue", cfg.TaskQueue, "concurrency", cfg.WorkerConcurrency)` |

---

## 7. Package Structure and Constructors

Package names are lowercase single words with no underscores. Each package has one coherent responsibility. Types with external dependencies are always created via a `NewXxx` constructor — never by bare struct literal at the call site.

| | Example |
|---|---|
| ❌ | `package user_service` / `package httpAndDB` |
| ✅ | `package service` / `package store` — one word, one responsibility |
| ❌ | `h := Handler{db: db, log: log}` — bare struct literal with injected deps |
| ✅ | `h := NewHandler(db, log)` — constructor validates and wires |

---

## 8. Interface Placement

Interfaces are defined by the consumer, not the implementer. Every struct field holding an external dependency is typed as an interface declared in the same file — never as a concrete pointer. This prevents import cycles and keeps interfaces minimal.

| | Example |
|---|---|
| ❌ | `type Worker struct { store *postgres.Store; broker *rabbit.Client }` — concrete pointers |
| ✅ | `type Worker struct { store taskStore; broker messageQueue }` with interfaces declared in `processor.go` |
| ❌ | Interface defined in the repository package and imported by the service |
| ✅ | Interface defined in the service/consumer package, satisfied by the repository |

---

## 9. Ownership and Stream Authorization

**Principle:** Go services that broker SSE, WebSocket, queue replay, or resource-scoped background operations must validate ownership before opening the stream or replaying buffered data. Identity setup and resource authorization are separate steps; doing the first does not satisfy the second.

| | Example |
|---|---|
| ❌ | Controller ensures a cookie-based user ID exists, then subscribes to `task:{id}` directly |
| ✅ | Controller/service validates the user can access `task:{id}` before subscribing or replaying data |
| ❌ | Replay buffer or cancel side channel is treated as an internal detail and skips the resource boundary |
| ✅ | Buffered summaries, live events, and cancel signals all respect the same ownership contract |
