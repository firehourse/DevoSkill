# Engineering Standards

Apply during development and review. These standards govern code structure — distinct from runtime-correctness checks in `05-quality.md`. Fix violations before declaring any phase complete.

Language-specific engineering rules live in the matching quality file (Go → `quality-go.md`, Node.js → see the section below).

## 1. Layer Separation

Every project enforces a strict layer hierarchy: **Router → Controller → Service → Repository**. Each layer calls only the layer directly below it. Utilities in `util/` are stateless helpers callable from any layer.

| | Example |
|---|---|
| ❌ | Controller calls `db.query(...)` directly |
| ✅ | Controller → `taskService.createTask()` → `taskRepo.insert()` |
| ❌ | Service imports HTTP framework or references `req`/`res` |
| ✅ | Service accepts plain domain types; controller translates HTTP ↔ domain |
| ❌ | Business logic in a router callback |
| ✅ | Router wires path + method to a controller only |

## 2. Naming Clarity

Names express action and subject without requiring the reader to inspect the body. `data`, `result`, `info`, `handle`, `process` are banned as standalone exported names. Abbreviations only for universally-known terms (`ctx`, `id`, `err`, `i`).

| | Example |
|---|---|
| ❌ | `func Process(data interface{})` / `handleMsg(m)` |
| ✅ | `func ValidateUploadRequest(req UploadRequest)` / `enqueueTranscriptionJob(msg)` |

## 3. Error Context

Errors from multi-step functions carry the name of the step that failed. Callers distinguish error categories via typed checks, never string matching on `.message`.

| | Example |
|---|---|
| ❌ | `return err` inside a function calling five sub-operations |
| ✅ | `return fmt.Errorf("createSession: persist token: %w", err)` |
| ❌ | `if (err.message === 'task not found')` in HTTP dispatch |
| ✅ | Service throws `class TaskError { statusCode; code }`, controller checks `err instanceof TaskError` |

## 4. Structured Logging

All log output goes through the project's structured logger. `fmt.Println` and `console.log` are banned in production paths. Every log line during a request or job includes the trace/request/job ID as a named field. Log levels match severity: DEBUG for diagnostic loops, INFO for state transitions, WARN for recoverable anomalies, ERROR for failures.

| | Example |
|---|---|
| ❌ | `fmt.Println("got message", id)` / `console.log("task failed")` |
| ✅ | `log.Info("message received", "id", id, "queue", q)` |
| ❌ | `log.Error("task failed")` with no task ID or cause |
| ✅ | `log.Error("task failed", "task_id", taskID, "error", err)` |

## 5. No Magic Values

Ports, timeouts, buffer sizes, retry counts, and domain identifier strings must be named constants or sourced from config. A bare literal in business logic is invisible to operators and breaks silently when the value changes.

| | Example |
|---|---|
| ❌ | `case "stt":` / `Type: "summary"` inline |
| ✅ | `case MsgTypeSTT:` / `Type: MsgTypeSummary` — constants at package level |
| ❌ | SQL embeds `'processing'`, `'pending'` as raw strings |
| ✅ | SQL parameters use `string(types.TaskStatusProcessing)` — one source of truth |

## 6. API Response Shape

All endpoints return the same envelope. Error responses never include stack traces, file paths, or raw DB errors. The HTTP status code alone distinguishes caller errors (4xx) from server errors (5xx).

| | Example |
|---|---|
| ❌ | Routes return `{ data }`, `{ result }`, or bare arrays inconsistently |
| ✅ | All routes: `{ data, error: null }` on success; `{ data: null, error: { code, message } }` on failure |
| ❌ | `res.json({ error: err.stack })` |
| ✅ | `res.json({ error: { code: "INTERNAL_ERROR", message: "An unexpected error occurred" } })` |

## 7. File Discipline

File size rules exist for context recovery and responsibility clarity, not aesthetics. Apply them with language and file-role awareness. If a file exceeds the normal threshold, either split it or record an explicit exception in `design.md` or `task.md` explaining why the larger file is still the strongest boundary.

Default thresholds:
- DevoSkill markdown artifacts: handled separately by the 600-line documentation rule; do not mix this with source-file checks
- Application source files in most web/service codebases (`ts`, `tsx`, `js`, `jsx`, `go`, `py`, `java`, `rb`, `rs`): target under 400 lines, soft ceiling 600
- Systems-heavy or table-heavy source files (`c`, `cc`, `cpp`, `h`, `hpp`) and similar low-level files with dense declarations or parser/state-machine tables: target under 600 lines, soft ceiling 1000
- Generated files: excluded, but they must be clearly generated and must not be treated as hand-written design examples

Hard rule:
- A source file crossing the soft ceiling without an explicit documented exception is a review failure.

| | Example |
|---|---|
| ❌ | `handlers.go` at 800 lines mixing auth, upload, and job logic |
| ✅ | `handlers/auth.go`, `handlers/upload.go`, `handlers/jobs.go` each under 400 lines |
| ✅ | `parser_tables.cpp` at 820 lines with an explicit documented exception because the table boundary is clearer than artificial splitting |

## 8. Go Consumer-Defined Contracts

When Go packages use interfaces for dependency inversion, the interface belongs to the consumer package and should be separated from concrete implementation files. Putting interfaces and implementations in the same file blurs the contract boundary and makes the code read like a local convenience hack instead of an explicit dependency seam.

| | Example |
|---|---|
| ❌ | `task.go` contains both `type taskRepository interface` and `type TaskService struct` with all implementation methods |
| ✅ | `task_contract.go` contains `type taskRepository interface`; `task.go` contains `type TaskService struct` and methods |
| ❌ | Handler package imports a repository concrete type directly because the interface is buried in the implementation file |
| ✅ | Handler depends on a handler-local or service-local contract type that is easy to inspect in isolation |

---

## Node.js / TypeScript Conventions

### Type and Constant Organization

All TypeScript interfaces, types, and enums live in `types/`. No interface or type alias is declared inline inside a service, controller, or repository. String constants that would be `const` in PHP are TypeScript enums in `types/` or `config/`.

| | Example |
|---|---|
| ❌ | `interface User { ... }` inside `user.service.ts` |
| ✅ | `interface User { ... }` in `types/user.interface.ts`, imported everywhere |
| ❌ | `if (role === 'admin')` — hardcoded string in business logic |
| ✅ | `if (role === Role.Admin)` where `enum Role` lives in `types/role.enum.ts` |

### File Naming

Every file is named after its primary export and suffixed with its layer role.

| Layer | Suffix |
|---|---|
| Service | `.service.ts` |
| Controller | `.controller.ts` |
| Repository | `.repository.ts` |
| Router | `.router.ts` |
| Interface / type | `.interface.ts` |
| Enum | `.enum.ts` |

### Project Structure

```
src/
  router/        # *.router.ts  — route wiring only
  controllers/   # *.controller.ts — HTTP ↔ domain translation
  services/      # *.service.ts — business logic
  repositories/  # *.repository.ts — data access
  types/         # *.interface.ts / *.enum.ts
  config/        # env loading and validation
  util/          # stateless helpers
```
