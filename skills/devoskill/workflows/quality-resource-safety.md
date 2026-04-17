# Quality Category: Resource Safety

Read this file immediately before applying resource safety checks. Apply each section, fix failures, then proceed to the next category.

## Includes
- Resource Lifecycle
- Configuration Application
- Input Validation

## Resource Lifecycle
- Principle: resources with a finite lifetime must be bound to the narrowest context that spans their useful life.
- Check for:
  - subscriptions opened on immortal contexts inside request handlers
  - cleanup paths that reuse a cancelled operation context
  - browser connections with no teardown hook

## Configuration Application
- Principle: a configurable value is not real until it reaches the line that governs behavior.
- Check for:
  - parsed config values that are never applied
  - byte limits, concurrency limits, or retry knobs that are declared but bypassed by literals

## Input Validation
- Principle: validators at system boundaries must match the documented format exactly.
- Check for:
  - approximate UUID or identifier regexes
  - uploads without both type and size enforcement
  - forwarded identity values with no format validation
