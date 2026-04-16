# DevoSkill Active Task Plan

## 1. Active Phase Summary
- Current Phase: `Phase 6`
- Goal: Add `Update` as a primary route and a shared `skill-evolution` protocol so user-stated rules are captured and written back into custom protocol files during the session — no external tools, no runtime hooks.
- Depends on architecture sections: `Approved Target Shape`, `Execution Shape`
- Implementation approval status: `Approved to implement`
- Explicit go-ahead required before code changes: `No`
- Execution status: `Completed`
- Last writeback timestamp / session note: `2026-04-16 added Update route, devoskill-update skill, skill-evolution protocol, conditional custom-*.md load in Development and Review`
- User inputs still required: `None`
- Current blocker: `None`
- Next user handoff: `Review skill files after implementation`
- Stop and ask the user if: `A category beyond quality/performance is needed before completing Phase 6`

## 2. Setup and Preconditions
- [x] Phase 5 (doctrine + test contract) completed
- [x] Architecture updated to include Phase 6 scope
- [x] Design direction confirmed in session

## 3. Execution Tasks

### 3.1 Router update
- Scope: Add `Update` route to the main router.
- Files: `skills/devoskill/SKILL.md`
- Constraints: Keep router thin. One line description only. No implementation rules in the router.

- [x] **Task 3.1.1**
  - Target: `skills/devoskill/SKILL.md` — Primary Modes section
  - Action: Add `Update -> ../devoskill-update/SKILL.md` with a one-line "Use when" description.
  - Expected output: Router now lists Update as a peer route alongside Planning/Development/Review/Debug/Exception.
  - Verification: Description is concise and matches the trigger intent (user-stated corrections/standards).

### 3.2 devoskill-update skill
- Scope: Create the thin Update phase skill.
- Files: `skills/devoskill-update/SKILL.md` (new)
- Constraints: Load only `skill-evolution.md` protocol. No duplication of capture logic here.

- [x] **Task 3.2.1**
  - Target: `skills/devoskill-update/SKILL.md` (create)
  - Action: Write the Update skill — defines when Update applies, loads `skill-evolution` protocol, specifies writeback stop condition.
  - Expected output: Agent routed to Update knows exactly what to do without re-reading chat.
  - Verification: Skill does not contain its own capture/format logic — delegates to `skill-evolution.md`.

### 3.3 Shared skill-evolution protocol
- Scope: Single shared protocol owning all capture and writeback semantics.
- Files: `skills/devoskill/protocols/skill-evolution.md` (new)
- Constraints: This is the only place capture rules and writeback format are defined.

- [x] **Task 3.3.1**
  - Target: `skills/devoskill/protocols/skill-evolution.md` (create)
  - Action: Define: (1) what qualifies as a capturable rule, (2) what does NOT qualify (noise filter), (3) classification table mapping rule types to target categories, (4) writeback format for custom-*.md files, (5) naming constraint — only `custom-{category}.md` may be created.
  - Expected output: Agent can determine the correct category without guessing. Classification is rule-based, not freeform judgment.
  - Verification: Classification table covers at minimum: code style → `custom-quality`, performance optimization → `custom-performance`, explicit cross-session standards → matched by content. Noise filter excludes one-off decisions and rules already present in existing skill files.

### 3.4 Custom protocol files (conditional)
- Scope: Custom protocol files are created on first capture, not in advance.
- Files: `skills/devoskill/protocols/custom-*.md` (created on demand)
- Constraints:
  - **Naming rule (non-negotiable):** The Update phase may ONLY create files whose name starts with `custom-`. No other file in `protocols/` may be created or modified by the Update phase. This prevents pollution of existing protocols.
  - Files must not be pre-created as empty stubs. Creation is triggered by the first captured rule of that category only.

- [x] **Task 3.4.1**
  - Target: `skills/devoskill/protocols/skill-evolution.md`
  - Action: Specify the file creation behavior — agent creates `custom-{category}.md` with a header on first write, then appends subsequent rules. Explicitly state the `custom-` prefix rule and list it as a hard constraint the agent must not bypass.
  - Expected output: First-run behavior is defined and deterministic. Agent cannot accidentally create or overwrite non-custom protocol files.
  - Verification: Naming constraint is stated as a hard rule, not a guideline.

### 3.5 Development and Review conditional load
- Scope: Development and Review skills load custom protocol files if they exist.
- Files: `skills/devoskill-development/SKILL.md`, `skills/devoskill-review/SKILL.md`
- Constraints: Load is conditional. If no custom-*.md exists, no change in behavior. Do not add noise to the default load surface.

- [x] **Task 3.5.1**
  - Target: `skills/devoskill-development/SKILL.md`, `skills/devoskill-review/SKILL.md`
  - Action: Add a conditional load step: "If `protocols/custom-*.md` files exist, read them before executing."
  - Expected output: Development and Review silently apply user-captured rules when they exist, without needing user to re-state them.
  - Verification: Default load path unchanged when no custom files exist.

### 3.6 Writeback
- Scope: Update project planning docs to reflect Phase 6 as complete.
- Files: `docs/DevoSkill/task.md`, `docs/DevoSkill/architecture.md`

- [x] **Task 3.6.1**
  - Target: `docs/DevoSkill/task.md`
  - Action: Mark Phase 6 as completed and note what was implemented.
  - Status / writeback note: `Completed`

## 4. Human Handoff Points
- [ ] Human reviews the skill files after implementation
- [ ] Human confirms the noise filter definition is precise enough in `skill-evolution.md`

## 5. Out of Scope for This Phase
- A `/evolve` batch command that processes accumulated logs into skill diffs
- Auto-apply without review
- Categories beyond quality and performance (can be added later by running Update on itself)

## 6. Completion Criteria for This Phase
- [x] `Update` appears in the router as a primary route
- [x] `devoskill-update/SKILL.md` exists and delegates to `skill-evolution` protocol
- [x] `skill-evolution.md` owns all capture/writeback semantics with an explicit noise filter
- [x] Development and Review conditionally load custom-*.md files via correct `../devoskill/protocols/custom-*.md` path
- [x] No custom-*.md stubs pre-created
- [x] Architecture and task docs written back
