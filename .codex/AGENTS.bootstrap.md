# DevoSkill Codex Bootstrap

Before responding to any user request, load and follow the DevoSkill entrypoint at:
`{{DEVOSKILL_ROOT}}/skills/devoskill/SKILL.md`

Treat DevoSkill as mandatory startup context for this workspace.

Execution rules:
- Read `SKILL.md` before proposing plans, asking clarifying questions, editing files, or reviewing code.
- Route the task through the workflow selected by `SKILL.md`.
- If the task requires planning or document persistence, follow the workspace registry and `skilldocs` rules defined by DevoSkill.
- User instructions still take precedence when they explicitly override a DevoSkill preference.

If the DevoSkill path is missing, stop and tell the user to install or relink DevoSkill.
