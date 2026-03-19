# DevoSkill Tests

DevoSkill test assets should stay small and purpose-built.

## Principles
- Test one routing behavior at a time.
- Prefer short prompts that resemble real user asks.
- Avoid loading a large test framework into the default skill context.
- Keep fixtures tiny; if a case needs a long spec, it is no longer a trigger test.

## Trigger Tests

The `skill-triggering/` folder contains a minimal harness for validating that short prompts route into the intended skill.

Run one test at a time:

```bash
tests/skill-triggering/run-test.sh devoskill-grill tests/skill-triggering/prompts/devoskill-grill.txt
```

The runner assumes a local `claude` CLI with plugin-dir support. If your agent harness differs, keep the prompts and adapt only the runner, not the fixture style.
