# Feature Streams Protocol

Primary question: when one ticket or feature spans multiple repositories or sequential work streams (for example a product fix plus separate integration testing in a private harness repo), what folder shape represents it without cloning documents?

Use this protocol when Planning detects that a single feature's work splits across more than one repository, runtime, or sequential ownership phase. Do not use it for ordinary single-repo features.

## Shape

One ticket gets exactly one root feature folder. Work streams live in subfolders:

```
docs/<project>/<ticket-slug>/
├── architecture.md        ← the ONLY architecture authority for the whole ticket
├── task.md                ← stream router: lists streams, their repos, status, and the active stream
├── implementation/        ← stream: product repo work
│   ├── design.md
│   ├── task.md
│   ├── test.md
│   └── verification.md
└── integration-testing/   ← stream: integration harness repo work
    ├── task.md
    ├── test.md            ← stream-local HOW only; the coverage contract stays at root or in the owning stream
    └── verification.md
```

Stream names are kebab-case and describe the work stream (`implementation`, `integration-testing`, `deploy`), not the phase number.

## Authority Rules

**Principle:** the root owns the feature's truth; streams own only their own execution. A stream document may point to root documents, never restate them.

Required check:
- Root `architecture.md` is the only place that states As-Is/To-Be and Behavior Delta for the ticket. Stream folders must not contain `architecture.md`.
- Root `task.md` lists every stream with repo, goal, status, and which stream is active. It carries no stream-internal task detail.
- Each stream's `task.md`/`test.md`/`verification.md` cover only that stream's repo and work. Cross-stream context is a one-line pointer (`see ../implementation/verification.md § X`), not a copy.
- A stream `test.md` states only how that stream proves its own work. The what-must-be-proven contract lives with the stream that owns the change, and other streams reference it.

| | Example | Why |
|---|---|---|
| ❌ | Creating `ticket-123-fix-integration-testing/` as a sibling feature folder with its own `architecture.md` | Two folders independently claim planning authority for one ticket; `test.md` content duplicated 75–100% in audited pairs, and reviewers cannot tell which folder is truth. |
| ✅ | `ticket-123-fix/integration-testing/` subfolder holding only `task.md`, `test.md`, `verification.md`, each pointing to `../architecture.md` | One authority surface; the stream stays loadable on its own without cloning the contract. |

## Loopholes Closed

- Do not create sibling `<ticket>-integration-testing/` (or `<ticket>-phase-2/`, `<ticket>-qa/`) folders for new work. No exceptions for "it's a different repo" — different repo is exactly what a stream subfolder represents.
- Do not promote a stream subfolder to a full feature folder because it grew. If a stream outgrows the ticket, return to Planning and split the ticket itself.
- Existing sibling twin folders are not exempt: migrate them to this shape under `{DEVOSKILL_ROOT}/skills/devoskill/protocols/legacy-migration.md` — as their own scoped migration tasks (pointers updated, no information loss), never bundled into feature work. At minimum, migrate a twin pair before reopening it for active work.

## Relationship To Phasing

In-place phases inside one stream's `task.md` (Phase 1/2/3 of the same repo's work) remain governed by `{DEVOSKILL_ROOT}/skills/devoskill/protocols/thinking-phasing.md`. Streams are for parallel or sequential work with different repos or ownership, not for ordinary staged rollout.
