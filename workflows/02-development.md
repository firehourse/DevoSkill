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

### Step 3: Persistence and Clean Execution
Produce functionality matching the requirements.
- **Do not generate conversational summaries**: When you complete a step like "Feature X.Y", simply edit/write the source files and assert the next step is ready or move onward.
- Once all atomic steps are verified, trigger the Review phase by stating the feature development is completed and awaiting review.
