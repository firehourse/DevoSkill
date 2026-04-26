# Study Surface Protocol

Use this protocol when Inquiry or Planning needs durable understanding of an existing codebase, subsystem, domain, or workflow.

Study is durable inquiry, not implementation planning.

## Load Conditions
- The user asks to learn a repository, subsystem, product flow, or architecture.
- Planning needs reusable current-reality knowledge before writing a feature-specific contract.
- The codebase is large enough that rediscovering the same entry points across sessions would waste context.
- The requested output is useful beyond one feature or ticket.

Do not use Study when:
- the question can be answered directly in chat with a small lookup,
- the discovery belongs only to the current feature,
- implementation is already approved and scoped,
- the work is measured debugging or performance diagnosis.

## Authority
- Project-root `study/` owns reusable system understanding.
- Project-root `study/registry.md`, when present, is only a thin selector for study files. It advertises filenames, scopes, trigger terms, and use moments; it does not own the durable understanding itself.
- Feature-level `architecture.md`, `design.md`, and `task.md` own change-specific decisions.
- Feature-level `notes/` owns local background that is not broadly reusable.
- `verification.md` owns executed checks; Study does not replace verification evidence.

## Required Study Shape
Every study document should include:
- purpose and scope,
- last updated date,
- read surface,
- explicit non-read surface when sensitive or intentionally excluded,
- architecture, flow, or domain summary,
- key files and entry points,
- responsibility boundaries,
- known risks, weak assumptions, or open questions.

## Discovery Behavior
1. Restate the understanding goal as searchable questions.
2. If `study/registry.md` exists and the question may match prior durable understanding, read it before reading individual study files.
3. Generate a small search plan across likely entry points:
   - routes, controllers, jobs, services, models, policies, and config,
   - exact domain terms, user-facing strings, error/log strings, and test descriptions,
   - cross-repository boundaries when the workspace contains multiple related repos.
4. Search cheap-to-expensive:
   - filenames and directory shape,
   - exact strings,
   - symbols and call sites,
   - directly relevant tests or specs,
   - git history only when the question depends on change rationale.
5. Read only the top candidate files needed to answer the study question.
6. Reformulate once using discovered names when the first search pass is weak.
7. Stop when the study can state the flow, boundaries, key files, and unknowns with evidence.

## Persistence Rules
- Inquiry may create or update `study/*.md` only when the user requested durable learning or the result is clearly reusable.
- Inquiry may create or update `study/registry.md` when `study/` grows enough that filenames alone no longer provide cheap discovery.
- Planning may read relevant `study/*.md` selectively, then promote only change-specific facts into feature planning documents.
- Development, Review, Quality, and Debug/Performance do not load Study by default.
- Raw search logs do not belong in Study. Preserve effective conclusions and evidence pointers only.

## Forbidden
- Do not edit product code while in Study.
- Do not treat Study as implementation approval.
- Do not store feature task checklists in `study/`.
- Do not copy whole source files or long archaeology transcripts into Study.
- Do not let Study become a default load surface for every phase.
- Do not use `study/registry.md` as a project-wide table of contents or as a substitute for DevoSkill phase routing.
