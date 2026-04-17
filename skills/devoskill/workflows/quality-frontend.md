# Quality Category: Frontend

Read this file immediately before applying frontend checks. Apply each section, fix failures, then proceed to the next category.

## Includes
- Frontend Async Hygiene

## Frontend Async Hygiene
- Principle: async UI flows must handle success, failure, and teardown explicitly.
- Check for:
  - loading flags cleared only on success
  - missing `catch`/`finally` around UI-driving async work
  - `EventSource` or similar long-lived connections with no unmount cleanup
