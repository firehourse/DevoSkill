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

## Optional: skill registration

If you also want DevoSkill to appear in Codex skill discovery, register it as a local skill:

```bash
mkdir -p ~/.agents/skills
ln -s ~/workspace/DevoSkill/skills/devoskill ~/.agents/skills/devoskill
```

This registration helps discovery, but the `AGENTS.md` bootstrap is what makes DevoSkill mandatory at startup.

## Manual fallback

If you cannot write `AGENTS.md`, start the session with this instruction:

```text
Load and follow the DevoSkill entrypoint at /absolute/path/to/DevoSkill/skills/devoskill/SKILL.md before doing anything else.
```
