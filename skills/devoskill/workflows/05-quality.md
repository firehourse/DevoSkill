# Quality Workflow

Apply this workflow as a pre-completion gate at the end of any implementation phase. For each category, read the principle, then use the examples to pattern-match against the produced code. Fix failures before writing back to `task.md`.

---

## 1. Resource Lifecycle

**Principle:** Every resource with a finite lifetime (connection, subscription, goroutine, stream) must be bound to the narrowest context that spans its entire useful life. Cleanup and error-recovery paths must use a context that is guaranteed to still be alive — never the operation's own context, which may already be cancelled by the time cleanup runs.

| | Example |
|---|---|
| ❌ | `pubsub := client.Subscribe(context.Background(), ch)` inside a request handler — leaks after client disconnects |
| ✅ | `pubsub := client.Subscribe(r.Context(), ch)` — cancelled automatically when request ends |
| ❌ | `failTask(taskCtx, db, id, err)` where `taskCtx` was cancelled by the error that triggered the call |
| ✅ | `failTask(parentCtx, db, id, err)` — parent context is always alive for cleanup |
| ❌ | `EventSource` opened in a component with no teardown hook |
| ✅ | `onBeforeUnmount(() => eventSource.close())` |

---

## 2. Configuration Application

**Principle:** Every configurable parameter must be traced from its declaration all the way to the line where it actually governs behavior. Reading a value into a variable is not sufficient — the variable must be applied. If the variable is declared but the behavior still uses a hardcoded value, the configuration is silently ignored.

| | Example |
|---|---|
| ❌ | `limit := envInt("CONCURRENCY", 5)` then `for i := 0; i < 5; i++` — `limit` is never used |
| ✅ | `limit := envInt("CONCURRENCY", 5)` then `for i := 0; i < limit; i++` |
| ❌ | `maxSize := parseIntEnv("MAX_BYTES", 50MB)` declared but upload pipeline has no byte cap |
| ✅ | `maxSize` wired into both the Content-Length pre-check and the streaming byte counter |

---

## 3. Input Validation

**Principle:** Validators at system boundaries must match the documented format specification exactly, not approximately. An approximate pattern accepts inputs the system was never designed to handle, creating logic errors and potential injection vectors. Validate at the point where untrusted data enters — not deeper in the call stack.

| | Example |
|---|---|
| ❌ | `^[0-9a-fA-F-]{36}$` for UUID — a string of 36 dashes passes |
| ✅ | `^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$` |
| ❌ | File upload accepted without size or type check |
| ✅ | Content-Length pre-check + streaming byte counter, both enforced |
| ❌ | Cookie value forwarded as user ID with no format validation |
| ✅ | Cookie validated against expected pattern before forwarding |

---

## 4. Fault Tolerance

**Principle:** Every long-lived connection or subscription to an external service must recover from both startup failure and mid-run disconnection. This applies equally to message consumers, publishers, and side-channel subscriptions (e.g. cancel signals, broadcast listeners) — a side channel that silently stops on disconnect is just as broken as a dead main consumer.

| | Example |
|---|---|
| ❌ | Connect once at startup; if the service drops the process silently stops consuming |
| ✅ | Each connection type has a reconnect loop that activates on both startup failure and disconnect notification |
| ❌ | A publisher opens a new connection per message — one-shot pattern with no retry |
| ✅ | Publisher holds a shared long-lived channel; retries on error before reconnecting |
| ❌ | A side-channel subscriber (e.g. cancel, config broadcast) has no reconnect — treated as "less important" |
| ✅ | Side-channel subscribers are wrapped in the same reconnect loop as primary consumers |

---

## 5. Operational Hygiene

**Principle:** Ephemeral store entries must expire. Runtime-generated files must never appear in version control. Both are invisible costs that accumulate silently — unbounded Redis keys fill memory, committed artifacts pollute history and leak data.

`.gitignore` is not a cleanup step — it is a precondition. It must exist and cover all build output, compiled binaries, uploaded files, and dependency directories **before the first commit that runs the build or installs dependencies**. Adding it afterwards does not remove already-tracked files; those require an explicit `git rm --cached`.

| | Example |
|---|---|
| ❌ | `redis.Set(ctx, key, value, 0)` — TTL of zero means it never expires |
| ✅ | `redis.Set(ctx, key, value, 24*time.Hour)` — explicit TTL tied to realistic data lifetime |
| ❌ | `.gitignore` added after `node_modules/`, `dist/`, or compiled binaries are already tracked — artifacts remain in history |
| ✅ | `.gitignore` covering `node_modules/`, `dist/`, build binaries, and upload directories is the **first file committed** in any new project |
| ❌ | Upload directory (`data/uploads/`) not in `.gitignore` — test files accumulate in the repo |
| ✅ | `data/uploads/` in `.gitignore` with a `.gitkeep` to preserve the directory structure |

---

## 6. Identity and Security

**Principle:** Generated identifiers, session tokens, and nonces must use a cryptographically random source. Time-based or sequential values are predictable and can be guessed or collided. Apply the strictest practical source available in the language.

| | Example |
|---|---|
| ❌ | `"user-" + time.Now().Format("20060102150405")` — two requests in the same second collide |
| ✅ | `"user_" + hex.EncodeToString(cryptoRandBytes(16))` |
| ❌ | `Math.random()` for any security-relevant token |
| ✅ | `crypto.randomUUID()` or `crypto.getRandomValues()` |

---

## 7. Graceful Shutdown

**Principle:** Every long-running process must intercept OS termination signals and propagate them to in-flight work before the process exits. Without this, a container orchestrator's graceful stop window is wasted — the process is force-killed mid-job, dropping work silently. The signal should cancel a root cancellation token or channel that all workers and loops already respect.

| | Example |
|---|---|
| ❌ | Process root context / main loop has no awareness of SIGTERM — workers are killed mid-flight |
| ✅ | Termination signal cancels a root token; all workers and subscriber loops exit cleanly when they observe it |
| ❌ | Background workers started at startup are never told to stop — they leak until force-kill |
| ✅ | Every background worker receives the root cancellation token and exits its loop when it is cancelled |

---

## 8. Frontend Async Hygiene

**Principle:** Every async operation that drives UI state must handle both success and failure explicitly. A missing `catch` or `finally` leaves loading flags permanently set and the UI frozen. Every long-lived browser connection must be closed when the component that owns it is torn down.

| | Example |
|---|---|
| ❌ | `creating.value = true; await fetch(...); creating.value = false` — stuck if fetch throws |
| ✅ | `try { ... } catch (e) { errorMessage.value = e.message } finally { creating.value = false }` |
| ❌ | `eventSource = new EventSource(url)` with no teardown |
| ✅ | `onBeforeUnmount(() => eventSource?.close())` |
