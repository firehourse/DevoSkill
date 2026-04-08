# Design: [Feature Name]

Generated during Planning. Development follows this document — do not deviate without updating it first.

## Folder Structure

```
src/
  controllers/
    [domain].controller.ts
  services/
    [domain].service.ts
  repositories/
    [domain].repository.ts
  types/
    [domain].interface.ts     # interfaces and types
    [domain].enum.ts          # enums (split out if large)
  util/
    [helper].ts               # stateless helpers, no layer affiliation
  config/
    env.ts
  router/
    [domain].router.ts
  index.ts
```

## Class Diagram

```mermaid
classDiagram
  class TaskRouter {
    +register(app: Express): void
  }

  class TaskController {
    -service: TaskService
    +createTask(req, res): Promise~void~
    +getTask(req, res): Promise~void~
    -readUserId(req): string
    -handleError(err, res): void
  }

  class TaskService {
    <<interface>>
    +createTask(userId: string): Promise~TaskRecord~
    +getTask(taskId: string, userId: string): Promise~TaskRecord~
  }

  class TaskServiceImpl {
    -repository: TaskRepository
    +createTask(userId: string): Promise~TaskRecord~
    +getTask(taskId: string, userId: string): Promise~TaskRecord~
  }

  class TaskRepository {
    <<interface>>
    +insert(record: NewTask): Promise~TaskRecord~
    +findById(taskId: string, userId: string): Promise~TaskRecord | null~
  }

  class PgTaskRepository {
    -pool: Pool
    +insert(record: NewTask): Promise~TaskRecord~
    +findById(taskId: string, userId: string): Promise~TaskRecord | null~
  }

  TaskRouter --> TaskController
  TaskController --> TaskService
  TaskServiceImpl ..|> TaskService
  TaskServiceImpl --> TaskRepository
  PgTaskRepository ..|> TaskRepository
```

## Naming Rules (enforce before writing any file)

- Files: `[domain].[role].ts` — `task.service.ts`, `task.controller.ts`, `task.repository.ts`
- Types/interfaces: `[domain].interface.ts` — no `I` prefix on interface names
- Enums: `[domain].enum.ts`
- Interface name = the role: `TaskService`, `TaskRepository`
- Concrete name = implementation detail: `TaskServiceImpl`, `PgTaskRepository`
- No inline `interface` declarations inside service/controller/repository files
- All enums in `types/` — no bare string literals in business logic

## Behavior Contract

- Resource boundaries: list every user-scoped identifier and where ownership must be checked
- Endpoint matrix: each route lists request owner, allowed states, side effects, and error cases
- Job / event matrix: each queue or stream event lists producer, consumer, persistence, and replay surface
- State transitions: list allowed transitions and forbidden transitions explicitly

## Verification Artifacts

- Runtime checks that must be persisted or be directly reproducible from repository state
- Negative-path checks that must be evidenced
- Artifact hygiene rules for `dist/`, `node_modules/`, uploads, generated files, and traces
