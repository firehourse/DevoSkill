# Thinking Phasing Protocol

Use this protocol to decide whether the work must be split into phases.

Split into phases when:
- multiple major components are touched
- staged migration is required
- user review is needed between parts
- one phase creates prerequisites for another
- the plan would otherwise become too broad to reload cleanly

Each phase must be independently understandable.

Phases versus streams: in-place phases inside one `task.md` cover staged work in the SAME repo and ownership. When the work spans multiple repositories or ownership boundaries (e.g. a product fix plus integration testing in a separate harness repo), read `{DEVOSKILL_ROOT}/skills/devoskill/protocols/feature-streams.md` BEFORE shaping the feature folder — that work takes the ticket-root + stream-subfolder shape, never a flat single folder and never a sibling twin folder.
