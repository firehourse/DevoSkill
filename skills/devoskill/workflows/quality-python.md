# Quality Workflow — Python

Apply after `05-quality.md`. Fix any failures before writing back to `task.md`.

---

## 1. Package and Environment Management

**Principle:** `uv` is the only allowed package manager. `pip install`, `poetry`, and `pipenv` are banned. Dependencies are declared in `pyproject.toml`; the lockfile must be committed. Virtual environments are managed by `uv`, not activated manually.

| | Example | Why |
|---|---|---|
| ❌ | `pip install requests` / `requirements.txt` as sole dependency declaration | no lockfile, unreproducible |
| ✅ | `uv add requests` — updates `pyproject.toml` and `uv.lock` | pinned, reproducible installs |
| ❌ | `source .venv/bin/activate` in documentation or CI steps | manual env, drifts from lockfile |
| ✅ | `uv run python ...` or `uv run pytest` — uv manages the environment | env resolved from lockfile |

---

## 2. Type Annotations

**Principle:** Every function signature must carry type annotations. `Any` is banned except when wrapping third-party code that has no stubs. Return types must be explicit — `-> None` is required, not implied.

| | Example | Why |
|---|---|---|
| ❌ | `def process(data):` — no annotations | no static checking |
| ✅ | `def process(data: list[str]) -> None:` | type checker catches misuse |
| ❌ | `from typing import Any; def load(obj: Any) -> Any:` | `Any` disables checking |
| ✅ | Narrow the type or wrap in a typed dataclass/TypedDict | precise contract enforced |

---

## 3. Resource Management

**Principle:** File handles, network connections, database sessions, and subprocess pipes must be opened with `with` statements. Manual `.close()` calls in finally blocks are acceptable only when `with` is genuinely not available for the resource type.

| | Example | Why |
|---|---|---|
| ❌ | `f = open(path); data = f.read(); f.close()` | leaks handle on exception |
| ✅ | `with open(path) as f: data = f.read()` | handle closed on every path |
| ❌ | `session = db.Session(); ... session.close()` — skipped on exception | session leaks on error |
| ✅ | `with db.Session() as session: ...` | session always cleaned up |

---

## 4. Async Patterns

**Principle:** `asyncio.run()` is the only valid entry point for an async main. Never mix blocking I/O calls inside `async def` functions — use `asyncio.to_thread` or an executor for blocking operations. `asyncio.gather` errors must be caught per-task, not at the gather call only.

| | Example | Why |
|---|---|---|
| ❌ | `loop = asyncio.get_event_loop(); loop.run_until_complete(main())` | deprecated, leaks event loop |
| ✅ | `asyncio.run(main())` | manages loop lifecycle |
| ❌ | `async def fetch(): return requests.get(url)` — blocks the event loop | stalls all coroutines |
| ✅ | `async def fetch(): return await asyncio.to_thread(requests.get, url)` | offloads blocking call to thread |
| ❌ | `results = await asyncio.gather(*tasks)` — one failure swallows others silently | first error cancels rest silently |
| ✅ | `results = await asyncio.gather(*tasks, return_exceptions=True)` then check each result | per-task errors inspectable |

---

## 5. Error Handling

**Principle:** Catch the narrowest exception type possible. Bare `except:` and `except Exception:` without re-raise or logging are banned. Errors must be logged with context before being swallowed. Use custom exception classes for domain errors — string matching on exception messages is banned.

| | Example | Why |
|---|---|---|
| ❌ | `try: ... except: pass` | swallows all errors silently |
| ❌ | `except Exception as e: print(e)` — no structured logging, swallowed | error lost, no context |
| ✅ | `except ValueError as e: logger.error("parse failed", extra={"input": raw, "error": str(e)}); raise` | logged with context, re-raised |
| ❌ | `if "not found" in str(e):` — string matching on exception message | breaks on message change |
| ✅ | `except TaskNotFoundError:` — typed domain exception | stable, intent-revealing match |

---

## 6. Structured Logging

**Principle:** Use the standard `logging` module configured with a structured formatter (e.g. `python-json-logger`). `print()` is banned in production paths. Every log call in a request or job handler includes the request/job ID as an extra field.

| | Example | Why |
|---|---|---|
| ❌ | `print(f"processing task {task_id}")` | unstructured, no log level |
| ✅ | `logger.info("processing task", extra={"task_id": task_id})` | structured, queryable fields |
| ❌ | `logging.basicConfig(level=logging.DEBUG)` in library code | hijacks app logging config |
| ✅ | Logger configured only at application entry point; libraries use `logging.getLogger(__name__)` | app owns config, libs defer |

---

## 7. Immutable Data and Mutable Defaults

**Principle:** Never use mutable objects as default argument values — they are shared across all calls. Use `None` as the default and initialize inside the function body. Prefer dataclasses or TypedDict over plain dicts for structured data passed between layers.

| | Example | Why |
|---|---|---|
| ❌ | `def append_item(item, lst=[]):` — `lst` is shared across all calls | shared mutable default leaks state |
| ✅ | `def append_item(item, lst=None): if lst is None: lst = []` | fresh list per call |
| ❌ | `def configure(opts={}):` | shared dict across calls |
| ✅ | `def configure(opts: dict[str, str] | None = None): opts = opts or {}` | fresh dict, typed |

---

## 8. Module and Package Structure

**Principle:** Each module has one coherent responsibility. `__init__.py` files export only the public API — implementation details are not re-exported. Circular imports are a structural failure, not something to work around with lazy imports inside functions.

| | Example | Why |
|---|---|---|
| ❌ | `from .service import *` in `__init__.py` | leaks implementation into public API |
| ✅ | Explicit exports: `from .service import UserService` | controlled public surface |
| ❌ | `def get_user(): from .models import User` — lazy import hiding a cycle | hides structural cycle |
| ✅ | Restructure to remove the cycle | clean dependency graph |
