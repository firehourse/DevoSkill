# Quality Category: Node.js / TypeScript

Read this file immediately before applying Node.js checks. Apply each section to the code you just wrote, fix failures, then proceed.

---

## 1. Async Error Boundaries

**Principle:** Every `async` function that drives observable state (HTTP response, UI flag, queue message) must have an explicit `catch` or `try/catch/finally`. An unhandled rejection in an Express route or a Vue handler leaves the response hanging or the loading flag permanently set. `finally` is required for any state that must be reset regardless of success or failure.

| | Example |
|---|---|
| ❌ | `app.get('/x', async (req, res) => { const data = await db.query(...); res.json(data); })` — unhandled rejection crashes or hangs |
| ✅ | Wrap in `try/catch` and call `next(error)` or return an error response in the catch block |
| ❌ | `loading.value = true; await fetch(...); loading.value = false` — stuck if fetch rejects |
| ✅ | `try { ... } catch (e) { ... } finally { loading.value = false }` |

---

## 2. HTTP Error Status Codes

**Principle:** Error middleware must map error types to semantically correct HTTP status codes. Returning 400 for all errors makes it impossible for clients to distinguish between their own bad input and a server-side failure. A generic fallback of 500 is correct for unexpected errors; 400-level codes must be reserved for caller errors.

| | Example |
|---|---|
| ❌ | `res.status(400).json({ error: error.message })` for all errors including DB failures |
| ✅ | Attach a `status` property to thrown errors for caller errors; default to 500 for everything else |

---

## 3. RabbitMQ Connection Management

**Principle:** A single shared channel must be reused across publishes. Re-establishing a connection on every publish creates one connection per message and fails silently when the broker is under load. The connection's `close` and `error` events must clear the cached channel so the next publish triggers reconnection.

| | Example |
|---|---|
| ❌ | `await amqp.connect(url)` inside every publish call |
| ✅ | Cached `connection` and `channel`; `connection.on('close', resetChannel)` to invalidate on drop |
| ❌ | No deduplication of concurrent reconnect attempts — multiple callers race to connect |
| ✅ | A single `connectingPromise` variable gates concurrent reconnect attempts |

---

## 4. Top-Level Await and Startup Sequencing

**Principle:** Top-level `await` at module scope runs before the HTTP server starts. This is correct for one-time setup (creating directories, asserting queues), but failures must be handled explicitly — an unhandled rejection at module scope crashes the process with no useful error message. Wrap startup awaits in `try/catch` or a dedicated `start()` function that calls `process.exit(1)` on failure.

| | Example |
|---|---|
| ❌ | `await ensureRabbitChannel()` at top level with no error handling — silent crash on broker unavailability |
| ✅ | Startup sequence wrapped in a `start()` async function with `.catch(err => { console.error(err); process.exit(1); })` |

---

## 5. Redis and ioredis Patterns

**Principle:** `ioredis` retries failed commands by default. Set `maxRetriesPerRequest: null` on subscribers and `lazyConnect: false` on clients that must be ready before the server starts. Never ignore the return value of `publish` or `set` in paths where failure would leave state inconsistent.

| | Example |
|---|---|
| ❌ | `new Redis(url)` with default options used as a blocking subscriber — unexpected retry behavior |
| ✅ | `new Redis(url, { maxRetriesPerRequest: null })` for subscriber clients |
| ❌ | `redis.set(key, value)` fire-and-forget in a transactional path |
| ✅ | `await redis.set(key, value)` and handle the error |

---

## 6. Resource Authorization at HTTP and Stream Boundaries

**Principle:** Node services often validate ownership on CRUD endpoints but forget streaming, upload, replay, or cancel-adjacent paths. Every boundary that accepts user-controlled identifiers must enforce the same authorization contract before exposing data or mutating resource state.

| | Example |
|---|---|
| ❌ | `GET /tasks/:id` checks owner, but `GET /tasks/:id/events` or `DELETE /tasks/:id` skips the same ownership rule |
| ✅ | Shared service/repository checks enforce the owner boundary across all task-scoped endpoints |
| ❌ | Upload route trusts the task ID and writes to storage before verifying the task belongs to the caller |
| ✅ | Ownership and state validation occur before irreversible side effects such as file writes or job publishes |

---

## 7. Integration Test Environment

**Principle:** Integration tests that touch a real DB or queue must be self-contained. Tests that depend on an external database at a hardcoded address cannot run in CI without pre-provisioned infrastructure, and they silently diverge from production schema when migrations are not applied.

| | Example |
|---|---|
| ❌ | `process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/...'` hardcoded at the top of a test file |
| ✅ | `usePostgres()` in `beforeAll` starts a Testcontainers PostgreSQL container and sets `DATABASE_URL` from the container URI before any connection is made |
| ❌ | `new PrismaClient()` called at module import time — executes before `beforeAll` sets `DATABASE_URL`, connects to the wrong host |
| ✅ | PrismaClient is lazy-initialized (e.g. via a Proxy) so the first real access happens after `beforeAll` configures the container URL |
| ❌ | Redis queue behavior validated by asserting console output |
| ✅ | Redis Testcontainer started in `beforeAll`; test asserts queue depth and job payload directly against the container |
| ❌ | External services (LLM, TTS, S3) mocked at the HTTP level with no consistent stub policy across tests |
| ✅ | Stub boundary is at the service layer (e.g. `jest.spyOn(llmService, 'generate')`); real DB and real queue run in containers; only external network calls are stubbed |
