# Quality Category: Node.js / TypeScript

Read this file immediately before applying Node.js checks. Apply each section to the code you just wrote, fix failures, then proceed.

---

## 1. Async Error Boundaries

**Principle:** Every `async` function that drives observable state (HTTP response, UI flag, queue message) must have an explicit `catch` or `try/catch/finally`. An unhandled rejection in an Express route or a Vue handler leaves the response hanging or the loading flag permanently set. `finally` is required for any state that must be reset regardless of success or failure.

| | Example | Why |
|---|---|---|
| ❌ | `app.get('/x', async (req, res) => { const data = await db.query(...); res.json(data); })` — unhandled rejection crashes or hangs | unhandled rejection hangs request |
| ✅ | Wrap in `try/catch` and call `next(error)` or return an error response in the catch block | response always resolves |
| ❌ | `loading.value = true; await fetch(...); loading.value = false` — stuck if fetch rejects | flag stuck on rejection |
| ✅ | `try { ... } catch (e) { ... } finally { loading.value = false }` | flag reset on every path |

---

## 2. HTTP Error Status Codes

**Principle:** Error middleware must map error types to semantically correct HTTP status codes. Returning 400 for all errors makes it impossible for clients to distinguish between their own bad input and a server-side failure. A generic fallback of 500 is correct for unexpected errors; 400-level codes must be reserved for caller errors.

| | Example | Why |
|---|---|---|
| ❌ | `res.status(400).json({ error: error.message })` for all errors including DB failures | masks server faults as client errors |
| ✅ | Attach a `status` property to thrown errors for caller errors; default to 500 for everything else | clients distinguish 4xx from 5xx |

---

## 3. RabbitMQ Connection Management

**Principle:** A single shared channel must be reused across publishes. Re-establishing a connection on every publish creates one connection per message and fails silently when the broker is under load. The connection's `close` and `error` events must clear the cached channel so the next publish triggers reconnection.

| | Example | Why |
|---|---|---|
| ❌ | `await amqp.connect(url)` inside every publish call | one connection per message, exhausts broker |
| ✅ | Cached `connection` and `channel`; `connection.on('close', resetChannel)` to invalidate on drop | reused channel, reconnects on drop |
| ❌ | No deduplication of concurrent reconnect attempts — multiple callers race to connect | connection storm on drop |
| ✅ | A single `connectingPromise` variable gates concurrent reconnect attempts | one reconnect shared by all callers |

---

## 4. Top-Level Await and Startup Sequencing

**Principle:** Top-level `await` at module scope runs before the HTTP server starts. This is correct for one-time setup (creating directories, asserting queues), but failures must be handled explicitly — an unhandled rejection at module scope crashes the process with no useful error message. Wrap startup awaits in `try/catch` or a dedicated `start()` function that calls `process.exit(1)` on failure.

| | Example | Why |
|---|---|---|
| ❌ | `await ensureRabbitChannel()` at top level with no error handling — silent crash on broker unavailability | crashes with no diagnostic |
| ✅ | Startup sequence wrapped in a `start()` async function with `.catch(err => { console.error(err); process.exit(1); })` | logged failure, clean exit code |

---

## 5. Redis and ioredis Patterns

**Principle:** `ioredis` retries failed commands by default. Set `maxRetriesPerRequest: null` on subscribers and `lazyConnect: false` on clients that must be ready before the server starts. Never ignore the return value of `publish` or `set` in paths where failure would leave state inconsistent.

| | Example | Why |
|---|---|---|
| ❌ | `new Redis(url)` with default options used as a blocking subscriber — unexpected retry behavior | retries break blocking subscriber |
| ✅ | `new Redis(url, { maxRetriesPerRequest: null })` for subscriber clients | disables retry on blocking commands |
| ❌ | `redis.set(key, value)` fire-and-forget in a transactional path | silent write loss |
| ✅ | `await redis.set(key, value)` and handle the error | failure surfaced and handled |

---

## 6. Resource Authorization at HTTP and Stream Boundaries

**Principle:** Node services often validate ownership on CRUD endpoints but forget streaming, upload, replay, or cancel-adjacent paths. Every boundary that accepts user-controlled identifiers must enforce the same authorization contract before exposing data or mutating resource state.

| | Example | Why |
|---|---|---|
| ❌ | `GET /tasks/:id` checks owner, but `GET /tasks/:id/events` or `DELETE /tasks/:id` skips the same ownership rule | IDOR on secondary endpoints |
| ✅ | Shared service/repository checks enforce the owner boundary across all task-scoped endpoints | uniform ownership enforcement |
| ❌ | Upload route trusts the task ID and writes to storage before verifying the task belongs to the caller | writes before authorization |
| ✅ | Ownership and state validation occur before irreversible side effects such as file writes or job publishes | no side effects until authorized |

---

## 7. Integration Test Environment

**Principle:** Integration tests that touch a real DB or queue must be self-contained. Tests that depend on an external database at a hardcoded address cannot run in CI without pre-provisioned infrastructure, and they silently diverge from production schema when migrations are not applied.

| | Example | Why |
|---|---|---|
| ❌ | `process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/...'` hardcoded at the top of a test file | needs pre-provisioned DB, fails in CI |
| ✅ | `usePostgres()` in `beforeAll` starts a Testcontainers PostgreSQL container and sets `DATABASE_URL` from the container URI before any connection is made | self-contained, runs anywhere |
| ❌ | `new PrismaClient()` called at module import time — executes before `beforeAll` sets `DATABASE_URL`, connects to the wrong host | connects before container ready |
| ✅ | PrismaClient is lazy-initialized (e.g. via a Proxy) so the first real access happens after `beforeAll` configures the container URL | first access sees container URL |
| ❌ | Redis queue behavior validated by asserting console output | tests log lines, not behavior |
| ✅ | Redis Testcontainer started in `beforeAll`; test asserts queue depth and job payload directly against the container | asserts real queue state |
| ❌ | External services (LLM, TTS, S3) mocked at the HTTP level with no consistent stub policy across tests | inconsistent stubs drift from reality |
| ✅ | Stub boundary is at the service layer (e.g. `jest.spyOn(llmService, 'generate')`); real DB and real queue run in containers; only external network calls are stubbed | only true externals stubbed |
