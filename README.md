# DevoSkill

DevoSkill is a standardized, prompt-based Orchestration Engine designed to impose strict engineering discipline on AI Code Agents (like Cursor, Codex, Gemini, or Claude). 

It prevents AI "hallucinations" and "context explosion" by shifting the agent's behavior from *role-playing* to an **Action-Based Execution Protocol**. It forces the AI to plan before coding, strictly adhere to approved architecture, keep effective planning markdown small, and isolate documentation from source code.

DevoSkill is also organized as a function-like document system: each skill, protocol, and workflow file should answer one primary question and stay small enough to be loaded selectively instead of as a monolithic prompt blob.

## Core Philosophy (The Hard Rules)
1. **No Code Without Docs:** The agent will refuse to write code without a pre-approved `task.md`.
2. **Planning Document Limits:** DevoSkill markdown artifacts such as `architecture.md`, `task.md`, `design.md`, `test.md`, `verification.md`, and `notes/*.md` should stay under 600 lines each so future sessions can reload them cleanly. This limit does not apply to implementation source files.
3. **Python Ecosystem:** If the project uses Python, the agent is mandated to use `uv` for all dependency and environment management.
4. **Document Persistence (SkillDocs):** The agent will not generate useless conversational summaries. Durable project state is maintained through the SkillDocs document system (`architecture.md`, `design.md`, `test.md`, `task.md`, `verification.md`) centralized in a `skilldocs` directory, isolating it from your source code repository.
5. **Effective Planning Surface:** `architecture.md` stores only the current effective architecture, `design.md` stores the implementation contract, `test.md` stores the testing contract, and `task.md` stores only the active executable phase. History is not part of the default context.

## How It Works

DevoSkill acts as a lightweight router. Instead of loading a massive prompt into your context window, you load `skills/devoskill/SKILL.md`, which then routes into smaller sibling skills.

The router should not depend on the user naming a skill explicitly. Its job is to read a natural project/task description such as "I have this project, I need to add auth, help me plan it" and infer the smallest correct mode from that description.

When the agent detects what phase of development you are in, it first loads the matching sibling skill, then reads only the exact workflow required for that moment:
- **Planning (`skills/devoskill-planning/SKILL.md`)**
- **Development (`skills/devoskill-development/SKILL.md`)**
- **Review (`skills/devoskill-review/SKILL.md`)**
- **Performance Debugging (`skills/devoskill-performance/SKILL.md`)**
- **Exception / Inquiry (`skills/devoskill-exception/SKILL.md`)** — lightweight route for file lookup, question answering, latest-info research, and issue clarification before work becomes a project phase
- **Quality Gate (`skills/devoskill-quality/SKILL.md`)** — invoked as a pre-completion support module at the end of every development phase; contains language-neutral principles and positive/negative examples across resource lifecycle, configuration application, input validation, fault tolerance, operational hygiene, identity, and frontend async patterns; automatically loads language-specific sub-skills for each language present in the implementation
  - **Go Quality (`skills/devoskill-quality-go/SKILL.md`)** — Go-specific checks: signal handling, context propagation, goroutine lifecycle, concurrency patterns, deferred cleanup
  - **Node.js Quality (`skills/devoskill-quality-node/SKILL.md`)** — Node.js/TypeScript-specific checks: async error boundaries, HTTP status codes, RabbitMQ connection management, top-level await sequencing, ioredis patterns
- **Workspace Setup (`skills/devoskill-workspace-setup/SKILL.md`)**
- **Thinking Phase (`skills/devoskill-thinking-phase/SKILL.md`)**

This keeps the top-level skill small while making each execution mode independently discoverable and reusable.

## Function-Like File System

DevoSkill treats prompt files like callable units:
- `SKILL.md` files decide **when to use** a mode or support skill
- thin protocol/workflow routers decide **which focused files to load next**
- focused protocol/workflow files answer **one primary question each**

This keeps routing and selective loading explicit:
- the router should stay thin
- phase skills should orchestrate, not restate every rule
- shared semantics should live in reusable protocol files instead of being copied into multiple phases

### Routing Rule

DevoSkill should classify requests from three signals in the user's description:
- **Project state:** new project, existing codebase, approved work, broken behavior, or uncertain direction
- **Immediate intent:** plan, implement, review, or debug
- **Exception intent:** inquire, lookup, research, clarify
- **Expected output:** docs, code, discrepancy report, or benchmark/debug findings

This keeps classification aligned with how users actually ask for help, while still loading only the smallest relevant context.

## Productization Improvements

This repository is evolving beyond a hidden workflow framework into a more triggerable skill set.

- **Clearer trigger language:** entry skills should say exactly when they apply, even from short prompts.
- **Planning as interrogation:** planning should pressure-test the user request before docs are written, instead of treating questioning as a separate router mode.

`skills/devoskill-grill/SKILL.md` remains useful, but as a support module for planning rather than a top-level route.

## Lightweight Testing

DevoSkill should validate trigger behavior without becoming a heavyweight test framework.

- Keep trigger tests focused on short, natural prompts.
- Run one routing test at a time instead of maintaining a large always-loaded matrix.
- Treat long specs and full workflows as planning/development tests, not trigger tests.

See [tests/README.md](tests/README.md) and `tests/skill-triggering/` for the minimal harness.

## Planning Philosophy

DevoSkill is optimized for collaboration with LLMs under context pressure, not for storing every discussion artifact.

- **Thinking Phase First:** Before planning, the agent must build the minimum reality model required to reason safely.
- **Mode-Aware Planning:** New systems, existing systems, and hybrid changes use different planning logic.
- **Phase-Based Execution:** Large changes are split into architecture parts and task phases so later sessions can reload them cleanly.
- **Human Boundary Respect:** If DB schema, production contracts, credentials, or sensitive runtime state are missing, the agent asks the user instead of guessing.
- **Minimal Default Context:** Future sessions should be able to read only the effective architecture and current task phase, not a pile of planning history.

## Development Doctrine

DevoSkill is intentionally built for humans and agents operating under prompt-weight constraints, not for generic prose documentation.

- **Prompt-weight-aware routing:** Router content carries only high-level classification and load decisions because models over-weight the beginning and end of what they read. Detailed execution constraints belong in the routed skill, where they become fresh high-weight context again.
- **Fine-grained prompt modules:** Skills, protocols, workflows, and templates should stay small and single-purpose. Agents tend to consume whole files, not selectively parse dense middle sections, so each file should answer one primary question cleanly.
- **Document-driven synchronization:** Durable planning artifacts are the mechanism for keeping later sessions aligned with prior intent. If a decision is not written back to the correct document, it should be treated as non-durable.
- **Shared contracts over duplication:** Avoid repeating the same rule across multiple skills when one protocol or workflow can own it. Repeated prompt logic behaves like duplicated code: it drifts and becomes contradictory.
- **DDD-like document boundaries:** Each artifact owns a bounded semantic role. `architecture.md` owns architecture, `design.md` owns implementation design, `test.md` owns the testing contract, `task.md` owns active execution, and `verification.md` owns evidence.

See [docs/DevoSkill/doctrine.md](docs/DevoSkill/doctrine.md) for the full long-lived development doctrine that future maintainers and agents should read before reshaping DevoSkill itself.

## Testing Contract

DevoSkill now treats testing as a first-class planning artifact rather than an afterthought hidden inside verification notes.

- `design.md` defines how the system should be built.
- `test.md` derives executable test strategy from `design.md` and records the approved methodology: `TDD`, `BDD`, or `Follow Existing Project Pattern`.
- `verification.md` stores executed evidence, command outputs, pass/fail results, and reconciliation notes. It does not own test design.

Recommended defaults:

- Greenfield work defaults to `TDD` unless the feature is primarily journey-driven or cross-runtime, in which case `BDD` may be explicitly selected.
- Existing systems default to `Follow Existing Project Pattern` unless the planning docs explicitly authorize a change in testing style.
- `design.md` class responsibilities should map to unit tests, flow mappings should map to integration tests, and behavior contracts should map to acceptance or BDD scenarios.

## Installation & Usage

DevoSkill provides native, plug-and-play integrations for the most popular AI agents to ensure global constraints are applied automatically.

### 1. Cursor IDE (Native Rule Integration)
To have Cursor automatically follow DevoSkill on any project:
1. Clone the repository into your workspace: `git clone git@github.com:firehourse/DevoSkill.git ~/workspace/DevoSkill`
2. **Auto-Load:** Copy or symlink the specific agent rule into your target project:
   ```bash
   mkdir -p .cursor/rules
   cp ~/workspace/DevoSkill/.cursor/rules/devoskill.mdc .cursor/rules/
   ```
Whenever Cursor Chat opens, the `.mdc` file forces the AI to consult `skills/devoskill/SKILL.md` before generating code.

### 2. Claude Code Integration

Claude Code reads `CLAUDE.md` at startup to load project-level instructions. DevoSkill hooks into this mechanism so it is active in every session automatically.

**Step 1 — Bootstrap via CLAUDE.md**

Create or append to `CLAUDE.md` in your workspace root:

```markdown
# Workspace Claude Bootstrap

This workspace uses DevoSkill as mandatory startup context.

Before responding to any user request, load and follow:
`/path/to/DevoSkill/skills/devoskill/SKILL.md`

Execution rules:
- Read `SKILL.md` before planning, asking clarifying questions, editing files, or reviewing code.
- Route the task through the workflow selected by `SKILL.md`.
- Follow DevoSkill workspace registry and `skilldocs` rules whenever planning or document persistence is required.
- User instructions still take precedence when they explicitly override a DevoSkill preference.

If the DevoSkill path is missing, stop and tell the user to restore the local clone or relink the skill.
```

Replace `/path/to/DevoSkill` with the absolute path to your local clone (e.g. `/home/user/workspace/DevoSkill`).

**Step 2 — Register the `/Devoskill` slash command**

Create `.claude/commands/Devoskill.md` inside your workspace:

```bash
mkdir -p .claude/commands
```

```markdown
Load and execute the DevoSkill framework.

Read `/path/to/DevoSkill/skills/devoskill/SKILL.md` and follow its router workflow
for the current task: perform the bootstrap check, classify the work mode
(Planning / Development / Review / Debug), load the matching sibling skill,
and proceed accordingly.

If an argument is provided (e.g. `/Devoskill plan` or `/Devoskill dev`),
use it as a hint for mode classification. Otherwise infer from context.

$ARGUMENTS
```

After restarting Claude Code, `/Devoskill` will appear as a registered slash command in the current workspace.

To register it globally (available in all workspaces), place the same file at `~/.claude/commands/Devoskill.md`.

### 3. Codex (Bootstrap via AGENTS.md)
Codex does not use Cursor rule files. To make DevoSkill load automatically in Codex, install the provided bootstrap `AGENTS.md` into the workspace root that Codex runs from.

1. Clone DevoSkill into a stable local path, for example `~/workspace/DevoSkill`
2. Copy the bootstrap template:
   ```bash
   cp ~/workspace/DevoSkill/.codex/AGENTS.bootstrap.md /path/to/your/workspace/AGENTS.md
   ```
3. Replace `{{DEVOSKILL_ROOT}}` with your local clone path

When Codex starts inside that workspace, the bootstrap file instructs it to load `skills/devoskill/SKILL.md` before doing any work.

On first use in a workspace, DevoSkill will derive the `skilldocs` location dynamically and persist that machine-local mapping in `skills/devoskill/config/workspace-map.local.json`. That file is local state, should stay gitignored, and can be deleted when you want to simulate a fresh install on the same machine.

If you also want DevoSkill discoverable as a registered local skill, create:
```bash
mkdir -p ~/.agents/skills
ln -s ~/workspace/DevoSkill/skills/devoskill ~/.agents/skills/devoskill
```

See `.codex/INSTALL.md` for the complete Codex bootstrap instructions.

To simulate a clean-machine reinstall later, remove the workspace `AGENTS.md`, `.devoskill` symlink, optional `~/.agents/skills/devoskill` registration, and the local `workspace-map.local.json`, then repeat the bootstrap steps.

## Directory Structure
```text
DevoSkill/
├── .cursor/rules/devoskill.mdc       # Native IDE Rule Integration
├── .claude.json                      # Claude Configuration Block
├── .codex/INSTALL.md                 # CLI Install script
├── README.md                         # This file
└── skills/
    └── devoskill/
        ├── SKILL.md                          # The lightweight entry point & router
        ├── config/
        │   ├── workspace-map.example.json    # Example schema for local workspace mapping state
        │   └── workspace-registry.md         # Legacy reference; local mapping state is preferred
        ├── protocols/
        │   ├── document-system.md            # Thin router for shared document semantics
        │   ├── document-authority.md         # Which document is allowed to claim what
        │   ├── document-loading-order.md     # Default read surface per phase
        │   ├── document-persistence.md       # Where durable state should be written
        │   ├── document-reviewability.md     # What makes the planning surface reusable
        │   ├── thinking-phase.md             # Thin router for planning pre-write reasoning
        │   ├── thinking-classification.md    # Greenfield / Existing / Hybrid decision
        │   ├── thinking-reality-model.md     # Minimum safe current-reality model
        │   ├── thinking-boundaries.md        # Constraints that must be confirmed
        │   ├── thinking-delta.md             # Requested change boundary
        │   ├── thinking-phasing.md           # When to split into phases
        │   ├── thinking-promotion.md         # What becomes durable planning state
        │   ├── planning-greenfield.md        # Planning rules for net-new systems
        │   ├── planning-existing.md          # Planning rules for changes to existing systems
        │   ├── planning-hybrid.md            # Planning rules for new capability inside old systems
        │   ├── subagent-orchestration.md     # Rules for the AI to delegate tasks
        │   ├── workspace-setup.md            # Thin router for workspace setup semantics
        │   ├── workspace-mapping.md          # Resolve SkillDocs base path
        │   ├── workspace-layout.md           # Project/feature folder layout
        │   ├── workspace-symlink.md          # `.devoskill` symlink rules
        │   ├── workspace-project-resolution.md # Resolve the active SkillDocs project
        │   └── workspace-repair.md           # Drift and repair rules for mapping/symlink state
        ├── workflows/
        │   ├── 01-planning.md                # Thin router for planning steps
        │   ├── planning-context-bootstrap.md # Planning bootstrap and scope init
        │   ├── planning-artifacts.md         # Architecture/task/design/test/verification rules
        │   ├── planning-design-contract.md   # Binding design + test traceability rules
        │   ├── planning-approval.md          # Approval gate and clean handoff
        │   ├── 02-development.md             # Active-phase execution rules
        │   ├── 03-review.md                  # Effective-architecture compliance checks
        │   ├── 04-performance-debugging.md   # Profiling, baselining, and benchmark-driven refactoring
        │   ├── 05-quality.md                 # Thin router for quality categories
        │   ├── quality-resource-safety.md    # Resource/config/input categories
        │   ├── quality-resilience.md         # Fault tolerance and shutdown categories
        │   ├── quality-hygiene.md            # Operational/evidence hygiene categories
        │   ├── quality-identity.md           # Identity and authorization categories
        │   ├── quality-frontend.md           # Frontend async category
        │   ├── quality-go.md                 # Go-specific quality checks
        │   └── quality-node.md               # Node.js/TypeScript-specific quality checks
        └── templates/                        # Effective architecture, test, evidence, and active task templates
    ├── devoskill-planning/
    │   └── SKILL.md                          # Planning skill entry point
    ├── devoskill-development/
    │   └── SKILL.md                          # Development skill entry point
    ├── devoskill-review/
    │   └── SKILL.md                          # Review skill entry point
    ├── devoskill-performance/
    │   └── SKILL.md                          # Performance skill entry point
    ├── devoskill-exception/
    │   └── SKILL.md                          # Lightweight inquiry / research route
    ├── devoskill-quality/
    │   └── SKILL.md                          # Pre-completion technical quality gate skill (language-neutral)
    ├── devoskill-quality-go/
    │   └── SKILL.md                          # Go-specific quality rules
    ├── devoskill-quality-node/
    │   └── SKILL.md                          # Node.js/TypeScript-specific quality rules
    ├── devoskill-grill/
    │   └── SKILL.md                          # Planning support module for user grilling
    ├── devoskill-workspace-setup/
    │   └── SKILL.md                          # SkillDocs and symlink setup skill
    └── devoskill-thinking-phase/
        └── SKILL.md                          # Request classification and boundary-confirmation skill
```

## Contributing
Contributions and customizations to the templates or workflows are welcome through Pull Requests. 
