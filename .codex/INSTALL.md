# Codex Installation & Usage

Codex does not consume Cursor `.mdc` rules. To make DevoSkill auto-start in Codex, bootstrap it with an `AGENTS.md` file that points at the local DevoSkill clone.

## Recommended: workspace bootstrap

1. Clone DevoSkill somewhere stable, for example:
   ```bash
   git clone git@github.com:firehourse/DevoSkill.git ~/workspace/DevoSkill
   ```
2. Copy the bootstrap template into the workspace root where Codex will run:
   ```bash
   cp ~/workspace/DevoSkill/.codex/AGENTS.bootstrap.md /path/to/your/workspace/AGENTS.md
   ```
3. Replace `{{DEVOSKILL_ROOT}}` in `AGENTS.md` with the absolute path to the local clone.

Once present, Codex will read that `AGENTS.md` on startup for that workspace and load DevoSkill before handling requests.

## First-run behavior on a clean machine

On the first planning session in a workspace, DevoSkill will:
1. derive the workspace's `skilldocs` location dynamically,
2. write the resolved mapping into `skills/devoskill/config/workspace-map.local.json`,
3. keep that mapping file untracked via `.gitignore`,
4. create or refresh the workspace-local `.devoskill` symlink as needed.

You do not need to pre-populate `workspace-map.local.json`; it is local machine state and should be created lazily when the workflow first needs it.

## Optional: skill registration

If you also want DevoSkill to appear in Codex skill discovery, register it as a local skill:

```bash
mkdir -p ~/.agents/skills
ln -s ~/workspace/DevoSkill/skills/devoskill ~/.agents/skills/devoskill
```

This registration helps discovery, but the `AGENTS.md` bootstrap is what makes DevoSkill mandatory at startup.

## Clean reinstall checklist

To simulate a fresh-machine install in an existing workspace, remove only the local bootstrap/state artifacts and then repeat the bootstrap steps above:

```bash
rm -f /path/to/your/workspace/AGENTS.md
rm -f /path/to/your/workspace/.devoskill
rm -f /absolute/path/to/DevoSkill/skills/devoskill/config/workspace-map.local.json
rm -f ~/.agents/skills/devoskill
```

This preserves the DevoSkill repo itself while forcing bootstrap, local mapping, and skill registration to be recreated from scratch.

## Manual fallback

If you cannot write `AGENTS.md`, start the session with this instruction:

```text
Load and follow the DevoSkill entrypoint at /absolute/path/to/DevoSkill/skills/devoskill/SKILL.md before doing anything else.
```
