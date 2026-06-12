---
name: devoskill-parallel-worktree
description: Parallel worktree support module for DevoSkill. Use when one or more concurrent feature/bug branches need their own isolated working directory and sidecar app container so the agent (or multiple agents) can multitask without each branch's edits clobbering another's. Single-branch work continues to use the project's main checkout.
---

# DevoSkill Parallel Worktree

Use this skill when the immediate need is **branch-level isolation for concurrent work**, not just a fresh branch in the main checkout. Typical triggers:

- The user explicitly asks for an isolated branch / container per ticket while another ticket is still in flight.
- The user invokes a known parallel-worktree script for the project (resolved from the local config — see below).
- The agent is asked to work on two or more tickets in the same session and needs reliable HTTP / test-runner isolation between them.
- Multiple agents (or multiple agent sessions) are coordinating on the same repo and need to avoid stepping on each other's working tree.

Do **not** preload this skill for ordinary single-branch work — the project's main checkout is faster and matches the project's normal git rules.

## Configuration: `parallel-worktree.local.json`

This skill is hardcode-free. All project-specific paths, container names, hostnames, scripts, and shared services come from a per-machine local config at:

```
skills/devoskill-parallel-worktree/config/parallel-worktree.local.json
```

That file is untracked (`.gitignore`), the same pattern as `workspace-map.local.json`. An example schema lives next to it as `parallel-worktree.example.json`. Copy and edit; do not commit the local file.

Each entry under `projects[]` describes one project that supports parallel worktrees:

- `project_name` — short slug used to identify the project (`acme-monolith`, `my-app`, etc.).
- `main_checkout` — absolute path to the project's primary checkout (the one that uses the normal branch flow).
- `worktree_root` — absolute path to the parent directory that holds per-slug worktrees.
- `scripts.spin_up` / `scripts.tear_down_flag` — the project's idempotent spin/teardown script and the flag that tears down (often `--down`).
- `scripts.install_hosts_helper` — optional one-time machine-setup script the user runs with sudo before the first worktree.
- `host.hosts_helper_path` — the narrow-scope sudoers helper that mutates `/etc/hosts`, if the project uses host-based routing.
- `host.hostname_template` — the per-slug hostname pattern (e.g. `myapp-{slug}.test`).
- `container.app_image` / `container.app_name_template` — the app container image and per-slug container name pattern.
- `container.shared_services` — container names of services (db, cache, search) shared across the main checkout and all worktrees.
- `container.shared_network` — the docker network those services live on.
- `shared_db.engine` / `shared_db.test_database_name` — the engine and the shared test DB the worktrees all point at by default.
- `shared_db.isolation_note` — free-text reminder of the schema-sharing caveat for this project.
- `overlay_files` — relative paths from the main checkout that are bind-mounted (read-only) into every sidecar so the worktree picks up gitignored runtime config.
- `slug_pattern` — regex the slug must match (often the ticket-number shape).
- `operator_manual` — path to the human-facing manual for commands, port allocation, troubleshooting.
- `git_rules_reference` — pointer to the project skill that owns branch / commit / PR rules — those are not redefined here.

If the project the user is working in does not have an entry, treat this as a precondition failure: ask the user to add the project to `parallel-worktree.local.json` before proceeding. Do not invent paths.

## Resulting topology (project-agnostic)

```text
host-proxy / per-developer-router
  ├─ <project-main-host>          → main checkout's app container
  └─ <hostname_template(slug)>    → worktree sidecar container
                                    mounts <worktree_root>/<slug>:/app
                                    shares <container.shared_services>
                                    on <container.shared_network>
```

The project's normal git rules still apply: one branch and one PR per work unit per repo. The worktree just gives that branch its own working directory and its own app container.

## Agent-side procedure

1. **Confirm parallel isolation is actually needed.** If the user only needs a fresh branch, stay in `main_checkout` and use the project skill's git rules. Reroute back to Development if appropriate.
2. **Resolve the project from local config.** Read `parallel-worktree.local.json`, pick the entry whose `project_name` matches the user's project (or whose `main_checkout` contains the current working directory). If no entry matches, stop and ask the user to add one.
3. **Confirm one-time machine prerequisites** (only on the first worktree for this project on this machine):
   - The `container.app_image` exists locally (or can be pulled / built).
   - If `host.hosts_helper_path` is required, it is installed and `sudo -n` works against it. If missing, ask the user to run `scripts.install_hosts_helper` once. **Never embed the user's sudo password in scripts or files.**
4. **Validate the slug.** It must match `slug_pattern`. Reject anything that doesn't (no surprise characters in hostnames, container names, or `/etc/hosts` writes).
5. **Spin the worktree:**

   ```bash
   <scripts.spin_up> <slug>
   ```

   The script is expected to be idempotent and to report the resulting branch / host / container.
6. **Drive code edits and tests against the sidecar**, not the main checkout's host. All app calls go to `hostname_template(slug)`; all test runs go through `container.app_name_template(slug)`.
7. **Tear down when the work unit is merged or abandoned:**

   ```bash
   <scripts.spin_up> <slug> <scripts.tear_down_flag>
   git -C <main_checkout> worktree remove <worktree_root>/<slug>
   ```

## Non-negotiables (project-agnostic)

These apply regardless of the specific project's config. Project-specific non-negotiables live in the project skill referenced by `git_rules_reference`.

- **Shared infrastructure is shared.** Services in `container.shared_services` (db, cache, search) are mounted on `container.shared_network` and shared with the main checkout and every other worktree. Do not parallelise work units that mutate the same schema or table at the same time; sequence them, or carve out per-sidecar isolation before parallel work.
- **Shared test DB is the default.** All sidecars typically overlay the same `config/database.yml`, so concurrent test runs across sidecars (or sidecar + main checkout) compete for the same `shared_db.test_database_name`. Symptoms include lock waits, deadlock-detector errors, and cleanup races. Mitigations, in order:
  1. Prefer in-memory / stubbed test data when an assertion does not require persistence.
  2. Clear stale locks via a project-specific maintenance command before retrying.
  3. If deadlocks persist within a single test run, drop the controller/request-layer test and use a reproducer against the sidecar host as authoritative HTTP-layer evidence; document the decision in the work unit's `verification.md`.
- **Per-worktree test DB is a schema-bundled change, not a standalone work unit.** The cleanest long-term answer is each sidecar pointing at its own `<test_db>_<slug>`. Do not carve a separate infra ticket for that — fold it into the next work unit that already touches the schema (migration / structure / seed). Pure non-schema work units keep using the shared test DB with the mitigations above.
- **Read-only overlay mounts.** Files in `overlay_files` are bind-mounted from `main_checkout` into the sidecar. Do not edit them inside the worktree expecting the sidecar to pick the change up — edit the main checkout copy, or extend the spin script's overlay list if a new gitignored runtime file is needed.
- **No direct DB writes for work-unit setup.** If the work unit needs a runtime flag or fixture toggle, prefer the project's HTTP admin flow. If a single-column toggle is the only realistic option, record the toggle plus the reverse statement in the work unit's `verification.md` before running the reproducer.
- **Narrow sudo scope on hosts helper.** If `host.hosts_helper_path` is used, its sudoers grant must be scoped to that helper only, and the helper must enforce `slug_pattern` before touching `/etc/hosts`. Do not expand the grant; do not invoke other sudo commands from the helper.
- **DevoSkill workflow gates still apply.** Worktree presence does not bypass Planning / Development routing, project ticket discipline, or the explicit-approval gates for `git push`, PR creation, or any external-state action. See `protocols/operational-gates.md`.

## Multi-agent coordination

When two or more agents (separate sessions, separate subagent invocations) work on the same project in parallel, each agent must:

- Pick a distinct slug. Two agents on the same slug means they edit the same worktree directory and clobber each other.
- Announce the chosen slug at the top of the first reply so the user can spot collisions.
- Confirm before reusing a slug whose worktree already exists — it may belong to another agent's in-flight work, not an abandoned attempt.
- Tear down only the slugs they own. Other slugs' sidecars may be running for a reason.

## Cross-references

- Project-specific git / branch / commit / PR rules: the project skill listed in this entry's `git_rules_reference`.
- Operator manual (commands, port table, troubleshooting): the path in this entry's `operator_manual`.
- DevoSkill cross-cutting operational boundaries (push, PR, external system updates): `{DEVOSKILL_ROOT}/skills/devoskill/protocols/operational-gates.md`.

---

## Strongest-Attention Rules

Re-read these on every reroute that brings parallel-worktree into scope.

1. **No hardcoded paths.** Everything project-specific comes from `parallel-worktree.local.json`. If the project isn't in the config, ask the user to add it — do not invent paths.
2. **Validate the slug against `slug_pattern`.** Hostnames, container names, and `/etc/hosts` writes derive from the slug; an unvalidated slug is a command-injection seam.
3. **Distinct slug per concurrent agent.** Two agents on the same slug share a working tree and will clobber each other's edits.
4. **Worktree does not bypass DevoSkill gates.** Push, PR, ticket discipline, and explicit-approval rules all still apply per the active route + `protocols/operational-gates.md`.
5. **Read-only overlays.** Files in `overlay_files` are edited in `main_checkout`, never inside a worktree.
