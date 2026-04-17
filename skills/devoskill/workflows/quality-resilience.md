# Quality Category: Resilience

Read this file immediately before applying resilience checks. Apply each section in order. Fix failures before moving on.

---

## 1. Graceful Shutdown

**Principle:** Long-running processes must observe SIGTERM and SIGINT, complete in-flight work, and release resources in the correct order. Force-kill is not a valid shutdown strategy.

| | Example |
|---|---|
| ❌ | Worker loop with no signal handler — only stoppable by SIGKILL |
| ✅ | `process.on('SIGTERM', shutdown)` sets a stop flag; the run loop checks it before claiming the next job |
| ❌ | `prisma.$disconnect()` called immediately on signal, before in-flight DB writes finish |
| ✅ | Stop accepting new work → await in-flight work promise → then disconnect DB |
| ❌ | SIGINT and SIGTERM each trigger a full shutdown sequence — if both arrive simultaneously, resources are released twice |
| ✅ | `let shutdownPromise: Promise<void> \| null = null` — first signal sets it; subsequent signals return the same promise (idempotency guard) |

---

## 2. Fault Tolerance

**Principle:** Every long-lived connection or subscription must recover from startup failure and mid-run disconnect. A service that dies silently on broker restart is not fault-tolerant.

| | Example |
|---|---|
| ❌ | One-shot `connect()` at startup with no reconnect path — dies silently on broker restart |
| ✅ | Connection error triggers reconnect with backoff; subscriber re-registers after reconnect |
| ❌ | Redis subscriber that stops processing on disconnect with no error event handler |
| ✅ | `client.on('error', ...)` triggers reconnect and re-subscription |
| ❌ | Lazy Redis connection initialized at import time — test container URL not yet set |
| ✅ | Redis connection deferred until first use so test setup can configure host/port before connecting |

---

## 3. Async Task State Machine

**Principle:** Every intermediate state in a DB-backed async task (e.g. GENERATING, POST_PROCESSING) must have an explicit failure exit. A task must never be left stuck in an intermediate state with no recovery path — front-end polling and repair loops both depend on deterministic terminal states.

| | Example |
|---|---|
| ❌ | Task goes PENDING → GENERATING, but on TTS failure the status is never updated — front-end polls forever |
| ✅ | Every `catch` block in the processing pipeline calls `updateFailed(taskId, errorMessage)` to set status FAILED |
| ❌ | Error is logged to console but not persisted — operators cannot see why a task failed |
| ✅ | Failure writes structured error context to DB (e.g. `responseMeta: { error: message }`) so state is inspectable without log access |
| ❌ | Post-processing failure (e.g. S3 upload after generation) requeues the entire task — expensive generation step runs again |
| ✅ | Post-processing runs in a separate `try/catch`; failure leaves the task in POST_PROCESSING for a repair loop to retry without re-running generation |
| ❌ | Repair loop treats "no promptId" the same as "promptId exists but remote job unknown" — both reset retry count |
| ✅ | No promptId → crashed before submission → `resetToPending` without consuming a retry. PromptId exists → query remote status → complete, extend lease, or requeue based on result |
