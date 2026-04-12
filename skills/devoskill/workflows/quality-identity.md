# Quality Category: Identity

Use this category set for identity and ownership correctness.

## Includes
- Identity and Security
- Authorization Surface

## Identity and Security
- Principle: generated identifiers, tokens, and nonces must come from a cryptographically secure source.
- Check for:
  - time-based or sequential identifiers
  - `Math.random()` or equivalent weak randomness for security-sensitive values

## Authorization Surface
- Principle: every user-scoped read, stream, replay, cancel, and mutation path must enforce ownership explicitly.
- Check for:
  - SSE or replay endpoints that skip ownership checks
  - CRUD paths that enforce ownership while streaming/cancel paths do not
  - assumptions that identity establishment alone implies authorization
