# DevoSkill Development Doctrine

This document defines the stable development doctrine for DevoSkill itself.

It exists so future humans and agents can understand the system's design intent before modifying the router, skills, workflows, protocols, templates, or document system.

This is not a feature plan and not a historical log. It is the long-lived rulebook for how DevoSkill should be extended without losing its core strengths.

## 1. Primary Objective

DevoSkill is an agent-oriented engineering system.

Its job is not merely to store prompts. Its job is to make AI execution more reliable by:

- routing work into the correct phase early,
- keeping the active context small,
- turning architecture, testing, execution, and evidence into durable documents,
- preventing hidden assumptions from surviving across sessions,
- and making later review possible without replaying the full chat.

## 2. Prompt-Weight-Aware Design

DevoSkill is designed around a practical prompt-engineering reality:

- models over-weight the beginning of what they read,
- models also strongly follow the most recently loaded instructions,
- and the middle of a large prompt blob is comparatively weak.

That leads to these structural rules:

- The entry router should stay high-level and decision-focused.
- The router should classify mode, bootstrap state, and immediate next action before loading details.
- The router should not carry large bodies of implementation rules, standards, or templates.
- Detailed constraints should live in the routed skill or the focused workflow it loads next.

This is why the router is intentionally broad while phase skills are more specific. The split is not stylistic. It is a response to how agents actually consume prompt context.

The same logic extends to how rules are loaded within a phase:

- Loading all rules upfront and then acting means the first-read rules drift to the middle of the prompt — the weakest attention zone.
- Rules should be loaded **immediately before the action they govern**, not all at the start of the phase.
- Phase skills should be written as execution scripts: "before doing X, read Y, then do X immediately."
- This keeps each rule in the bottom of the active context — the strongest attention zone — at the moment of application.

This is the just-in-time loading principle. It applies at every level: entry router to phase skill, phase skill to workflow, quality gate to category check.

### 2a. Strongest-Attention Anchoring

Each `SKILL.md` should put its **non-negotiable behavior** at the very bottom of the file in a section explicitly named `## Strongest-Attention Rules` (or equivalent). Because models weight the end of a freshly-read file most strongly, this is where the rules an agent MUST NOT forget belong. Procedural setup (load order, classification, prerequisites) goes earlier; the irreducible "if you remember nothing else from this route, remember these" rules go last.

A reroute or a long-session re-anchor should always end by re-reading at minimum the tail section of the active route's `SKILL.md`. The hook reminder and the CLAUDE.md reroute discipline both exist to make this practical.

### 2b. Attention-Anchoring Duplication Is An Allowed Exception To § 4

DevoSkill normally forbids duplicating prompt logic across files (§ 4). The exception: when a rule must survive long-session attention drift, the same rule may be intentionally restated at multiple anchoring sites — typically in `CLAUDE.md` (session-start anchor), in a `UserPromptSubmit` hook payload (per-turn re-anchor), and at the tail of the relevant `SKILL.md` (per-reroute re-anchor). Three anchoring sites is a soft ceiling; more than three is duplication, not anchoring.

When restating, keep the wording identical across sites so an attentive future maintainer can grep and reconcile. Differences in wording across anchors signal drift, not richer specification.

### 2c. Path Resolution Discipline

Cross-file references inside DevoSkill markdown must use the tokenized absolute form `{DEVOSKILL_ROOT}/...`, never the `../` relative form. Reason: models reading a file with `../foo` references inconsistently resolve them — some resolve from the file's own directory (correct), some from the agent's current working directory (which is typically the user's workspace, NOT the DevoSkill clone), producing silent broken loads.

`{DEVOSKILL_ROOT}` is the absolute path of the DevoSkill clone, bound once at session start in the router `SKILL.md` from the absolute path the bootstrap `CLAUDE.md` (or equivalent agent bootstrap) used to reach the router. The router preamble is the single binding site; every other file just substitutes the token.

Same-file `## section` anchors are unaffected — they have no resolution ambiguity. ASCII directory trees inside `README.md` are also unaffected — they are illustrations, not loadable cross-references.

Subagent prompts (see `{DEVOSKILL_ROOT}/skills/devoskill/protocols/subagent-orchestration.md § 0`) also use `{DEVOSKILL_ROOT}` — orchestrators substitute the bound value when emitting the subagent preamble, so subagents receive an absolute path, not a token they must independently resolve.

## 3. Fine-Grained File Design

DevoSkill favors many small files over a few dense files.

The reason is operational:

- agents often read an entire file once loaded,
- they do not reliably recover the right sentence from the middle of a long mixed-responsibility document,
- and long files blur semantic boundaries.

Therefore:

- each `SKILL.md` should answer when a mode or support module applies,
- each workflow should answer one narrow operational question,
- each protocol should own one shared semantic concern,
- each template should define one durable document contract.

Templates should be shaped for their document job instead of labeled by audience. Architecture states boundaries and behavior deltas, task drives execution, test maps proof, and verification stores evidence. Execution rules belong in protocols and workflows.

This is intentionally close to a functional-programming style of decomposition:

- small units,
- explicit composition,
- minimal hidden state,
- minimal side effects,
- and narrow responsibility per unit.

## 4. Shared Contracts Over Duplication

Repeated prompt logic behaves like duplicated code.

If the same rule is copied into multiple places:

- drift becomes likely,
- future edits become incomplete,
- and agents may receive conflicting instructions depending on load order.

Therefore:

- shared semantics belong in protocols or shared workflows,
- phase-local rules belong in the relevant phase skill,
- examples and templates should not restate global contracts unless the local context genuinely needs them.

Before adding a new skill or workflow, ask:

1. Is this a new responsibility boundary?
2. Is this logic already owned somewhere else?
3. Will a new file improve load precision, or only create duplication?

If the answer to the third question is "duplication", do not add the file.

## 5. Document System As Bounded Contexts

The SkillDocs system is not generic documentation. It is a bounded document architecture.

Each artifact owns a different semantic contract:

- `architecture.md` owns effective architecture and stable boundaries.
- feature-level `architecture.md` owns behavior-delta skeletons when observable behavior or agent workflow behavior changes.
- `design.md` owns the execution-facing implementation contract.
- `test.md` owns the testing contract derived from `design.md`.
- `task.md` owns only the active executable phase.
- `verification.md` owns durable verification evidence, behavior-delta evidence, and reconciliation notes.
- project-root `study/` owns reusable system understanding, code-reading guides, domain studies, and flow maps that help future Inquiry or Planning work recover current reality without rediscovering a large codebase.
- project-root `project-changelog.md` owns feature/change timestamp rows and rationale that should not pollute the default load surface.
- feature-level `notes/` owns rejected ideas and local material not needed in the default load surface.

If these documents disagree, the system is in drift. Drift must be reconciled in the documents, not explained away in chat.
If these documents still present consequential active alternatives—public behavior, boundaries, dependencies, security/data rules, operational risk, scope, or required evidence—the system is still in Planning. Equivalent private implementation choices may remain adaptive and are resolved by Development against current repository reality.
Planning files should not carry long historical explanations. They should state the effective decision and point to the relevant `project-changelog.md` entry when the rationale, legacy burden, or accumulated context matters.
Study files should not become feature plans. They preserve reusable understanding; Planning promotes only the change-specific pieces into `architecture.md`, `design.md`, or `task.md`.

This is where the system is closest to DDD:

- each document owns its own bounded meaning,
- cross-document relationships must be explicit,
- and no document should silently claim another document's authority.

## 6. Document-Driven Synchronization

DevoSkill assumes work happens across multiple sessions, agents, and human handoffs.

That means the durable planning surface is the synchronization mechanism.

The expected loop is:

1. plan and write the contract,
2. execute against the contract,
3. write back reality,
4. verify against evidence,
5. review against the persisted truth.

Chat is not the synchronization layer. Chat can clarify or negotiate, but it does not replace writeback.

If a future session cannot recover the current truth by reading the intended documents, the planning surface is incomplete.

## 7. Testing As A First-Class Contract

Testing should not be implicit and should not live only as a list of commands in `verification.md`.

DevoSkill treats testing as its own planning artifact:

- `design.md` explains how the system is structured,
- `test.md` explains how that structure will be proven,
- `verification.md` records what was actually executed and what happened.

`test.md` must derive from `design.md`, not from vague intent.

Minimum expected traceability:

- class responsibilities map to unit tests,
- runtime flows map to integration tests,
- behavior contracts and state transitions map to acceptance tests or BDD scenarios,
- ownership and authorization boundaries map to dedicated negative and access-control tests.

Methodology selection is explicit:

- greenfield defaults to `TDD`,
- journey-heavy or cross-runtime work may explicitly choose `BDD`,
- existing systems default to `Follow Existing Project Pattern` unless planning approves a change.

## 8. Reviewability Over Documentation Volume

More writing is not automatically better planning.

The correct question is whether later execution and review are possible with low ambiguity.

Documents should stay small because:

- they are loaded directly into model context,
- oversized files pollute future sessions,
- and mixed history lowers signal quality.

The line limit is not cosmetic. It is a reliability guard for later prompt loading.

If a file grows beyond the approved planning surface, split it by responsibility, move project-level rationale into `project-changelog.md`, or move feature-local abandoned context into `notes/`.

## 9. Extension Rules For Future Contributors

When extending DevoSkill:

- do not enlarge the router unless the new rule affects first-step classification,
- do not create a new top-level skill if a support module is enough,
- do not add a template without defining its authority boundary,
- do not add or revise engineering/quality standards without following `{DEVOSKILL_ROOT}/skills/devoskill/protocols/standard-authoring.md`,
- do not add repeated rules to multiple files when one shared protocol can own them,
- do not put execution rules into template skeletons when a protocol or workflow should own them,
- do not hide new execution requirements in README prose only,
- do not treat verification evidence as a substitute for a proper design or test contract.
- do not use Study as a shortcut around Planning approval or Development scoping.
- write all skill prompt files (SKILL.md, protocols, workflows, templates, registries) in English — English instructions get better model adherence. Exceptions: verbatim evidence quotes, repo-template skeletons preserved as-is, and registry trigger terms (bilingual so non-English user phrasing still matches).

Any change that affects the default document system should update:

- document authority,
- document loading order,
- document persistence,
- workspace layout,
- study surface rules when reusable code understanding is affected,
- relevant workflows,
- relevant templates,
- and README or doctrine references where humans discover the system.

## 10. How To Judge A Good Change

A good DevoSkill change should make at least one of these better without weakening the others:

- routing accuracy,
- context economy,
- document authority clarity,
- execution predictability,
- testability,
- reviewability,
- or evidence quality.

A bad change usually has one of these smells:

- duplicated prompt logic,
- larger default load surface,
- blurry document ownership,
- rules that exist only in chat,
- or a new file that has no sharp boundary.

## 11. Non-Negotiable Invariants

- Router first, details later.
- Single-responsibility prompt files.
- Durable state belongs in the right artifact, not in chat.
- Design and test contracts must exist before serious implementation.
- Active development documents must be decision-complete for user-visible behavior, system boundaries, dependencies, security/data rules, and operational contracts. Local code structure is an implementation hypothesis: Development may improve it inside those approved boundaries and must write the effective shape back.
- Verification evidence is not the same thing as test design.
- Review judges compliance against persisted contracts, not remembered conversation — and compliance is the review floor, not the goal; the independent defect hunt comes first.
- Legacy material is never exempt from current standards; it is migrated under the `legacy-migration.md` contract, not grandfathered.

Future maintainers may extend the system, but should not violate these invariants without intentionally redesigning DevoSkill itself.
