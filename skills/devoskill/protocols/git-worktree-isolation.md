# Git Worktree Isolation Protocol

This protocol answers one question: **where must code-changing work run so a task cannot overwrite the primary checkout or another session's work?** It owns Git worktree isolation; runtime sidecars and concurrent service topology remain in `devoskill-parallel-worktree`.

## Principle

Every code-changing work unit in a Git repository runs in a dedicated task worktree by default. The primary checkout is a read-only coordination surface during implementation, not the place where an agent edits code.

## Required Check

Before the first file mutation:

1. Inspect `git status --short --branch`, `git branch --show-current`, and `git worktree list --porcelain`.
2. Reuse an existing worktree only when its branch and work unit clearly match the current task and no other session owns it.
3. Otherwise create a task branch and sibling worktree using the repository's existing naming/path convention. If no convention exists, use a descriptive task slug under a workspace-level hidden worktree root.
4. Confirm `git rev-parse --show-toplevel` resolves to the selected task worktree before editing.
5. Keep the primary checkout's tracked and untracked changes untouched. Never stash, reset, clean, copy, or absorb them into the task branch without explicit user direction.

If the task depends on uncommitted primary-checkout changes, stop and resolve ownership with the user; do not silently reproduce or move them. A non-Git repository cannot provide this isolation, so state that limitation before editing.

| | Example | Why |
|---|---|---|
| ❌ | Edit `/workspace/app` directly because only one task is active now. | A later session or existing user change can collide with the same checkout. |
| ✅ | Create or resume `/workspace/.app-work/task-123`, verify its task branch, then edit and test there. | The work unit has an explicit, inspectable isolation boundary. |
| ❌ | Reuse a similarly named worktree without checking its branch or owner. | Another session's in-flight work can be overwritten. |
| ✅ | Inspect the worktree list and status, then choose a distinct task slug when ownership is uncertain. | Existing worktrees remain safe. |

## Scope And Exceptions

- Read-only inquiry, diagnosis, and review may inspect the primary checkout without creating a worktree.
- A worktree does not grant permission to commit, push, open a PR, deploy, or mutate external systems; operational approval rules still apply.
- Do not remove a worktree merely because it looks stale. Remove only a worktree owned by the current work unit after merge/abandonment is confirmed.
- Load `devoskill-parallel-worktree` only when the task also needs a per-worktree container, hostname, shared-service wiring, or multi-session runtime isolation.

## Red Flags — If You Think This, Stop

- "The main checkout is clean, so isolation is unnecessary."
- "This will only take one edit."
- "That existing worktree is probably abandoned."
- "I can stash the user's changes and put them back later."

Each thought bypasses task ownership. Establish or verify the task worktree first.
