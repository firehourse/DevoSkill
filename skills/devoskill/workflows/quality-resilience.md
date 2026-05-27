# Quality Category: Resilience

Read this file immediately before applying resilience checks. Apply each section in order. Fix failures before moving on.

---

## 1. Graceful Shutdown

**Principle:** Long-running processes must observe SIGTERM and SIGINT, complete in-flight work, and release resources in the correct order. Force-kill is not a valid shutdown strategy.

| | Example | Why |
|---|---|---|
| ❌ | Worker loop with no signal handler — only stoppable by SIGKILL | in-flight work killed mid-job |
| ✅ | `process.on('SIGTERM', shutdown)` sets a stop flag; the run loop checks it before claiming the next job | graceful drain on shutdown |
| ❌ | `prisma.$disconnect()` called immediately on signal, before in-flight DB writes finish | writes severed, data loss |
| ✅ | Stop accepting new work → await in-flight work promise → then disconnect DB | correct release ordering |
| ❌ | SIGINT and SIGTERM each trigger a full shutdown sequence — if both arrive simultaneously, resources are released twice | double release, race |
| ✅ | `let shutdownPromise: Promise<void> \| null = null` — first signal sets it; subsequent signals return the same promise (idempotency guard) | shutdown runs once |

---

## 2. Fault Tolerance

**Principle:** Every long-lived connection or subscription must recover from startup failure and mid-run disconnect. A service that dies silently on broker restart is not fault-tolerant.

| | Example | Why |
|---|---|---|
| ❌ | One-shot `connect()` at startup with no reconnect path — dies silently on broker restart | permanent outage after restart |
| ✅ | Connection error triggers reconnect with backoff; subscriber re-registers after reconnect | self-heals after disconnect |
| ❌ | Redis subscriber that stops processing on disconnect with no error event handler | silent stall, no recovery |
| ✅ | `client.on('error', ...)` triggers reconnect and re-subscription | disconnect drives recovery |
| ❌ | Lazy Redis connection initialized at import time — test container URL not yet set | connects to wrong/unset host |
| ✅ | Redis connection deferred until first use so test setup can configure host/port before connecting | config applied before connect |

---

## 3. Async Task State Machine

**Principle:** Every intermediate state in a DB-backed async task (e.g. GENERATING, POST_PROCESSING) must have an explicit failure exit. A task must never be left stuck in an intermediate state with no recovery path — front-end polling and repair loops both depend on deterministic terminal states.

| | Example | Why |
|---|---|---|
| ❌ | Task goes PENDING → GENERATING, but on TTS failure the status is never updated — front-end polls forever | stuck state, no terminal exit |
| ✅ | Every `catch` block in the processing pipeline calls `updateFailed(taskId, errorMessage)` to set status FAILED | deterministic FAILED terminal |
| ❌ | Error is logged to console but not persisted — operators cannot see why a task failed | failure cause invisible to operators |
| ✅ | Failure writes structured error context to DB (e.g. `responseMeta: { error: message }`) so state is inspectable without log access | cause inspectable in DB |
| ❌ | Post-processing failure (e.g. S3 upload after generation) requeues the entire task — expensive generation step runs again | wasteful regeneration |
| ✅ | Post-processing runs in a separate `try/catch`; failure leaves the task in POST_PROCESSING for a repair loop to retry without re-running generation | retries only the cheap step |
| ❌ | Repair loop treats "no promptId" the same as "promptId exists but remote job unknown" — both reset retry count | conflates distinct failure states |
| ✅ | No promptId → crashed before submission → `resetToPending` without consuming a retry. PromptId exists → query remote status → complete, extend lease, or requeue based on result | state-specific recovery |
