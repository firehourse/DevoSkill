---
name: devoskill-doctrine
description: Doctrine and maintenance module for DevoSkill. Use when the immediate next action is auditing or modifying DevoSkill itself — its routes, protocols, workflows, templates, standards, or doctrine. Distinct from Update, which captures user-stated cross-session rules into custom-*.md.
---

# DevoSkill Doctrine / Maintenance

Use this skill when the task is to change DevoSkill itself: refactor a router, add or remove a route, audit cross-skill consistency, revise the doctrine, change the standard-authoring contract, modify document-system protocols, or extend the parallel-worktree / subagent / hook anchoring layers.

Do not use it for:
- capturing a short user-stated rule into `custom-*.md` (use `Update` instead);
- repairing workspace mapping or `.devoskill` symlinks (use `Workspace Setup`);
- writing or modifying a user project's planning docs (use `Planning`).

Assume the entry router has already classified the request as `Doctrine/Maintenance`.

If the work no longer matches doctrine/maintenance, stop and reroute instead of continuing.

## Load Order — Just-In-Time

Read each file immediately before the step that depends on it. Do not preload all of them at the start of the phase. (See doctrine § 2.)

1. Before judging whether the proposed change respects DevoSkill's design intent, read `{DEVOSKILL_ROOT}/docs/DevoSkill/doctrine.md` — specifically § 9 (Extension Rules) and § 11 (Non-Negotiable Invariants).
2. Before adding or revising any executable engineering or quality standard, read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/standard-authoring.md` and follow its rule shape (Principle / Required check / ❌-✅ examples).
3. Before changing the router or adding a route, re-read `{DEVOSKILL_ROOT}/skills/devoskill/SKILL.md` and confirm the change preserves the router's role as a thin classifier.
4. Before touching the document system (artifact authority, loading order, persistence, reviewability), read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/document-system.md` plus the specific `document-*.md` that owns the concern.
5. Before changing a phase skill's Load Order or Required Behavior, also read the existing phase skill so the refactor preserves its current invariants — what looks like cleanup can quietly remove a behavior contract.
6. Before changing anchoring mechanisms (CLAUDE.md template, UserPromptSubmit hook payload, Strongest-Attention tail sections), confirm the change respects doctrine § 2a (strongest-attention anchoring) and § 2b (allowed duplication).

## Required Behavior

- Treat doctrine § 9 (Extension Rules) and § 11 (Non-Negotiable Invariants) as binding for every change.
- Apply doctrine § 10 (How To Judge A Good Change): a change must improve at least one of routing accuracy / context economy / document authority / execution predictability / testability / reviewability / evidence quality, without weakening the others.
- Identify whether the change is general-framework (cherry-pickable to a clean DevoSkill main) or project/domain-specific (lives in a downstream skill). Do not mix the two inside a single edit unless the change is explicitly a bridging layer.
- When the change introduces a new file, state its single primary question in the first paragraph (per doctrine § 3 fine-grained file design).
- When the change restates an existing rule, confirm it qualifies as attention-anchoring duplication under § 2b. If it does not, refactor to a shared protocol instead.
- After the change, list every other file that should be updated to keep the system internally consistent (document-authority, document-loading-order, README directory structure, INSTALL.md template, etc.). Do not declare the change complete with stragglers unflagged.

---

## Strongest-Attention Rules

Re-read these on every reroute back into Doctrine/Maintenance and at any long-session re-anchor. If you remember nothing else from this route, remember these.

1. **Router stays thin.** Do not enlarge `{DEVOSKILL_ROOT}/skills/devoskill/SKILL.md` unless the new rule affects first-step route classification. Detailed constraints belong in the routed skill.
2. **Each file answers one primary question.** If a proposed edit makes a file answer two unrelated questions, split it first, then edit.
3. **Standards need Principle + Required check + ❌-✅.** Adjective-only standards ("write clean code") are not executable and must not be merged.
4. **Attention anchoring is the only allowed duplication.** Any other repeated rule across files is drift; consolidate into a protocol.
5. **Subagents run the router.** Any change that delegates work to a subagent must be checked against `protocols/subagent-orchestration.md § 0`.
6. **Cherry-pickability matters.** If the change is intended for general DevoSkill main, it must not reference any specific downstream project (a customer project, internal repo names). Project bindings live in a separate downstream skill.
