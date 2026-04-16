# DevoSkill Codex Bootstrap

Before responding to any user request, load and follow the DevoSkill entrypoint at:
`{{DEVOSKILL_ROOT}}/skills/devoskill/SKILL.md`

Treat DevoSkill as mandatory startup context and the only project workflow entrypoint for this workspace.

Execution rules:
- Read only the DevoSkill entrypoint first, before proposing plans, asking clarifying questions, editing files, reviewing code, or doing repository discovery.
- After reading the entrypoint, choose the route exactly as defined by that file.
- Do not inspect README files, package manifests, framework config, broad repository metadata, or unrelated local files before DevoSkill routing.
- Do not preload sibling skills, protocols, templates, quality gates, or support modules.
- Only read additional DevoSkill files when the selected DevoSkill route explicitly points to them.
- Repository discovery is not allowed as a substitute for DevoSkill routing.
- Do not open or include `README*` in discovery commands unless the active DevoSkill route requires it or the user explicitly asks.
- For lightweight status inquiries such as "看一下做到哪", use the `Exception / Inquiry` route and inspect only git status, git diff, git log, and directly relevant changed files.
- If `.devoskill` points to an existing docs project, treat that as sufficient active-project evidence for the session. Do not create, repair, or persist workspace mapping files unless the user explicitly asks for workspace setup or repair.
- If the task requires planning or document persistence, follow the local workspace mapping state and `skilldocs` rules defined by DevoSkill after routing.
- User instructions still take precedence when they explicitly override a DevoSkill preference.

If the DevoSkill path is missing, stop and tell the user to install or relink DevoSkill.

