# Planning Context Bootstrap

Use this step to initialize the smallest safe planning surface.

## Rules
1. Ensure `<SKILLDOCS_DIR>` is resolved per `protocols/workspace-setup.md`.
2. Treat `protocols/document-system.md` as the shared document contract.
3. Read only the minimum code/docs needed to classify the work.
4. Treat the harness and artifact surface as first-class design constraints.
5. Complete the Thinking Phase before writing or rewriting planning documents.
6. After classification, choose exactly one planning protocol:
   - `planning-greenfield.md`
   - `planning-existing.md`
   - `planning-hybrid.md`
7. Resolve the feature folder before writing:
   - existing project: write under `<SKILLDOCS_DIR>/<feature-name>/`
   - new project: bootstrap project root plus first feature folder
8. Never create a second feature `task.md` at the project root.
