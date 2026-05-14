# Change Review Packet Protocol

Use this protocol when Planning or Review needs a compact statement of change intent before or after implementation.

## Load Conditions
- Planning is writing a feature that adds, changes, or removes observable behavior.
- Planning is changing DevoSkill agent workflow behavior.
- Review needs to compare implementation against behavior intent, not only code diff.
- Closeout needs to record whether effective docs were synchronized after implementation.

Do not load this protocol for:
- direct file lookup,
- unchanged internal cleanup,
- default Development execution,
- default Quality checks,
- broad template or CLI productization work.

## Authority
- Feature-level `architecture.md` owns the primary `Behavior Delta` skeleton.
- `task.md` owns active execution checklist and trace links.
- `test.md` owns proof mapping for behavior-delta entries.
- `verification.md` owns executed evidence and closeout proof.
- Project-root `project-changelog.md` owns rationale and timeline.
- Project-root `study/` owns reusable comparison or system understanding.

Existing document protocols may reference this protocol. They must not copy these semantics inline.

## Required Behavior
### Planning
- Add or update `Behavior Delta` in feature-level `architecture.md` when load conditions match.
- Keep `Behavior Delta` as a skeleton with these fields:
  - `Added`
  - `Changed`
  - `Removed`
  - `Non-Goals`
  - `Review Evidence`
- Put execution rules in workflows or protocols, not inside the template skeleton.
- Link task, test, and verification entries back to behavior-delta entries when those entries drive implementation.
- If there is no behavior change, state that behavior delta is not required in the active planning surface.

### Review
- Check that implemented behavior matches `Added` and `Changed`.
- Check that `Removed` behavior is actually removed or explicitly deferred.
- Check that `Non-Goals` were not implemented.
- Check that `Review Evidence` points to `verification.md` or another declared evidence surface.
- Flag behavior drift that exists only in chat.

### Closeout
- `sync` means updating effective docs after implementation reality is known.
- `archive` means marking the feature folder completed and keeping completed feature context out of default load.
- Record sync/archive evidence in `verification.md`.
- Record project-level rationale in `project-changelog.md` only when the decision matters beyond the feature.

## Forbidden
- Do not introduce a mandatory `proposal.md` artifact.
- Do not replace DevoSkill primary routes with an OpenSpec-style lifecycle.
- Do not expand router default context for packet semantics.
- Do not perform broad template/runtime splitting under this protocol.
- Do not label generated artifacts by audience. Shape each artifact for its job.
- Do not store executed evidence in `architecture.md`, `design.md`, or `test.md`.

## Examples
### Good
```md
## Behavior Delta
### Added
- Planning records `Behavior Delta` for user-visible workflow changes.

### Changed
- Review compares implementation against behavior intent before closeout.

### Removed
- None.

### Non-Goals
- No CLI command layer.

### Review Evidence
- `verification.md` behavior-delta results.
```

### Bad
```md
## Behavior Delta
This section explains why OpenSpec separates proposal and spec files. It
describes who reads each document and why the process exists.
```

Violation: the bad example explains rationale inside the skeleton instead of recording behavior intent.
