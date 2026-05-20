# Quality Workflow — Comment & Doc Style

Apply during development and review whenever code is added, modified, or refactored. Fix any failures before writing back to `task.md`.

This workflow owns the executable contract for what makes a comment worth its line cost. The principles are language-neutral; the examples below are drawn from a Go HTTP service that exercises proxy chain walking, panic recovery, error-table middleware, cache lifetimes, and observability sequencing because those shapes repeatedly demonstrate each rule. Translate the syntactic shape to the target language when applying to Ruby, Node, Python, etc.

When adding or revising rules in this file, follow `../protocols/standard-authoring.md`: state the principle, define concrete checks, and include positive/negative examples that a reviewer can match against a diff hunk.

---

## 1. Comments Carry Non-Obvious Intent

**Principle:** Every comment must add information not derivable from the surrounding identifiers, types, or one-statement code window. Comments that restate the next statement waste reader attention and rot when the code is renamed or restructured. If removing the comment would not change a future reader's understanding, do not write it.

Required check:
- Cover (at least one of): a hidden constraint, an invariant, an ordering hazard, a trade-off, a cross-layer contract, a deliberately-rejected alternative, or a fail-mode policy decision.
- Reject comments that paraphrase the next line ("increment counter", "loop over items", "return result").

| | Example |
|---|---|
| ❌ | `// loop over parts and trim each` above a straightforward `for` over `strings.Split(...)` |
| ✅ | `// Walk right-to-left, returning the first untrusted entry. Track the leftmost non-empty entry as we go: if every entry turns out to be trusted (intra-VPC traffic), the leftmost is the original-client claim added by the first trusted proxy.` |
| ❌ | `// assign error` above `err = utils.ErrFromRecover(rec)` |
| ✅ | `// Set err first so a panic in slog/rollbar below still leaves AccessLog with the original panic value to log.` |

---

## 2. Exported Doc Comments Open With the Identifier

**Principle:** Every exported function, method, type, and constant carries a doc comment whose first sentence begins with the identifier name. The first sentence states the contract — return semantics, side effects, or scope — not the implementation. This shape is mandatory for Go (godoc renders it) and the spirit applies in Ruby/TypeScript/Python: the docstring's first line is the caller's contract.

Required check:
- Exported identifier without doc comment → finding.
- Doc comment that does not start with the identifier name (Go) or does not start with a verb describing the contract (other languages) → finding.
- Doc comment that only restates the signature in prose → finding.

| | Example |
|---|---|
| ❌ | `// gets the client ip` above `func ClientIPFromContext(ctx context.Context) string` |
| ✅ | `// ClientIPFromContext returns the client IP previously stored in ctx by the ClientIP middleware. Returns "" if the middleware did not run.` |
| ❌ | `// Recover function` above `func Recover(next bunrouter.HandlerFunc) bunrouter.HandlerFunc` |
| ✅ | `// Recover catches a panic from the wrapped handler chain, writes a JSON 500 response (if nothing has been written yet), and propagates the panic value as the function's return error so AccessLog records it in the per-request log line at ERROR severity.` |

---

## 3. Document the Contract and Side Effects, Not the Body

**Principle:** Doc comments describe what callers can rely on (return semantics, preconditions, postconditions, panic behavior) and what external state they touch (wire response, logs, observability backends, cookies, headers, caches). The body is visible in the code; the contract and the side effects are not.

Required check:
- For HTTP/RPC handlers and middleware: state the wire response shape, status code, and any header/cookie writes the function performs.
- For functions that emit logs, metrics, or external reports (rollbar, datadog, slack): state which observability surfaces are touched and at what severity.
- Reject doc comments that only describe loops, conditions, or local variable assignment.

| | Example |
|---|---|
| ❌ | `// runs next then checks err and writes json` above an error-mapping middleware |
| ✅ | `// ErrorJSON is a middleware factory. Given an ErrorTable, the produced middleware:\n//   - calls the next handler\n//   - on error, looks it up in the table and writes the corresponding JSON {"result": msg} response\n//   - on a missing entry, logs + reports to rollbar + writes a 500\n//   - in both cases marks the request "handled by ErrorJSON" so AccessLog can pick the appropriate log severity\n//   - returns the original raw error up the chain so AccessLog records the true cause, not the (possibly masked) wire message` |
| ❌ | `// APIError type` above `type APIError struct { Code int; Msg string }` |
| ✅ | `// APIError describes the wire response for a known handler error: the HTTP status code and the message that goes in the {"result": ...} body. APIError is the value type in an ErrorTable; handlers never construct or return one.` |

---

## 4. Precondition Annotations Mark Intentional Defensive-Gap

**Principle:** When a function intentionally omits a defensive check (nil receiver, missing required state, ordering assumption), it must carry a `Precondition:` clause that names (a) what the caller must guarantee, (b) what enforces the guarantee in production, and (c) what surfaces a violation. Silent reliance on caller invariants is a review failure even if the code is currently correct.

Required check:
- Functions that dereference a pointer/receiver without nil-checking → require an explicit `Precondition:` clause.
- Functions whose correctness depends on a prior call having run (cache populated, session resolved, config snapshot taken) → require the clause to name that prior call.
- Comments that hand-wave with "assumed non-nil" without naming enforcement → finding.

| | Example |
|---|---|
| ❌ | `func (e *EventBaseInfo) DuringRegisterIntentPeriod() bool { ... }` with no doc comment, body dereferences `e.Event.RegisterIntentStartAt` |
| ✅ | `// DuringRegisterIntentPeriod reports whether the current time falls within the event's register-intent window.\n//\n// Precondition: e must be non-nil. Callers are expected to fail the request before reaching here when base_info is unavailable; this method intentionally does not nil-check the receiver so that a contract violation surfaces as a panic (caught by the Recover middleware in production, by tests in development).` |
| ❌ | `// validate inventory` above a method that assumes `EventBaseInfo` is loaded |
| ✅ | `// Precondition: es.EventBaseInfo is non-nil. doValidate fails the request before reaching here when base_info is missing.` |

---

## 5. Order-Sensitive Code Names the Hazard the Order Prevents

**Principle:** When statement order matters for correctness — error assignment before observability calls, response writes before logging, defer placement before a call that can panic, mutex unlock placement, transaction rollback placement — the comment states the hazard that the chosen order prevents. The order alone is not self-explanatory; "I wrote it in this order on purpose" must be visible to the next reviewer.

Required check:
- Any reordering that survived a code review with a `// Set X first so ...` or `// ... before ...` comment is a positive signal. Removing such comments while keeping the order is a finding.
- Defer placement that protects a later panic path → comment names the panic source it protects against.
- Sequencing of response write vs. log/metric/report calls → comment names which side is the wire and which is observability.

| | Example |
|---|---|
| ❌ | A `defer func() { ... }` whose body assigns to a named return AND calls slog/rollbar with no comment on why the assignment runs first |
| ✅ | `// Set err first so a panic in slog/rollbar below still leaves AccessLog with the original panic value to log.\nerr = utils.ErrFromRecover(rec)\n\n// Write the response next. Only write if nothing has already been sent (e.g. handler wrote partial output before panicking).\n...\n\n// Observability last. If these panic, the secondary panic escapes to the outer Recover — by this point the wire is already consistent so there's nothing to corrupt.` |
| ❌ | `// set content type and write status` above an HTTP write |
| ✅ | `// JSON helper: set Content-Type: application/json before WriteHeader` — names the hazard (Go's `http.ResponseWriter` ignores header writes after `WriteHeader`) |

---

## 6. Fail-Mode Keywords (fail-open / fail-closed / fail-fast) Are Mandatory

**Principle:** When a code path makes a deliberate choice about behavior under partial information or external failure, the comment names the chosen failure mode explicitly using one of `fail-open`, `fail-closed`, or `fail-fast`, and states the rationale (what the alternative would cost, who owns the downstream guard). This makes the ops decision inspectable without re-deriving it from the surrounding flow.

Required check:
- Any catch-and-continue pattern → must say `fail-open` and name what enforces correctness downstream.
- Any hard-stop on missing state → must say `fail-closed` (or `fail-fast` for startup-time bailouts) and name the alternative that was rejected.
- Vague phrases like "just continue" / "skip if error" without a fail-mode label → finding.

| | Example |
|---|---|
| ❌ | `// if cache fails just continue` above a `slog.Error(...)` plus continue |
| ✅ | `// 庫存資料抓不到時 fail-open: 讓使用者照常排隊, 由後端 worker 真正建單時再回頭判斷.\n// 理由是 inventory upstream 短暫掛掉時不該全站擋下單; 後端建單仍會擋住超賣.` |
| ❌ | `// require base info` above a `return err` on nil base_info |
| ✅ | `// base_info 拿不到就直接失敗 — 後續的票券 / 庫存 / captcha / 登入需求檢查都依賴 base_info，不能在缺資料時假裝通過。` (implicit fail-closed; the next line returns an error) |
| ❌ | `const writeTimeout = 30 * time.Second` |
| ✅ | `// mustDuration reads a positive duration from viper or panics. viper's GetDuration silently returns 0 on parse failure or empty input, which would defeat the slowloris-protection timeouts; failing fast at startup surfaces a misconfigured env var loudly.` |

---

## 7. Cross-Layer Error Wrapping States Both Wire and Log Cause

**Principle:** When a function wraps an error so that one chain layer (wire response via error table, status code mapper, frontend reload trigger) sees a sentinel and another layer (access log, observability, debugger) sees the underlying cause, the comment must say which layer sees what. Otherwise a future reviewer cannot tell whether the wrapping is load-bearing or accidental.

Required check:
- `fmt.Errorf("%w: %w", sentinel, cause)` (or equivalent in other languages) → require a comment naming (a) the sentinel-mapping consumer and the resulting wire shape, (b) the raw-cause consumer (log, debugger).
- Raw sentinel return (no wrap) inside a chain that mostly wraps → require a one-line comment stating "Raw sentinel — the table maps to ...".

| | Example |
|---|---|
| ❌ | `return fmt.Errorf("%w: %w", utils.InvalidRequestBody, err)` with no comment |
| ✅ | `// Wrap so the wire response stays 403 InvalidRequestBody (via errors.Is lookup in ErrorJSON) while the access log carries the real cause (e.g. http.MaxBytesError, JSON parse error).\nreturn fmt.Errorf("%w: %w", utils.InvalidRequestBody, err)` |
| ❌ | `return fmt.Errorf("%w: %w", utils.ErrUserInfoUnavailable, err)` returned alongside other sentinels with no rationale |
| ✅ | `// 用 csrf token 失效的名義通知前端 reload 以回填 user cache.\n// ErrUserInfoUnavailable maps to the same 403 + "Can't verify CSRF token authenticity" wire shape as CsrfError (the frontend treats both the same way and reloads), but the dedicated sentinel keeps the access-log signal distinct from genuine CSRF failures. The wrapped err records the underlying cause (redis.Nil, network err, JSON parse err).` |
| ❌ | `return utils.ErrCreditScoreCheckFailed` |
| ✅ | `// Raw sentinel — the table maps to 200 "not available".\nreturn utils.ErrCreditScoreCheckFailed` |

---

## 8. Multi-Branch Algorithms Use Numbered Steps and Name Rejected Alternatives

**Principle:** When a function implements a multi-branch resolution algorithm — proxy chain walk, retry/fallback ladder, multi-source lookup, conflict resolution — the doc comment enumerates the steps as a numbered list and explicitly names any alternative that was deliberately rejected (and why). A prose paragraph is not enough; the reader needs to map each branch in the code to a step in the spec.

Required check:
- Algorithms with ≥ 3 decision branches → doc comment must contain a numbered step list.
- If a commonly-tempting alternative exists and was rejected → comment must name it and state the rejection reason in the same block.
- Bullet-list-only or unstructured prose for ≥ 3-branch algorithms → finding.

| | Example |
|---|---|
| ❌ | `// resolve client ip from xff header or remote addr` above a 30-line function with five branches |
| ✅ | `// ClientIP resolves the client IP once per request and stows it in the request context. Read it via ClientIPFromContext(ctx).\n//\n// Algorithm (trusted-proxies, rightmost-untrusted):\n//  1. Parse RemoteAddr → connecting IP.\n//  2. If connecting IP is NOT in `trusted`, return it. Ignore XFF — an untrusted connection could forge any header it likes.\n//  3. Else walk X-Forwarded-For RIGHT → LEFT and return the first entry whose IP is not in `trusted`. That's the real client: the hop just past our trusted edge.\n//  4. If every XFF entry is trusted (e.g. intra-VPC traffic where the originating client is also inside the trusted CIDR), return the leftmost XFF entry — the original-client claim made by the first trusted proxy, which we trust by definition.\n//  5. If XFF is empty, fall back to the connecting IP.\n//\n// The leftmost XFF entry is intentionally NOT used: any client can set it before reaching the first proxy in the chain.` |

---

## 9. Constants Document Policy, Not Value

**Principle:** A named constant whose value encodes operational policy (size cap, timeout, retry count, rate-limit window, buffer size) carries a doc comment explaining (a) what scenario the value protects against, (b) the magnitude of expected legitimate input and the headroom chosen, and (c) any condition that would justify revisiting the value. The bare number is not the documentation; the policy is.

Required check:
- Constants with operational impact (limits, timeouts, retries, buffers) → require a doc comment with scenario + magnitude rationale.
- Constants that are simple stable identifiers (cookie names, key prefixes, message types) → exempt; a one-line label is fine.
- Comments that only repeat the value in words ("// 16 KB" above `16 * 1024`) → finding.

| | Example |
|---|---|
| ❌ | `const maxRegistrationBodyBytes = 16 * 1024 // 16 KB cap` |
| ✅ | `// maxRegistrationBodyBytes caps the request body for POST /queue/:slug.\n// A normal registration JSON is well under 1KB (a tickets array, a captcha token, a few flags); 16KB is generous headroom and small enough to cheaply reject abusive uploads before we allocate or parse.\nconst maxRegistrationBodyBytes = 16 * 1024` |
| ❌ | `const writeTimeout = 60 * time.Second // http write timeout` |
| ✅ | `// HTTP_WRITE_TIMEOUT defaults to 60s: long enough for legitimate slow clients on mobile networks to drain a queued response without tripping the slowloris cut, short enough that a stuck connection still releases the goroutine within one minute. Reconsider when add­ing endpoints that stream beyond this budget.` |

---

## 10. Wiring Order Documented at the Wiring Site

**Principle:** When a chain or stack has order-significant composition (HTTP middleware chain, plugin/interceptor pipeline, ordered hooks, registration sequence), the wiring site carries a comment that names (a) the order direction (outermost → innermost or registration → execution), (b) the components in that order, and (c) any intentional exclusion handled by an outer wrapper. If the same component appears at more than one position by design, the comment expands into per-position responsibilities and closes with the shared invariant.

Required check:
- Middleware / interceptor / plugin chain registration → require an order-direction comment listing the components.
- Same component registered at multiple positions → require a per-position responsibility list, otherwise the duplicate looks like a typo.
- Components handled by an outer wrapper (e.g. CORS wrapping the entire router) → require an explicit "handled elsewhere" note in the inner chain's comment so a reviewer does not add a duplicate.

| | Example |
|---|---|
| ❌ | `api := router.NewGroup("", bunrouter.Use(middleware.Recover, middleware.ClientIP, middleware.AccessLog, middleware.Recover, middleware.ErrorJSON(errorTable)))` with no comment on order or the duplicate `Recover` |
| ✅ | `// API routes go through the full middleware chain. Order, outermost\n// → innermost: Recover, ClientIP, AccessLog, Recover, ErrorJSON.\n// CORS is handled by rs/cors wrapping the whole router below, so it\n// is not in this chain.\n//\n// Recover is registered at two positions, by design:\n//   * Inner Recover runs below AccessLog. It catches handler panics\n//     and assigns the recovered value to its named return err\n//     before AccessLog's defer reads err — so AccessLog logs the\n//     request at ERROR severity with the panic message intact.\n//   * Outer Recover sits at the chain edge. It catches panics from\n//     ClientIP / AccessLog itself, or secondary panics from inner\n//     Recover's own slog/rollbar calls.\n// Both positions share the same status-aware implementation: write\n// a JSON 500 only when the response writer hasn't been started,\n// otherwise leave the wire alone so we never corrupt a response\n// that someone else already wrote.` |

---

## 11. Carve-Outs Name the Bypassed Scope and the Actor Consuming It

**Principle:** Any path that intentionally opts out of a cross-cutting concern (middleware chain, validation, rate limit, auth, structured logging) carries a comment that names (a) what is being bypassed, (b) which actor or external system consumes the bypass path, and (c) the observable consequence (no log entries, no metrics, no rate-limit accounting). Without this, an unrelated PR can quietly extend the carve-out and lose the original scope guarantee.

Required check:
- Health-check / monitoring / metrics-scrape endpoints registered outside the main chain → require a comment naming the actor and what is bypassed.
- Routes that skip auth, validation, or rate limiting → require a comment naming why the route is safe to bypass and what guards the path instead.
- Carve-outs that do not name a specific actor (just "for ops") → finding.

| | Example |
|---|---|
| ❌ | `router.GET("/ping", pong); router.HEAD("/ping", pong)` registered on the root group with no comment |
| ✅ | `// /ping is registered on the root group (no middleware) so ALB\n// health checks skip the full chain — no log entries, no IP parsing.` |
| ❌ | An internal admin endpoint registered without auth and no comment naming the perimeter |
| ✅ | An internal endpoint with a comment naming the actor (e.g. "kubelet livenessProbe via cluster-internal IP") and the alternative perimeter protection (e.g. "network ACL is the auth boundary; do not expose this route through the public LB") |

---

## 12. Third-Party Library Defaults That Compose Dangerously Are Documented Inline

**Principle:** When a third-party library has a surprising default that would compose dangerously with our other configuration, silently produce the wrong behavior on misconfig, or impose a protocol contract that the caller must respect, the comment names (a) the library and the surprising default, (b) the composition hazard or library-protocol contract being respected, and (c) the action taken to neutralize the hazard. The comment lives at the configuration / call site, not in commit history.

Required check:
- Third-party library config with surprising default behavior → require an inline comment naming the library, the default, and the hazard.
- Wrapper code that compensates for a library default (manual drain, manual nil check, custom env validation) → require a comment naming the library protocol contract being respected.
- Custom panic-or-bail logic around a third-party config parse → require a comment naming why the library's default behavior is insufficient.

| | Example |
|---|---|
| ❌ | `if len(origins) == 0 { panic("CORS_ALLOW_ORIGIN must list at least one origin") }` with no comment on why the empty-list panic exists |
| ✅ | `// rs/cors treats an empty allowlist as "allow all origins";\n// combined with AllowCredentials below, that would echo any\n// Origin back with credentials enabled. Refuse to start instead.\nif len(origins) == 0 { panic("CORS_ALLOW_ORIGIN must list at least one origin") }` |
| ❌ | `func mustDuration(key string) time.Duration { d := viper.GetDuration(key); if d <= 0 { panic(...) }; return d }` with no comment |
| ✅ | `// mustDuration reads a positive duration from viper or panics. viper's\n// GetDuration silently returns 0 on parse failure or empty input, which\n// would defeat the slowloris-protection timeouts; failing fast at\n// startup surfaces a misconfigured env var loudly.` |
| ❌ | `io.Copy(io.Discard, resp.Body)` immediately after a non-2xx response, with no comment |
| ✅ | `// Drain the body so the keepalive connection can be returned\n// to the pool; net/http only reuses connections after a full\n// read + Close. Without this, every non-2xx response causes\n// a TCP churn against the upstream.\nio.Copy(io.Discard, resp.Body)` |
| ❌ | `Transport: newPooledTransport(20)` with no comment on the magic 20 |
| ✅ | `// http.DefaultTransport keeps only 2 idle conns per host, which causes\n// TCP churn when many slugs refresh through the same upstream\n// concurrently. Bump to 20 so the keepalive pool actually covers the\n// expected peak of in-flight refreshes.` |

---

## 13. Negative-Space Comments for Intentional Absences

**Principle:** When a sentinel, configuration entry, error code, struct field, or table row is intentionally MISSING from a list / map / struct that otherwise enumerates a category, the omission carries an in-place comment that names (a) what is absent, (b) why it is absent, and (c) what code path handles the absent case. Without this, a future maintainer will "fix" the perceived oversight and silently break the design contract.

Required check:
- Maps / tables that enumerate sentinels, error codes, or states → if any logically-expected entry is omitted by design, require a comment naming the missing entry and the rationale.
- Switch statements that intentionally omit a default branch → require a comment naming what makes the default unreachable (typed enum, exhaustive linter, prior validation).
- Struct fields excluded from a serialization tag (`json:"-"`) by design → require a comment naming the omission and the reason.

| | Example |
|---|---|
| ❌ | `var errorTable = middleware.ErrorTable{ ... }` that simply omits `GeneralServerError` with no comment |
| ✅ | `// GeneralServerError is intentionally absent: it represents the\n// unhandled-error path, which ErrorJSON renders directly. Keeping\n// it out of the table forces every 500 through that path, where\n// rollbar + slog ERROR + access-log ERROR severity all fire.` |
| ❌ | A switch on an enum with no `default:` branch and no comment on exhaustiveness |
| ✅ | Switch closing with a comment naming the exhaustiveness guarantor (e.g. `// every CaptchaType is handled above; an unknown value would have been rejected at config parse time`) |

---

## 14. Concurrency-Safety Contracts on Shared Returns

**Principle:** Functions that return a pointer, slice, map, or buffer that may be shared across callers (cache hits, pooled buffers, memoized results, singletons) carry a doc comment that explicitly states (a) the shared-return condition, (b) the read-only contract, and (c) the operations forbidden by the contract (mutate field X, append to slice Y, modify map Z), naming the failure mode it prevents ("cache pollution", "data race"). A vague "treat as read-only" without naming forbidden operations is not enough.

Required check:
- Functions returning pointers / slices / maps from a cache, pool, or singleton → require a read-only contract comment.
- Doc comments that say "treat as read-only" without naming forbidden operations → finding.
- If callers may need a mutable copy, the doc comment names the cloning function.

| | Example |
|---|---|
| ❌ | `// GetEventBaseInfoCache returns the cached base info for slug.` |
| ✅ | `// 注意: 回傳的 *EventBaseInfo 可能與其他併發 caller 共用同一份指標\n// (來自 memorycache tier), 請當作 read-only 使用; 不要 mutate\n// Event 欄位或 append/modify Tickets/StopSellingTickets, 否則會\n// 造成 cache 汙染與 data race.` |
| ❌ | A pooled `*bytes.Buffer` returned without comment on lifetime |
| ✅ | Doc comment naming the pool (`sync.Pool`), the contract ("caller must not retain the buffer past handler return"), and the failure mode ("subsequent caller reads partially-overwritten bytes") |

---

## 15. Background Context Decisions Name the Lifetime and the Bound

**Principle:** When a function chooses `context.Background()` (or any non-request-scoped context) instead of the surrounding request / job context, the comment names (a) why request cancellation would be wrong (e.g. background refresh outlives the request), and (b) what other mechanism bounds the operation's duration (deadline on the inner call, library default timeout, signal-driven cancel at process root). A bare `context.Background()` inside a handler or repository call is a review failure without this rationale.

Required check:
- `context.Background()` used anywhere except the process root → require a comment naming why request ctx is wrong and what bounds duration.
- Background goroutines spawned with non-request ctx → require a comment naming the lifecycle owner (process root, worker pool, shutdown channel).
- Comments that say "background ctx because async" without naming a duration bound → finding.

| | Example |
|---|---|
| ❌ | `ctx := context.Background()` inside a `memorycache.Fetch` callback with no comment |
| ✅ | `// Use a fresh background ctx so background refresh goroutines\n// (which outlive the request handler) aren't cancelled.\n// Note: redis ops here have no explicit deadline; they rely on\n// go-redis's default ReadTimeout (3s).\nctx := context.Background()` |
| ❌ | A worker goroutine launched with `context.Background()` and no shutdown coupling |
| ✅ | Worker goroutine launched with a ctx derived from `signal.NotifyContext` at process root, with a comment naming the signal-driven shutdown path and the `wg.Wait()` site that bounds process exit |

---

## 16. Test Helpers Document Global Mutation and the Cleanup Path

**Principle:** Test helpers that mutate process-global state (default logger, env vars, time source, registered HTTP handlers, default HTTP client) carry a comment that names (a) what global is swapped, (b) the value substituted in, and (c) how the original is restored (`t.Cleanup`, `defer`, helper-returned restore func). Otherwise the swap is undiscoverable from the test body and a flaky run may leak state across tests.

Required check:
- Test helpers that call `slog.SetDefault`, `os.Setenv`, `http.DefaultTransport = ...`, `time.Now = ...`, or any global setter → require a swap-and-restore contract comment.
- Helpers without `t.Cleanup` / `defer` restore → finding.
- Helpers that return a buffer / recorder driven by the swapped global → require the comment to name the read path.

| | Example |
|---|---|
| ❌ | `func captureLog(t *testing.T) *bytes.Buffer { buf := &bytes.Buffer{}; slog.SetDefault(...); return buf }` with no comment |
| ✅ | `// captureLog swaps slog.Default for a JSON handler writing to a\n// buffer. Returns the buffer; the handler is restored via t.Cleanup.` |
| ❌ | `func lastLogEntry(t *testing.T, buf *bytes.Buffer) map[string]any { ... }` with no comment on the "last line" assumption |
| ✅ | `// lastLogEntry decodes the final JSON object in buf. AccessLog emits\n// exactly one line per request via its defer, so this is the one we want.` |
| ❌ | A helper that sets an env var without restoring |
| ✅ | A helper that calls `os.Setenv` and registers `t.Cleanup(func() { os.Unsetenv(...) })`, with a comment naming the env key and the restore path |

---

## 17. Test Invariants Reference the Named Design Contract

**Principle:** When a test exists specifically to prove a named design contract — a fail-mode invariant, an ordering invariant, a never-write-twice invariant — the test body (or its inline comment) references the invariant by name or by the design document section. This makes the test ↔ contract link inspectable: a reviewer changing the contract can grep for the invariant label to find every test that pins it. Smoke tests that just check "no error" are not subject to this rule.

Required check:
- Tests that prove a specific design-document invariant → require an inline comment naming the invariant ("G3", "the no-double-write invariant", "the fail-open contract") or referencing the design section.
- Tests where the assertion is non-obvious without the contract → require a comment stating which contract is being pinned and the consequence of violation.
- Test names that already encode the invariant (e.g. `TestRecover_SkipsWriteWhenResponseAlreadyStarted`) → satisfy this rule only if the body also carries a one-line "why this matters" comment.

| | Example |
|---|---|
| ❌ | `func TestAccessLog_BodyTeeEmptyWhenHandlerDoesNotRead(t *testing.T) { ... }` with no inline comment explaining why this matters |
| ✅ | `// This is the G3 invariant: handlers that short-circuit before\n// reading body (semaphore reject, guard reject, validation fail)\n// produce a log line with no body.` |
| ❌ | A test that verifies "status remains 200, body not modified after panic" with no comment on why this is load-bearing |
| ✅ | `// Pathological but possible: handler wrote a partial response,\n// then panicked. Recover must not slap a 500 JSON on top of it —\n// the status was already set, so the wire is already committed.` |
| ❌ | `TestAccessLog_RemoteIPAndClientIP` with two indistinguishable IP fields and no comment on which is which |
| ✅ | `// remote_ip is the literal connecting peer (host portion of\n// RemoteAddr). client_ip is the ClientIP-middleware-resolved value\n// (the real end-user IP after walking the trusted-proxy chain).` |

---

## Application Notes

- This file is loaded by every quality phase that touches code. Go-specific quality (`quality-go.md`) cross-references it after its own Go-specific checks.
- When the touched file uses a different language than the examples here (Ruby, Node, Python, Lua), translate the syntactic shape (godoc → YARD/JSDoc/docstring/LDoc) but keep the same principle and check. A bad-comment-in-Ruby is the same bad comment as a bad-comment-in-Go.
- This workflow is about comment **density and intent**, not formatting (line length, capitalization, period style). Formatting belongs in the project's lint configuration, not in the executable quality contract.
