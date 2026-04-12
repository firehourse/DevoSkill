# Document System Protocol

Use this protocol when a phase needs the shared semantics of the SkillDocs document system.

The document system is organized like bounded contexts:
- Router Context
- Workspace Context
- Planning Context
- Execution Context
- Review Context
- Evidence Context

## Load Order
1. Read `document-authority.md`
2. Read `document-loading-order.md`
3. Read `document-persistence.md`
4. Read `document-reviewability.md`

Do not treat this file as the full rule body. It is the thin router for document semantics.
