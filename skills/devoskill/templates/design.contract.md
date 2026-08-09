# Design Template Contract

Use this file as the small, mandatory contract for every `design.md`.
Stack-specific templates provide detail and examples, but they do not replace this contract.

## Audience Contract
- `design.md` must be readable by the human owner without opening skill files or replaying chat.
- `design.md` is part of the reviewer-facing portable planning surface. Use repo-relative paths, stable symbols, route names, command names, and document-relative references.
- Do not put machine-local absolute paths, local-only credentials, personal shell aliases, editor paths, or host-specific paths in reviewer-facing sections.
- If local convenience is useful for the human owner, put it in feature-level `notes/local.md` or another explicitly local note, then reference it as non-authoritative local context.

## Required Anchors
Every `design.md` must contain these anchors unless an explicit phase-approved exception states why the anchor is not applicable:

- `Source Inputs`
- `Relevant Structure`
- `Boundary Diagram` or `Boundary Map`
- `Responsibilities`
- `Flow Mapping`
- `Behavior Contract`
- `Decision Completeness`
- `Test Derivation Hooks`
- `Verification Artifacts`
- `Approved Exceptions`

## Cross-Stack / Multi-Binary Rule
If a feature spans multiple stacks, runtimes, binaries, apps, or independently deployable boundaries, the design must make each boundary inspectable instead of collapsing everything into one prose map.

Required shape:
- one topology or system diagram showing cross-boundary traffic and ownership
- one Mermaid `classDiagram` per Go, Node.js/TypeScript, Python, or other method-signature-driven runtime boundary, showing the concrete public or architecturally significant classes, structs, interfaces, protocols, functions, and signatures that shape the contract; omit incidental private helpers
- one responsibility subsection per diagram node or Rails boundary
- flow mapping steps that trace to the concrete method, function, class, interface, protocol, struct, or Rails boundary that owns each step

Rails Conservative Maintenance may use a prose `Boundary Map` for the Rails segment when a class diagram would be fake precision. That exception is local to Rails. It does not replace Mermaid `classDiagram` sections required for Go, Node.js/TypeScript, Python, or other non-Rails runtime boundaries in the same feature.

If a required runtime diagram is omitted, `Approved Exceptions` must name the runtime boundary, explain why the diagram would be misleading, and provide compensating flow and responsibility detail.

## Source Inputs
This section records where the design came from. Keep it short and typed.

- Architecture:
- Study:
- Changelog:
- Code read surface:
- User-provided inputs:
- Local operator notes, if any:

Reviewer-facing source inputs must be portable. Local operator notes are convenience references only and do not approve implementation behavior.

## Completion Rules
- A future developer can answer which component or boundary owns the next implementation step from `Responsibilities` and `Flow Mapping` without being forced into incidental private code shape.
- A future reviewer can compare code against explicit boundaries without inferring intent from chat.
- For multi-stack or multi-binary features, a future developer can identify the owning method/function or Rails boundary for each meaningful flow step.
- The active phase selects consequential behavior, boundaries, dependencies, risk controls, and evidence. Consequential alternatives are rejected, deferred, or out of scope.
- `design.md` may leave equivalent private implementation choices to Development when they preserve the selected contract.
- `Test Derivation Hooks` are specific enough to create or validate `test.md`.
- `Verification Artifacts` are specific enough to create or validate `verification.md`.
- Every local-only reference is isolated to local notes and excluded from reviewer-facing proof.

## Split Rules
- Keep the contract small. Put examples, stack-specific naming rules, and detailed diagrams in stack-specific or section-specific template modules.
- If a generated `design.md` becomes too large, split background into `study/`, rationale into `project-changelog.md`, local convenience into `notes/local.md`, and phase-local abandoned context into `notes/`.
