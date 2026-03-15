# DevoSkill

DevoSkill is a standardized, prompt-based Orchestration Engine designed to impose strict engineering discipline on AI Code Agents (like Cursor, Codex, Gemini, or Claude). 

It prevents AI "hallucinations" and "context explosion" by shifting the agent's behavior from *role-playing* to an **Action-Based Execution Protocol**. It forces the AI to plan before coding, strictly adhere to approved architecture, keep file sizes under 600 lines, and isolate documentation from source code.

## Core Philosophy (The Hard Rules)
1. **No Code Without Docs:** The agent will refuse to write code without a pre-approved `task.md`.
2. **File Size Limits:** No single file (code or markdown) shall exceed 600 lines. The agent will proactively split files to enforce modularity.
3. **Python Ecosystem:** If the project uses Python, the agent is mandated to use `uv` for all dependency and environment management.
4. **Document Persistence (SkillDocs):** The agent will not generate useless conversational summaries. The project state is maintained entirely via writing to `architecture.md` and `task.md` centralized in a `skilldocs` directory, isolating it from your source code repository.

## How It Works

DevoSkill acts as a lightweight router. Instead of loading a massive prompt into your context window—which causes context pollution—you only load `skills/devoskill/SKILL.md`. 

When the agent detects what phase of development you are in, it dynamically reads the exact workflow required for that moment:
- **For Planning (`skills/devoskill/workflows/01-planning.md`):** It generates an "As-Is vs To-Be" diagram and creates an `architecture.md`.
- **For Development (`skills/devoskill/workflows/02-development.md`):** It blindly implements the approved `task.md` sequentially.
- **For Performance Debugging (`skills/devoskill/workflows/04-performance-debugging.md`):** It utilizes flame graphs, establishes baselines, and refactors logic based on quantitative metrics.

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
        │   ├── subagent-orchestration.md     # Rules for the AI to delegate tasks
        │   └── workspace-setup.md            # Rules for creating symlinks and skilldocs
        ├── workflows/
        │   ├── 01-planning.md                # Architecture and task generation
        │   ├── 02-development.md             # Strict code execution
        │   ├── 03-review.md                  # Validation checks
        │   └── 04-performance-debugging.md   # Profiling, baselining, and flame graphs
        └── templates/                        # Best-practice outlines for md generation
```

## Contributing
Contributions and customizations to the templates or workflows are welcome through Pull Requests. 
