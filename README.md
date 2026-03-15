# DevoSkill

DevoSkill is a standardized, prompt-based Orchestration Engine designed to impose strict engineering discipline on AI Code Agents (like Cursor, Codex, Gemini, or Claude). 

It prevents AI "hallucinations" and "context explosion" by shifting the agent's behavior from *role-playing* to an **Action-Based Execution Protocol**. It forces the AI to plan before coding, strictly adhere to approved architecture, keep file sizes under 600 lines, and isolate documentation from source code.

## Core Philosophy (The Hard Rules)
1. **No Code Without Docs:** The agent will refuse to write code without a pre-approved `task.md`.
2. **File Size Limits:** No single file (code or markdown) shall exceed 600 lines. The agent will proactively split files to enforce modularity.
3. **Python Ecosystem:** If the project uses Python, the agent is mandated to use `uv` for all dependency and environment management.
4. **Document Persistence (SkillDocs):** The agent will not generate useless conversational summaries. The project state is maintained entirely via writing to `architecture.md` and `task.md` centralized in a `skilldocs` directory, isolating it from your source code repository.
5. **Effective Planning Surface:** `architecture.md` stores only the current effective architecture, and `task.md` stores only the active executable phase. History is not part of the default context.

## How It Works

DevoSkill acts as a lightweight router. Instead of loading a massive prompt into your context window—which causes context pollution—you only load `skills/devoskill/SKILL.md`. 

When the agent detects what phase of development you are in, it dynamically reads the exact workflow required for that moment:
- **For Planning (`skills/devoskill/workflows/01-planning.md`):** It enters a Thinking Phase, classifies the work as Greenfield, Existing System, or Hybrid, then writes an effective `architecture.md` and an active-phase `task.md`.
- **For Development (`skills/devoskill/workflows/02-development.md`):** It executes only the active phase, using the minimum effective planning context required.
- **For Review (`skills/devoskill/workflows/03-review.md`):** It verifies that code matches the effective architecture, active phase tasks, and declared boundaries.
- **For Performance Debugging (`skills/devoskill/workflows/04-performance-debugging.md`):** It establishes quantitative baselines and writes only effective benchmark and optimization changes back into the planning files.

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

### 3. CLI Agents (Codex / OpenCode / Gemini)
You can directly instruct the agent to fetch the execution protocol from GitHub using the provided `.codex/INSTALL.md` method:
```text
Fetch and follow the action-based execution protocol defined in https://raw.githubusercontent.com/firehourse/DevoSkill/main/skills/devoskill/SKILL.md
```

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
        │   └── workspace-registry.md         # Tracks where documentation is saved per-project
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
```

## Contributing
Contributions and customizations to the templates or workflows are welcome through Pull Requests. 
