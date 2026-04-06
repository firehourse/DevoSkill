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
