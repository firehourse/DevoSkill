# Quality Category: Hygiene

Read this file immediately before applying hygiene checks. Apply each section, fix failures, then proceed to the next category.

## Includes
- Operational Hygiene
- Verification Evidence and Harness Hygiene

## Operational Hygiene
- Principle: ephemeral store entries must expire, and runtime-generated files must not pollute version control.
- Check for:
  - Redis keys with no TTL
  - `.gitignore` added only after artifacts were already tracked
  - upload/build/dependency artifacts left in tracked paths

## Verification Evidence and Harness Hygiene
- Principle: claimed verification must be inspectable from durable artifacts or repository state.
- Check for:
  - `task.md` claims with no `verification.md` support
  - review conclusions that depend on chat memory
  - accidental runtime artifacts being treated as harmless leftovers
