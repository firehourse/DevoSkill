# Quality Category: Identity

Read this file immediately before applying identity checks. Apply each section, fix failures, then proceed to the next category.

## Includes
- Identity and Security
- Authorization Surface

## Identity and Security
- Principle: generated identifiers, tokens, and nonces must come from a cryptographically secure source.
- Check for:
  - time-based or sequential identifiers
  - `Math.random()` or equivalent weak randomness for security-sensitive values

## Authorization Surface
- Principle: every user-scoped read, stream, replay, cancel, and mutation path must enforce ownership explicitly. Identity establishment alone does not imply authorization.
- Check for:
  - SSE or replay endpoints that skip ownership checks present on the corresponding CRUD paths
  - assumptions that a valid token means the caller owns the resource
- For HTTP and streaming endpoint enforcement patterns and examples → see `quality-node.md` Section 6.
