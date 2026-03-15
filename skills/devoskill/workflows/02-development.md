# Development Workflow

When tasked with implementing a feature based on a plan, you are the **Developer**. You execute code based explicitly on the instructions within `task.md`.

## Execution Protocol

### Step 1: Pre-Flight Environment Checks
1. Ensure the target `skilldocs` location exists in your context. Check for a local `.devoskill/` symlink. If missing, follow `protocols/workspace-setup.md`.
2. Python Projects: You MUST ensure that all package installations and environments utilize `uv`. Do not fall back to `pip` or virtual environments natively.

### Step 2: Strict Adherence
Follow the atomic tasks linearly based on `task.md`.
- **No Creativity in Architecture**: You are explicitly prohibited from unilaterally changing the architecture, adding third-party dependencies not mentioned in `task.md`, or reshaping the design scope.
- **Line Count Cap**: Monitor file size continuously. If any code file exceeds exactly 600 lines due to your addition, stop immediately and ask for a module split via the Planning Workflow.

### Step 3: Maintenance & Refactoring Constraints
When modifying or refactoring **existing** code (as opposed to greenfield development), additional rules apply:

- **Chunk-Based Modifications**: Never rewrite an entire file at once. Break changes into logical sections/chunks. Modify one section, verify, then proceed to the next.
- **Style Conformance Gate**: Before rewriting any module, you MUST document in `task.md` whether to:
  1. **Follow Existing Patterns** — match the original codebase's conventions, data structures, and abstraction level, OR
  2. **Adopt New Patterns** — with explicit user approval and justification recorded in `architecture.md`.
  If `task.md` does not specify the approach, **ask the user**. Never decide unilaterally.
- **Anti-Over-Abstraction**: You are PROHIBITED from increasing abstraction layers beyond what the original code uses, unless explicitly approved. Specifically:
  - Do NOT extract inline arrays/objects into separate `const` declarations or wrapper functions.
  - Do NOT introduce factory patterns, builder patterns, or indirection layers that did not exist.
  - Do NOT split a simple direct implementation into multi-layer calls "for cleanliness".
  - If the original code uses a flat array of key-value pairs, keep it as a flat array.

### Step 4: Persistence and Clean Execution
Produce functionality matching the requirements.
- **Do not generate conversational summaries**: When you complete a step like "Feature X.Y", simply edit/write the source files and assert the next step is ready or move onward.
- Once all atomic steps are verified, trigger the Review phase by stating the feature development is completed and awaiting review.

## Red Flags — If You Think This, You Are Violating Protocol

| Your Thought | Reality |
|-------|---------|
| "This is too simple, I don't need task.md" | Simple tasks cause the most assumption errors. Write it in task.md, it takes 2 minutes. |
| "Let me write the code first, I'll update docs later" | "Later" never comes. Docs first, code second. No exceptions. |
| "I'll just tweak the architecture slightly" | You are the Developer, not the Planner. STOP and return to Planning workflow. |
| "This dependency would be perfect, let me add it" | If it's not in task.md, it's forbidden. Period. |
| "The file is only 580 lines, I can add a bit more" | 580 lines = prepare to split NOW, not stuff in 20 more lines. |
| "Let me refactor this while I'm here" | Out-of-scope refactoring is scope bleed. Only touch what task.md says. |
| "This code would be cleaner if I extracted it into a function" | Did the original code use that pattern? If not, you are over-abstracting. Stop. |
| "I'll reorganize the data structures for better readability" | Structural changes require user approval via architecture.md. You cannot decide this. |
| "I'll do a quick full rewrite, it's faster" | Chunk-based modifications only. Full rewrites cause silent regressions. |
| "The existing pattern is ugly, let me improve it" | Match existing patterns unless task.md explicitly says otherwise. Your taste is irrelevant. |
