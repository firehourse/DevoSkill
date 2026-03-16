# DevoSkill

DevoSkill is a standardized, prompt-based Orchestration Engine designed to impose strict engineering discipline on AI Code Agents (like Cursor, Codex, Gemini, or Claude). 

It prevents AI "hallucinations" and "context explosion" by shifting the agent's behavior from *role-playing* to an **Action-Based Execution Protocol**. It forces the AI to plan before coding, strictly adhere to approved architecture, keep effective planning markdown small, and isolate documentation from source code.

## Core Philosophy (The Hard Rules)
1. **No Code Without Docs:** The agent will refuse to write code without a pre-approved `task.md`.
2. **Planning Document Limits:** Effective planning markdown such as `architecture.md`, `task.md`, and `notes/*.md` should stay under 600 lines each so future sessions can reload them cleanly.
3. **Python Ecosystem:** If the project uses Python, the agent is mandated to use `uv` for all dependency and environment management.
4. **Document Persistence (SkillDocs):** The agent will not generate useless conversational summaries. The project state is maintained entirely via writing to `architecture.md` and `task.md` centralized in a `skilldocs` directory, isolating it from your source code repository.
5. **Effective Planning Surface:** `architecture.md` stores only the current effective architecture, and `task.md` stores only the active executable phase. History is not part of the default context.

## How It Works

DevoSkill acts as a lightweight router. Instead of loading a massive prompt into your context window, you load `skills/devoskill/SKILL.md`, which then routes into smaller sibling skills.

When the agent detects what phase of development you are in, it first loads the matching sibling skill, then reads only the exact workflow required for that moment:
- **Planning (`skills/devoskill-planning/SKILL.md`)**
- **Development (`skills/devoskill-development/SKILL.md`)**
- **Review (`skills/devoskill-review/SKILL.md`)**
- **Performance Debugging (`skills/devoskill-performance/SKILL.md`)**
- **Workspace Setup (`skills/devoskill-workspace-setup/SKILL.md`)**
- **Thinking Phase (`skills/devoskill-thinking-phase/SKILL.md`)**

This keeps the top-level skill small while making each execution mode independently discoverable and reusable.

## Planning Philosophy

DevoSkill is optimized for collaboration with LLMs under context pressure, not for storing every discussion artifact.

- **Thinking Phase First:** Before planning, the agent must build the minimum reality model required to reason safely.
- **Mode-Aware Planning:** New systems, existing systems, and hybrid changes use different planning logic.
- **Phase-Based Execution:** Large changes are split into architecture parts and task phases so later sessions can reload them cleanly.
- **Human Boundary Respect:** If DB schema, production contracts, credentials, or sensitive runtime state are missing, the agent asks the user instead of guessing.
- **Minimal Default Context:** Future sessions should be able to read only the effective architecture and current task phase, not a pile of planning history.

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
For Claude Code environments, you can inject DevoSkill directly via the provided configuration:
- Copy the `.claude.json` configuration to your repository or merge it with your `.clauderc` to establish the `projectDependencies`. 

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
        │   ├── thinking-phase.md             # Converge on reality before writing planning docs
        │   ├── planning-greenfield.md        # Planning rules for net-new systems
        │   ├── planning-existing.md          # Planning rules for changes to existing systems
        │   ├── planning-hybrid.md            # Planning rules for new capability inside old systems
        │   ├── subagent-orchestration.md     # Rules for the AI to delegate tasks
        │   └── workspace-setup.md            # Rules for creating symlinks and skilldocs
        ├── workflows/
        │   ├── 01-planning.md                # Thinking phase + effective architecture/task generation
        │   ├── 02-development.md             # Active-phase execution rules
        │   ├── 03-review.md                  # Effective-architecture compliance checks
        │   └── 04-performance-debugging.md   # Profiling, baselining, and benchmark-driven refactoring
        └── templates/                        # Effective architecture and active task templates
    ├── devoskill-planning/
    │   └── SKILL.md                          # Planning skill entry point
    ├── devoskill-development/
    │   └── SKILL.md                          # Development skill entry point
    ├── devoskill-review/
    │   └── SKILL.md                          # Review skill entry point
    ├── devoskill-performance/
    │   └── SKILL.md                          # Performance skill entry point
    ├── devoskill-workspace-setup/
    │   └── SKILL.md                          # SkillDocs and symlink setup skill
    └── devoskill-thinking-phase/
        └── SKILL.md                          # Request classification and boundary-confirmation skill
```

## Contributing
Contributions and customizations to the templates or workflows are welcome through Pull Requests. 
