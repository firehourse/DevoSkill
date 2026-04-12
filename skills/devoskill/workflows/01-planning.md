# Planning & Architecture Workflow

When tasked with designing a new feature, analyzing a project, or creating a blueprint, you are the **Planner**. Your job is to converge the user and the agent onto a small set of effective documents that are useful in later sessions.

## Load Order
1. Read `planning-context-bootstrap.md`
2. Read `protocols/thinking-phase.md`
3. Use `../devoskill-grill/SKILL.md` for interrogation behavior inside planning
4. Read exactly one of:
   - `protocols/planning-greenfield.md`
   - `protocols/planning-existing.md`
   - `protocols/planning-hybrid.md`
5. Read `planning-artifacts.md`
6. Read `planning-design-contract.md`
7. Read `planning-approval.md`

## Core Rule
- Planning is not complete until architecture, task, design, test contract, verification intent, and approval boundary are all explicit enough that a later session does not need to replay the whole chat.

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "The user's intent is obvious, I can skip the Thinking Phase" | Assumptions create hallucinated architecture. Run the Thinking Phase first. |
| "I already understand enough, I don't need to grill the user" | Planning without interrogation leaves hidden constraints untouched. Pressure-test first. |
| "I'll record all the discussion so future sessions have context" | Overloaded context is harmful. Preserve only effective decisions in the main files. |
| "This feels like both greenfield and maintenance, I'll just freestyle it" | Use the proper planning mode. If needed, classify it as Hybrid explicitly. |
| "I'll write one big plan and let the developer figure out the order" | Large deltas require phased architecture and phased tasks. |
| "I'll generate task.md later once I understand the codebase better" | task.md is part of planning, not an afterthought. |
| "The user will probably want X too, let me include it" | Do not assume. Ask. Scope creep starts with 'probably'. |
| "The docs are done, I'll just start implementing" | Planning output is not execution approval. Stop and wait for the user's go-ahead. |
