# Design: [Feature Name]

Generated during Planning. Development follows this document — do not deviate without updating it first.

## Source Inputs

- Architecture:
- Study:
- Changelog:
- Code read surface:
- User-provided inputs:
- Local operator notes, if any:

## Relevant Structure

```
cmd/
  server/
    main.go               # wiring only: init deps, start server, handle SIGTERM

internal/
  config/
    config.go             # env loading, typed Config struct

  handler/                # HTTP layer — parses request, calls service, writes response
    task.go

  service/                # business logic — owns the repository interface
    task_contract.go      # consumer-defined interfaces only
    task.go               # TaskService concrete implementation only
    task_test.go

  repository/             # data access — implements service's interface
    task.go               # Repository struct

  domain/                 # shared types, status constants, errors
    task.go

  util/
    logger.go             # slog wrapper
```

## Boundary Diagram

```mermaid
classDiagram
  class TaskHandler {
    -service taskService
    +CreateTask(w, r)
    +GetTask(w, r)
  }

  class taskService {
    <<interface>>
    +CreateTask(ctx, userID) (Task, error)
    +GetTask(ctx, taskID, userID) (Task, error)
  }

  class TaskServiceContract {
    <<interface>>
    +CreateTask(ctx, userID) (Task, error)
    +GetTask(ctx, taskID, userID) (Task, error)
  }

  class TaskService {
    -repo taskRepository
    +CreateTask(ctx, userID) (Task, error)
    +GetTask(ctx, taskID, userID) (Task, error)
  }

  class taskRepository {
    <<interface>>
    +Insert(ctx, task Task) (Task, error)
    +FindByID(ctx, taskID, userID) (Task, error)
  }

  class Repository {
    -pool pgxpool.Pool
    +Insert(ctx, task Task) (Task, error)
    +FindByID(ctx, taskID, userID) (Task, error)
  }

  TaskHandler --> taskService
  TaskService ..|> taskService
  TaskService --> taskRepository
  Repository ..|> taskRepository
```

## Class Responsibilities

> Class diagrams express structure only. This section explains each struct or interface's **responsibility boundary** and **design rationale** so future developers do not have to reverse-engineer intent from code.

One subsection per type in the diagram. Use this pattern:

### `TypeName`
- What it **owns** (one-sentence boundary definition)
- What it **does not own** (explicit exclusions to prevent scope creep)
- If this type is modified in this feature: why it changed and what changed

Example (Go style):

### `TaskHandler`
- HTTP entry point. Parses request, calls service, writes response.
- Owns no business logic and never touches the DB directly.
- All errors flow through a single `handleError` helper — no domain-error type switches inside handlers.

### `taskService` (interface, defined in handler package)
- Consumer-defined contract describing what the handler needs from the service layer.
- Not bound to any concrete implementation — allows test injection without a real service.

### `TaskService` (concrete)
- Holds a `taskRepository` interface and implements all business logic.
- Never accesses the DB directly — all data operations go through the repository interface.

---

## Flow Mapping

This section is mandatory. The class diagram is not enough by itself.

Document each meaningful request/job/stream as a numbered handoff chain:

1. Entry point (`main.go`, HTTP handler, worker loop, stream listener)
2. Handler / consumer
3. Service orchestration
4. Repository / external dependency boundary
5. Persistence point
6. Ownership / authorization check
7. Side effects emitted
8. Terminal response, stored state, or published event

If the feature spans multiple binaries or runtimes, split this into subsections per boundary (for example `API`, `Worker`, `Gateway`) instead of collapsing everything into one generic path.

---

## Naming Rules (enforce before writing any file)

- Package names: single lowercase word — `handler`, `service`, `repository`, `domain`
- File names: `snake_case.go` — `task.go`, `cancel_tracker.go`
- No `.service.go` / `.repository.go` / `.enum.go` suffixes — those are Node.js conventions, not Go
- Interfaces: unexported, defined in the **consumer** package — `taskService` in `handler/`, `taskRepository` in `service/`
- Interface declarations live in dedicated `*_contract.go` files when the package also contains concrete implementations. Do not mix interface definitions and concrete structs in the same file unless the package is trivial and explicitly approved in `design.md`.
- Interface names: describe the role from the consumer's perspective — `taskRepository`, not `ITaskRepository`
- Concrete struct names: simple noun — `TaskService`, `Repository`
- Constructors: `NewTaskService(repo taskRepository) *TaskService`
- No bare struct literals for types with deps — always use constructor
- `slog` for all logging — `log.Printf` / `fmt.Println` are banned
- `signal.NotifyContext` for root context — never `context.Background()` in handlers or workers

## Behavior Contract

- Resource boundaries: list every user-scoped identifier and where ownership must be checked
- Endpoint / stream matrix: each HTTP or SSE path lists caller identity, authorization check, side effects, and negative paths
- Job matrix: each queue or background flow lists producer, consumer, persistence point, and cancel behavior
- State transitions: list allowed transitions and forbidden transitions explicitly

## Test Derivation Hooks

- Unit-test seams implied by type responsibilities
- Integration-test seams implied by flow mapping
- Acceptance / BDD seams implied by behavior contract, state transitions, and ownership rules
- Expected durable test artifact path: `<feature-folder>/test.md`

## Verification Artifacts

- Runtime checks that must be persisted or be directly reproducible from repository state
- Negative-path checks that must be evidenced
- Artifact hygiene rules for binaries, build output, uploads, generated files, and traces
- Expected durable artifact path: `<feature-folder>/verification.md`

## Approved Exceptions

- `[Exception]`:
  - Why it is allowed:
  - Scope:
  - Compensating test or verification:

## Multi-Binary Note

If this feature spans more than one executable boundary (for example API server + worker + gateway), one class diagram is usually not enough.

Required approach:
- one topology/system diagram for cross-binary boundaries
- one class diagram per binary or per independently deployable boundary
- flow mapping that explicitly names the handoff between binaries
