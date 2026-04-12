---
name: devoskill-exception
description: Lightweight exception/inquiry mode for DevoSkill. Use for file lookup, question answering, web research, latest-status checks, and problem clarification that do not yet require planning, implementation, review, or debugging workflow entry.
---

# DevoSkill Exception / Inquiry

Use this mode when the immediate task is lightweight inquiry rather than project-phase execution.
Examples:
- finding files or understanding local repository structure
- answering questions about the codebase or workflow
- researching latest external information
- clarifying a problem before it becomes planning, development, review, or debugging work

Do not use it once the next action becomes architecture planning, approved code changes, compliance review, or measured debugging. Reroute immediately when that happens.

## Load Order
1. Read only the minimum local files needed to answer the question
2. Use web lookup only when the request is latest-info, external research, or source verification work
3. Do not load planning/development/review/debug workflows unless the task reroutes into one of those modes

## Required Behavior
- Stay lightweight: answer the question, clarify the situation, or gather the requested facts.
- Do not create or rewrite `skilldocs` artifacts unless the task clearly becomes planning or execution work.
- Prefer direct inspection over loading unrelated skills.
- If the inquiry resolves into a concrete project phase, return to the router mindset and enter the proper mode.
