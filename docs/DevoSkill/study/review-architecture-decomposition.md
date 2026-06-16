# Study: Review Architecture Decomposition (Review / Conformance / Closeout)

Reusable design rationale for why the review surface is split into three independently usable modules, and how the old single compliance-floor was distributed. Captured when a review that anchored on the compliance floor (engineering/maintenance standards) missed a real correctness bug — the floor is not the review posture, it is a separate concern.

## Problem

The original review workflow framed review as "assert compliance against the plan". In practice this degenerated into diff-matching: the reviewer walked the plan/standards checklist and missed defects the plan never anticipated. Treating the compliance floor as the *posture* (rather than a secondary bar) is the failure mode.

A second smell: the same engineering standards were referenced in *both* the code-quality pass and the compliance floor, blurring ownership.

## Three bounded contexts (DDD-style, independently usable)

Each module answers exactly one primary question and can run alone.

| Module | Primary question | Home |
|---|---|---|
| **① Code Review** | Is this code correct and good on its own merits? | `workflows/03-review.md` (Review route) |
| **② Plan Conformance** | Did the implementation honor the approved plan/contracts? | `workflows/02-development.md` Step 6 (Development self-check, mid + at-completion) |
| **③ Closeout** | Is the documented state synchronized and ready to hand off/ship? | `workflows/closeout-review.md` (support module; invoked by Development Step 8, optionally Review R8; runnable standalone) |

Key ranking (doctrine §11): the independent **defect hunt is primary**; conformance and closeout are floors/gates, never the posture.

## Why not just delete the floor?

"Not the first principle" ≠ "redundant". The floor catches concerns the defect hunt structurally cannot — they are orthogonal, not duplicated:

- scope bleed / unauthorized boundary crossings,
- code↔doc drift (task.md/architecture.md stale),
- claimed-but-unbacked verification evidence,
- planning-surface size, changelog rationale, artifact hygiene.

Deleting the floor would blind review to drift/scope/hygiene — a coverage regression (weakens doctrine §10 document-authority / reviewability / evidence-quality). The fix for "the floor mis-framed the review" is to *re-rank and re-home* it, not remove it.

## The 18-check distribution

The old `03-review.md` Step 3 (18 compliance checks) was distributed:

- **Stay in Review (① code-quality)**: over-abstraction (old 8), engineering-standards full sweep + §11 alternatives-enumeration (old 14). These ARE the code standards; they live inside the Step-2 defect hunt, applied to find violations — not quoted as a posture.
- **Move to Development (② conformance self-check)**: scope bleed (1), surgical diff (2), style conformance (9), architecture alignment (10), phase integrity (11), design/test/behavior contract completeness (12/13/15), change-packet match (16).
- **Move to Closeout (③)**: planning-surface size (3), change rationale (4), task writeback (5), architecture writeback (6), task completion (7), evidence surface (17), artifact hygiene (18).

## Decoupled re-verification (the (ii) decision)

Moving conformance to a Development *self-check* loses the decoupled second pass that `engineering-standards.md §11` prizes ("Development self-checks; Review re-runs independently"). A self-check cannot catch its own blind spots.

Resolution: Development owns the full conformance self-check, but Closeout (an independent, fresh-eyes pass at handoff) **re-verifies only the two concerns most costly to leave un-reverified**: scope bleed and architecture drift (`closeout-review.md` C8). The rest of conformance (style, phase, contracts) stays a self-check only — those are self-evident enough not to need a second pass.

## Boundaries vs adjacent modules (no overlap)

- **Closeout vs `operational-gates.md`**: Closeout asserts the change is *internally consistent and shippable*; operational-gates asserts the *action* (push/PR/deploy-trigger) is *approved* same-turn. Closeout approval does NOT authorize a push.
- **Closeout vs Review**: Review hunts code defects; Closeout checks doc-sync/evidence/hygiene + the scope/arch re-verify. Doc-sync findings surfaced during Review are pointed at Closeout, not absorbed.
- **`change-review-packet.md`**: Closeout builds on its existing "Closeout" load condition (doc-sync record) rather than re-owning it.

## Enforcement that keeps the posture honest

- Review route R1 is a **hard gate**: read `03-review.md` and state the change's intent in two sentences before reading any standards file or emitting a verdict. The standards are applied *inside* the hunt (Step 2 check 4), never cited as "our review style" beforehand.
- Router Review description and Red Flags state plainly that plan-matching is not Review's job.

## Files changed by the restructure

`workflows/closeout-review.md` (new), `workflows/03-review.md`, `workflows/02-development.md`, `skills/devoskill-development/SKILL.md`, `skills/devoskill-review/SKILL.md`, `protocols/document-loading-order.md`, `protocols/implementation-readiness-gate.md`, `skills/devoskill/SKILL.md`, `README.md`.
