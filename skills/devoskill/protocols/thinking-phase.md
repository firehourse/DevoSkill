# Thinking Phase Protocol

Before writing `architecture.md` or `task.md`, the planner MUST complete this Thinking Phase. The purpose is not to produce more text. The purpose is to reduce wrong assumptions and keep the effective planning surface small.

## Step 1: Classify the Request
Determine whether the work is:
- **Greenfield**
- **Existing System**
- **Hybrid**

Do not continue until one mode is chosen.

## Step 2: Build the Minimum Reality Model
Gather only the information required to reason about the request safely.

- For **Greenfield**:
  - user goal,
  - success criteria,
  - expected system shape,
  - key constraints,
  - explicit non-goals.
- For **Existing System**:
  - current architecture,
  - current data/control flow,
  - movable vs immovable boundaries,
  - style or abstraction rules that must be preserved,
  - current pain or delta requested by the user.
- For **Hybrid**:
  - existing system boundaries,
  - insertion points for the new capability,
  - which parts are new design vs inherited design,
  - migration risks and compatibility rules.

## Step 3: Confirm Boundaries With the User
The planner MUST identify missing constraints and ask for them instead of guessing.

Examples:
- current schema or contract,
- externally owned API behavior,
- production constraints,
- immovable module boundaries,
- whether patterns must be preserved or can be changed.

If a database, queue, external API, or member/account state is involved, prefer requesting human-provided schema or contract details over inventing them.

## Step 4: Define the Delta
State the requested change in one bounded form:
- what will change,
- what will remain unchanged,
- what is out of scope.

If you cannot express the delta clearly, you are not ready to write the architecture.

## Step 5: Decide Whether to Split by Phase
You MUST split the plan into phases if any of the following is true:
- the change touches multiple major components,
- the system needs staged migration,
- user review is needed between parts,
- one phase creates prerequisites for another,
- the architecture would otherwise become too broad to reload cleanly.

Each phase must be independently understandable.

## Step 6: Promote Only Effective Output
Only promote finalized content into:
- `architecture.md`
- `task.md`

Do NOT promote:
- discarded alternatives,
- raw discussion logs,
- emotional reasoning,
- every intermediate thought,
- obsolete plans from earlier iterations.

If history matters, store it separately under `<SKILLDOCS_DIR>/notes/` so future sessions do not load it by default.
