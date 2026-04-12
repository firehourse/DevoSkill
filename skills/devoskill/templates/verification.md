# [Feature Name] Verification Evidence

This file stores durable verification evidence for the active feature or run. `task.md` summarizes status; this file holds the proof.

## 1. Verification Scope
- Feature / run:
- Verification date:
- Verified against:
  - `architecture.md` sections:
  - `task.md` phase:
  - `design.md` version:
  - `test.md` version:

## 2. Planned Check Matrix
- Test suites / scenarios from `test.md`:
- Runtime checks:
- Ownership / authorization checks:
- Negative-path checks:
- File-tree reconciliation checks:
- Artifact hygiene checks:

## 3. Commands Executed
| Command | Purpose | Result |
|---|---|---|
| `[command]` | `[what it proves]` | `[pass | fail | partial]` |

## 4. Runtime Results
- [Check]:
  - Expected:
  - Observed:
  - Evidence:

## 5. Ownership / Authorization Results
- [Boundary]:
  - Expected:
  - Observed:
  - Evidence:

## 6. Negative-Path Results
- [Scenario]:
  - Expected failure mode:
  - Observed:
  - Evidence:

## 7. Test Execution Results
- [Suite / scenario]:
  - Planned source in `test.md`:
  - Expected:
  - Observed:
  - Evidence:

## 8. File-Tree Reconciliation
- Declared implementation tree source:
- Actual tree inspected:
- Unexpected artifacts found:
- Cleanup performed:
- Remaining approved exceptions:

## 9. Remaining Gaps and Risks
- [Gap or residual risk]
- [Gap or residual risk]

## 10. Reviewer Starting Points
- Key files to inspect:
- Key test suites / scenarios to spot-check:
- Key evidence entries to spot-check:
- Known limitations of this verification pass:
