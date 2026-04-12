# Quality Workflow

Apply this workflow as a pre-completion gate at the end of any implementation phase. For each category, read the principle, then use the examples to pattern-match against the produced code. Fix failures before writing back to `task.md`.

Use `protocols/document-system.md` as the shared contract for:
- which documents define intended behavior,
- where evidence should exist,
- and which artifacts count as default context versus history.

## Load Order
1. Read `quality-resource-safety.md`
2. Read `quality-resilience.md`
3. Read `quality-hygiene.md`
4. Read `quality-identity.md`
5. Read `quality-frontend.md`

Do not treat this file as the full rule body. It is the thin router for quality categories.
