# Cursor IDE Installation & Usage

Cursor automatically applies `.cursor/rules/*.mdc` files to every Cursor Chat session in the workspace. DevoSkill ships a single rule file that forces the AI to consult `skills/devoskill/SKILL.md` before any code generation.

## Install

1. Clone DevoSkill into a stable local path, for example:
   ```bash
   git clone git@github.com:firehourse/DevoSkill.git ~/workspace/DevoSkill
   ```

2. Copy the DevoSkill rule into your target project:
   ```bash
   mkdir -p .cursor/rules
   cp ~/workspace/DevoSkill/.cursor/rules/devoskill.mdc .cursor/rules/
   ```

That is the entire bootstrap. The next time Cursor Chat opens in the project, DevoSkill is active.

## Why no extra reinforcement is needed

Unlike Claude Code, Cursor's native rule mechanism re-loads the `.mdc` file at every chat invocation. DevoSkill rules therefore stay near the prompt entry and never drift into the model's weak-attention zone (doctrine § 2). No `CLAUDE.md`-style hardening or `UserPromptSubmit`-style hook is required.

## First-run workspace mapping

On the first planning session in a workspace, DevoSkill will:

1. derive the workspace's `skilldocs` location dynamically,
2. write the resolved mapping into `skills/devoskill/config/workspace-map.local.json`,
3. keep that mapping file untracked via `.gitignore`,
4. create or refresh the workspace-local `.devoskill` symlink as needed.

You do not need to pre-populate `workspace-map.local.json`; it is local machine state and is created lazily when the workflow first needs it.

## Clean-machine reinstall simulation

To simulate a fresh install on the same machine, remove the workspace `.cursor/rules/devoskill.mdc`, the `.devoskill` symlink, and the local `workspace-map.local.json`, then repeat the install steps.
