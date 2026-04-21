# Go Implementation Mode Protocol

Use this shared protocol during Development, Review, Debug/Performance, and Go quality checks whenever Go code is in scope.

The goal is to choose the right engineering mode before adding abstractions. Go services often need either a high-performance shape or a high-modularity shape. Treating both as the same style causes avoidable latency, allocation, and readability costs.

This file is the single source of truth for Go mode selection. Phase skills and quality workflows should reference it instead of duplicating mode definitions or examples.

## 1. Classify First

Before changing or reviewing Go code, classify the touched area as exactly one mode:

- **High-Performance Go**: latency, throughput, allocation volume, queue/stream processing, cache/database/network round trips, or hot-path concurrency are central to correctness or operations.
- **High-Modularity Go**: replaceable providers, plugin-like boundaries, broad domain composition, team ownership boundaries, or long-lived API contracts matter more than raw hot-path cost.

If both apply, use high-performance mode for the hot path and keep modular seams outside it.

## 2. Routing Examples

Use these examples to route before editing:

| Code area | Mode | Reason |
|---|---|---|
| Queue worker, stream consumer, fanout loop, retry loop | High-Performance Go | Throughput, backpressure, retries, and goroutine lifecycle are part of runtime correctness. |
| Rate limiter, Redis/cache token flow, lock, dedupe, TTL lifecycle | High-Performance Go | Extra abstraction can hide allocation, round trips, or atomicity assumptions. |
| Order, registration, payment, inventory, quota, or ticketing hot path | High-Performance Go | State transitions and external calls must stay inspectable. |
| SSE, WebSocket, pub/sub bridge, long-polling, live replay | High-Performance Go | Cancellation, ownership, buffering, and fanout behavior must stay visible. |
| Provider adapter boundary, replaceable SDK, storage backend switch | High-Modularity Go | The replacement boundary is intentional and should be explicit. |
| Admin CRUD, reporting, backoffice orchestration, domain policy package | High-Modularity Go | Maintainability and ownership boundaries usually matter more than hot-path cost. |
| Public package API used by multiple services | High-Modularity Go | Contract stability and narrow dependency seams matter. |

Mixed cases are allowed, but the split must be explicit: keep the hot path high-performance and place modular interfaces at the outer provider or ownership boundary.

## 3. High-Performance Go Rules

Use these rules for queue workers, streaming, event fanout, registration/order/payment flows, rate limits, cache-heavy paths, and measured bottlenecks.

- Preserve direct control flow. Do not add deep handler/service/repository stacks unless the repository already uses that shape in the same area.
- Prefer concrete structs, small package-local helpers, and explicit dependency passing over broad interfaces.
- Keep SQL, cache, network calls, goroutine creation, retries, timers, and allocation-heavy transformations visible near the business flow.
- Avoid reflection-heavy frameworks, generic abstraction layers, hidden global registries, and interface-heavy mocking seams on hot paths.
- Add benchmarks or measured evidence before claiming performance improvement.
- Keep tests close to the real execution path; use fakes only where the external boundary is expensive or nondeterministic.

## 4. High-Modularity Go Rules

Use these rules when the codebase already prioritizes package boundaries, provider replacement, long-term domain composition, or independent team ownership.

- Define interfaces at the consumer boundary, and keep each interface minimal.
- Package by capability or domain ownership, not by abstract technical categories alone.
- Accept extra indirection only when it reduces real cross-module coupling or enables a documented replacement boundary.
- Keep constructors explicit so dependency graphs remain inspectable.
- Use mocks at package boundaries where they prove domain behavior, not as a default for every helper.

## 5. Review Gate

Wrong mode choice is a quality issue:

- Flag high-performance code that gained unnecessary interfaces, reflection, hidden allocations, or deep layering.
- Flag high-modularity code that hard-codes provider choices across ownership boundaries.
- When a change mixes modes, require the task or architecture document to name which package/path is hot-path performance code and which package/path is modular boundary code.
