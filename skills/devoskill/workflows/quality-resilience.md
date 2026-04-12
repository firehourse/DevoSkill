# Quality Category: Resilience

Use this category set for failure recovery and long-running process correctness.

## Includes
- Fault Tolerance
- Graceful Shutdown

## Fault Tolerance
- Principle: every long-lived connection or subscription must recover from startup failure and mid-run disconnect.
- Check for:
  - one-shot startup connections with no reconnect loop
  - side-channel subscribers that quietly die on disconnect
  - publisher patterns that reconnect only on process restart

## Graceful Shutdown
- Principle: long-running processes must observe termination signals and propagate them to in-flight work.
- Check for:
  - root loops with no SIGTERM awareness
  - workers started at boot that never receive a cancellation signal
  - background consumers that rely on force-kill instead of orderly exit
