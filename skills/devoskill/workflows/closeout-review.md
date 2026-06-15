# Closeout Review Workflow

Primary question: is the documented state synchronized with the code, and is this change ready to hand off or ship?

This is an independently usable support module. Development invokes it at phase completion (after the quality gate, before declaring ready); Review may invoke it as the final, decoupled pass. It can also be run standalone when someone asks "is this ready to close out / deploy?". It owns the doc-sync, evidence, completion, and hygiene floor — plus one decoupled re-verification of the conformance concerns that most need fresh eyes (scope bleed, architecture drift), because Development's own conformance checkpoint is a self-check and a self-check cannot independently catch its own blind spots.

It does NOT review code quality (that is Review / `03-review.md`) and it does NOT gate operational actions like push/PR/deploy-trigger (that is `protocols/operational-gates.md`). Closeout asserts the change is *internally consistent and shippable*; operational-gates asserts the *action* is *approved*.

## When To Load

- Development reached phase completion and is about to declare it ready for review or handoff.
- Review wants a final decoupled pass over doc-sync and evidence after the code-quality hunt.
- A standalone request: "is this phase ready to close out / ship / hand off?".

Do not load it for code-quality review, mid-implementation work, or simple file lookup.

## Checks

Each check is a finding when its condition holds. Tag findings MUST / SHOULD / MAY per `03-review.md` Step 4 severity rules and order MUST → SHOULD → MAY.

### C1 — Task Writeback

**Principle:** `task.md` must reflect what actually happened in code — completed work marked complete, blockers and handoff states current.

Required check:
- Code changed but `task.md` still reads like the work has not started, or completed items are unmarked → finding.
- Active phase summary contradicts the delivered state → finding.

| | Example | Why |
|---|---|---|
| ❌ | Feature shipped, `task.md` active item still `[ ]` | stale planning surface; next session mis-reads state |
| ✅ | Each delivered item `[x]` with a trace link to the change | planning surface matches reality |

### C2 — Architecture Writeback

**Principle:** if the code changed the effective architecture (boundaries, key flows, target shape), `architecture.md` must be updated to match.

Required check:
- Code diverged from `architecture.md` and the doc was not updated → finding (MUST: drift, not style).
- If the change was an intended architecture shift with no doc update → flag for writeback before sign-off.

### C3 — Evidence Surface

**Principle:** every claimed verification result must be backed by `verification.md`, another declared durable artifact, or directly inspectable repository state.

Required check:
- `task.md`/`verification.md` claims success but the trace, file tree, or artifact is missing → finding.
- Claimed test runs with no recorded command/output → finding.

| | Example | Why |
|---|---|---|
| ❌ | "all tests pass" with no artifact, log, or inspectable run | unverifiable claim; closeout cannot trust it |
| ✅ | `verification.md` records the command, the run, and the negative-path result | claim is traceable |

### C4 — Task Completion

**Principle:** each active `task.md` item must be functionally implemented, not just marked done.

Required check:
- An item marked complete whose behavior cannot be traced to repository state → finding.

### C5 — Planning Surface Size

**Principle:** effective DevoSkill markdown (`architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, project-root `project-changelog.md`, loaded `study/*.md`, loaded `notes/*.md`) must not exceed 600 lines per file.

Required check:
- Run `{DEVOSKILL_ROOT}/tools/devoskill-lint.sh` when available (it also covers registry thresholds, PR artifact naming, stream shape); otherwise count.
- Any planning file over 600 lines → finding. Do not apply to implementation source files.

### C6 — Change Rationale

**Principle:** if implementation changed an existing behavior, boundary, or surprising structure, recorded rationale should exist before the change reads as unexplained drift.

Required check:
- Behavior/boundary changed and project-root `project-changelog.md` (when present) has no rationale entry → finding (SHOULD).

### C7 — Artifact Hygiene

**Principle:** tracked source paths must not contain runtime-generated artifacts, dependency directories, build output, uploads, or other pollution unless the contract explicitly permits them.

Required check:
- Build outputs / `node_modules` / traces / uploads committed into the tracked tree → finding.

| | Example | Why |
|---|---|---|
| ❌ | `.artifacts/` or `node_modules/` committed without a contract allowance | repo pollution; balloons diffs and clones |
| ✅ | Generated artifacts gitignored or confined to a contract-declared location | tree stays source-only |

### C8 — Decoupled Conformance Re-verification (fresh-eyes subset)

**Principle:** Development's Plan Conformance Checkpoint (`02-development.md`) is a self-check. Two conformance concerns are too costly to leave un-reverified by an independent pass: **scope bleed** (unauthorized paradigms/dependencies/boundary crossings) and **architecture drift** (resulting code no longer matches the effective `architecture.md`). Closeout re-runs only these two, with eyes that did not write the code.

Required check:
- Re-inspect the final diff for scope bleed against the `task.md` surgical boundary, applying `protocols/surgical-change-boundary.md`. A hunk that cannot trace to the request, an active task item, the contracts, or allowed cleanup → finding (MUST).
- Re-confirm the effective `architecture.md` still describes the resulting code. Divergence the self-check missed → finding (MUST).
- This is the only conformance work Closeout does. The full conformance set (style, phase integrity, design/test/behavior contract, change packet) stays in Development's checkpoint; do not re-run all of it here — re-run only what genuinely needs a decoupled second pass.

## Output

Produce an itemized, severity-tagged list (MUST / SHOULD / MAY), same format as `03-review.md` Step 4. Do not rewrite code or docs in place — report and hand off. If a writeback is missing, name the file and the missing content in one line.

## Red Flags — If You Think This, Stop

- "The code is great, so closeout passes" — closeout is about doc-sync and shippability, not code quality. A perfect diff with a stale `task.md` still fails closeout.
- "I'll re-run the whole 18-check conformance list here" — no. Conformance is Development's self-check; Closeout re-verifies only scope bleed and architecture drift (C8).
- "Closeout approval means it's safe to push" — no. Closeout says *consistent and shippable*; the actual push/PR/deploy still needs `operational-gates.md` same-turn approval.
- "task.md says done, that's enough" — done-marked ≠ functionally done; trace it to repository state (C4).
