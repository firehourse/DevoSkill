# Design: [Feature Name]

Generated during Planning. Development follows this document — do not deviate without updating it first.

## Rails Maintenance Mode

- Mode: `[Conservative Rails Maintenance | Explicit Modernization]`
- Reason this mode applies to the touched area:
- Existing Rails boundaries to preserve:
- Any approved modernization boundary:

## Relevant Structure

Document only the affected Rails surface. Use the real folder names from the repo.

```text
app/
  api/
    private/
      users_api.rb
  controllers/
    users_controller.rb
  models/
    user.rb
  services/
    users/
      update_service.rb
  queries/
    users/
      lookup_query.rb
  jobs/
    sync_user_job.rb

spec/
  api/
  services/
  requests/
```

## Boundary Map

Do not force a class diagram if the touched Rails area is better explained as flow + responsibility. Use the format that best matches the code:

- controller/API endpoint boundary
- service object boundary
- model/validation boundary
- query/repository-like boundary if one exists
- job/integration boundary if one exists
- caller boundary if another app or frontend consumes the response

If a diagram helps, use one. If the code is legacy Rails and a diagram would be fake precision, omit it and make the boundaries explicit in prose instead.

## Responsibilities

One subsection per touched component.

### `[Component Name]`
- Owns:
- Does not own:
- Inputs it accepts:
- Outputs it returns:
- Why it changes in this feature:

## Flow Mapping

Document each meaningful flow as a numbered chain.

### Main Flow
1. Entry point (`controller`, `Grape API`, `job`, or callback)
2. Parameter normalization / request boundary
3. Domain operation (`service`, model method, or existing Rails boundary)
4. Validation / authorization / ownership checks
5. Persistence point
6. Side effects (`after_commit`, job enqueue, external API call, cache write)
7. Terminal response or stored state

### Negative Paths
For each negative path, state:
- trigger
- which layer handles it
- whether it is result-based or exception-based
- returned HTTP/status contract or caller-visible contract
- whether logging/reporting happens

## Error Taxonomy

This section is mandatory for Ruby/Rails work.

### Business / Domain Errors
- Expected validation or rule failures:
- How they are represented:
- Response/result shape returned to the caller:
- Why they do not go through exception reporting:

### System Errors
- Unexpected runtime, persistence, callback, integration, or infrastructure failures:
- Where they are rescued:
- What gets logged/reported:
- What caller-visible response is returned:

## Result / Exception Boundary

- Chosen pattern: `[Result object | Plain return value | Typed exception | Mixed with explicit boundary]`
- Expected failures handled without exceptions:
- Exception classes reserved for system failures:
- Where response/result normalization happens:
- Which layer is responsible for logging system failures:

## Caller Contract

List every caller-visible outcome that implementation must preserve or intentionally change.

| Path | Success Contract | Business Error Contract | System Error Contract | Notes |
|---|---|---|---|---|
| `PATCH /example` | `200 { message: "success" }` | `422 { message: [...] }` | `500 { error: { code, message } }` | note payload shape changes |

## Naming and File Rules

- Match the repo's existing Rails naming, string/hash style, comments, and local idioms.
- Keep controllers/API classes thin; do not move business logic into request handling.
- Service objects encapsulate one business operation and must not accept raw request params.
- Query extraction is optional; use it only if the repo already has that boundary or the plan explicitly approves it.
- Do not add new architectural layers in legacy Rails code unless modernization is explicitly approved here.
- Document any exception to the local Rails style before implementation begins.

## Behavior Contract

- Resource boundaries:
- Authorization / ownership rules:
- Validation rules that remain unchanged:
- State transitions allowed:
- State transitions forbidden:
- Side effects that must preserve ordering:

## Test Derivation Hooks

- Unit seams:
- Request/API seams:
- Integration seams:
- Negative paths that require explicit test coverage:
- Logging/reporting assertions that must be tested:
- Expected durable test artifact path: `<feature-folder>/test.md`

## Verification Artifacts

- Runtime checks that must be evidenced:
- Negative-path checks that must be evidenced:
- Caller-facing payload/status changes that must be reconciled:
- Artifact hygiene constraints:
- Expected durable artifact path: `<feature-folder>/verification.md`
