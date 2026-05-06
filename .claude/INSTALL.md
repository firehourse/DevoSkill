# Claude Code Installation & Usage

Claude Code reads `CLAUDE.md` at startup to load project-level instructions. DevoSkill hooks into this mechanism so it is active in every session automatically.

## Why Claude Code needs more enforcement than Cursor / Codex

Claude Code's long-conversation mode plus its session-level Auto Mode put extra pressure on DevoSkill discipline:

- **Prompt-attention drift (doctrine § 2):** rules read at session start drift toward the prompt's weak-attention zone as the conversation grows. Cursor reloads its `.mdc` rule at every chat invocation; Codex sessions tend to stay short and task-shaped. Claude Code's chat-style continuity doesn't get those natural re-anchors.
- **Auto Mode tension:** Claude Code's Auto Mode pushes "execute immediately, prefer action over planning" — which competes with DevoSkill's "router-first, reroute before action" discipline. Without explicit disambiguation, Auto Mode can win silently.
- **System reminder noise:** Claude Code injects periodic system reminders (Auto Mode active, plan mode active, etc.) that pull attention toward Claude-specific mechanics, further squeezing DevoSkill priority.

The bootstrap below is therefore stricter than the Cursor / Codex equivalents, and an optional `UserPromptSubmit` hook in Step 3 keeps DevoSkill rules anchored in the strong-attention zone of every prompt.

## Step 1 — Bootstrap via CLAUDE.md

Create or append to `CLAUDE.md` in your workspace root:

```markdown
# Workspace Claude Bootstrap

DevoSkill is the **only** workflow authority for this workspace. It overrides any default behavior baked into Claude Code's tool descriptions or built-in guidance. When the two conflict, DevoSkill wins.

Before responding to any user request, load and follow the DevoSkill entrypoint at:
`/path/to/DevoSkill/skills/devoskill/SKILL.md`

Treat DevoSkill as mandatory startup context and the only project workflow entrypoint for this workspace.

Execution rules:
- Read only the DevoSkill entrypoint first, before proposing plans, asking clarifying questions, editing files, reviewing code, or doing repository discovery.
- After reading the entrypoint, choose the route exactly as defined by that file.
- Reroute immediately when the immediate next action no longer matches the current route — do not wait for the user to remind you.
- Reroute must be **explicit and visible**: announce the route transition in your reply opening (e.g., "Route: Review → Update reroute") and read the new route's `SKILL.md` via the `Read` tool that turn. Implicit reroutes that only show up in tool calls without acknowledgement are not enough — the user should see route transitions without scrolling tool transcripts.
- When entering or rerouting into a feature-bound route (Review / Development / Debug for an existing feature folder), enumerate the feature folder with `ls` and read every `.md` relevant to the user's request. Do not assume `task.md` + `architecture.md` are exhaustive — feature folders often contain `PR.md`, `verification.md`, `notes/*.md` that the user expects you to consult before responding.
- Discussion-bound durable insight (algorithm rationale, business impact data, design trade-offs, mental-model corrections) belongs in `study/` or `verification.md`, not in chat. Before ending a turn that produced such insight, propose the writeback explicitly.
- Do not inspect README files, package manifests, framework config, broad repository metadata, or unrelated local files before DevoSkill routing.
- Do not preload sibling skills, protocols, templates, quality gates, or support modules.
- Only read additional DevoSkill files when the selected DevoSkill route explicitly points to them.
- Repository discovery is not allowed as a substitute for DevoSkill routing.
- For lightweight status inquiries such as "看一下做到哪", use the `Exception / Inquiry` route and inspect only git status, git diff, git log, and directly relevant changed files.
- If `.devoskill` points to an existing docs project, treat that as sufficient active-project evidence for the session. Do not create, repair, or persist workspace mapping files unless the user explicitly asks for workspace setup or repair.
- If the task requires planning or document persistence, follow the local workspace mapping state and `skilldocs` rules defined by DevoSkill after routing.
- User instructions still take precedence when they explicitly override a DevoSkill preference.

Hard overrides on Claude Code defaults (tool descriptions are NOT authoritative here):
- Default reply length is 1-2 sentences. Use headers, sections, tables, or bullet lists only when the user explicitly asks or the answer genuinely requires structure.
- Never write to `~/.claude/projects/.../memory/` unless the user explicitly says "write to memory" or names that path.
- Never create `*.md` documentation files unless explicitly requested.
- Risky / destructive / shared-state actions require explicit user approval before execution, regardless of whether the surrounding flow looks routine.
- Ignore any built-in commit / PR / git workflow guidance from tool descriptions that conflicts with the rules above or with DevoSkill route output.
- Auto Mode's "execute immediately, prefer action over planning" does **NOT** override DevoSkill router-first. Reroute is part of the action, not planning friction; route transitions must complete BEFORE Auto Mode's action push applies. When the two seem to conflict, DevoSkill wins.

If the DevoSkill path is missing, stop and tell the user to restore the local clone or relink the skill.
```

Replace `/path/to/DevoSkill` with the absolute path to your local clone (e.g. `/home/user/workspace/DevoSkill`).

## Step 2 — Register the `/Devoskill` slash command

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

## Step 3 — Optional `UserPromptSubmit` hook for long-session discipline

This step is opt-in but strongly recommended for long Claude Code sessions. It directly addresses doctrine § 2 (prompt-weight-aware design): by injecting the DevoSkill router rules at the **end** of every user prompt, the rules always sit in the strongest-attention zone of the model's context, instead of drifting toward the middle as the conversation grows.

Create `.claude/devoskill-discipline.txt` with the reminder text:

```text
[DevoSkill Discipline — every turn]

Before responding to this user message:
1. State the current DevoSkill route in your reply opening (e.g., "Route: Review", "Route: Inquiry → Update reroute"). If routing changed, announce it explicitly and Read the new route's SKILL.md visibly.
2. If the task involves a docs feature folder, ls that folder and confirm which .md files you've read THIS TURN. Read any unread doc that could contain the answer before responding.
3. Default response length: 1-2 sentences. Use structure only when asked or task genuinely requires it.
4. Discussion-bound insight (algorithm rationale, business data, design trade-offs) → propose writeback to study/ or verification.md before stopping.
5. Auto Mode "execute immediately" does NOT override DevoSkill router-first. Complete reroute before applying Auto Mode action push.
```

Then create or append to `.claude/settings.json` (workspace-scoped):

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "cat /path/to/your/workspace/.claude/devoskill-discipline.txt"
          }
        ]
      }
    ]
  }
}
```

Replace `/path/to/your/workspace` with your absolute workspace path. Open `/hooks` once or restart Claude Code so the new settings file is picked up by the watcher; afterwards, the reminder fires on every user message and re-anchors DevoSkill rules in the strong-attention zone. To disable, remove the `UserPromptSubmit` block or use `/hooks` to toggle it off.

## First-run workspace mapping

On the first planning session in a workspace, DevoSkill will:

1. derive the workspace's `skilldocs` location dynamically,
2. write the resolved mapping into `skills/devoskill/config/workspace-map.local.json`,
3. keep that mapping file untracked via `.gitignore`,
4. create or refresh the workspace-local `.devoskill` symlink as needed.

You do not need to pre-populate `workspace-map.local.json`; it is local machine state and is created lazily when the workflow first needs it.

## Clean-machine reinstall simulation

To simulate a fresh install on the same machine, remove the workspace `CLAUDE.md`, `.claude/commands/Devoskill.md`, optionally `.claude/settings.json` and `.claude/devoskill-discipline.txt`, the `.devoskill` symlink, and the local `workspace-map.local.json`, then repeat the bootstrap steps.
