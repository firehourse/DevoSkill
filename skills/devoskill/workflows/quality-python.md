# Quality Workflow — Python

Apply after `05-quality.md`. Fix any failures before writing back to `task.md`.

---

## 1. Package and Environment Management

**Principle:** `uv` is the only allowed package manager. `pip install`, `poetry`, and `pipenv` are banned. Dependencies are declared in `pyproject.toml`; the lockfile must be committed. Virtual environments are managed by `uv`, not activated manually.

| | Example |
|---|---|
| ❌ | `pip install requests` / `requirements.txt` as sole dependency declaration |
| ✅ | `uv add requests` — updates `pyproject.toml` and `uv.lock` |
| ❌ | `source .venv/bin/activate` in documentation or CI steps |
| ✅ | `uv run python ...` or `uv run pytest` — uv manages the environment |

---

## 2. Type Annotations

**Principle:** Every function signature must carry type annotations. `Any` is banned except when wrapping third-party code that has no stubs. Return types must be explicit — `-> None` is required, not implied.

| | Example |
|---|---|
| ❌ | `def process(data):` — no annotations |
| ✅ | `def process(data: list[str]) -> None:` |
| ❌ | `from typing import Any; def load(obj: Any) -> Any:` |
| ✅ | Narrow the type or wrap in a typed dataclass/TypedDict |

---

## 3. Resource Management

**Principle:** File handles, network connections, database sessions, and subprocess pipes must be opened with `with` statements. Manual `.close()` calls in finally blocks are acceptable only when `with` is genuinely not available for the resource type.

| | Example |
|---|---|
| ❌ | `f = open(path); data = f.read(); f.close()` |
| ✅ | `with open(path) as f: data = f.read()` |
| ❌ | `session = db.Session(); ... session.close()` — skipped on exception |
| ✅ | `with db.Session() as session: ...` |

---

## 4. Async Patterns

**Principle:** `asyncio.run()` is the only valid entry point for an async main. Never mix blocking I/O calls inside `async def` functions — use `asyncio.to_thread` or an executor for blocking operations. `asyncio.gather` errors must be caught per-task, not at the gather call only.

| | Example |
|---|---|
| ❌ | `loop = asyncio.get_event_loop(); loop.run_until_complete(main())` |
| ✅ | `asyncio.run(main())` |
| ❌ | `async def fetch(): return requests.get(url)` — blocks the event loop |
| ✅ | `async def fetch(): return await asyncio.to_thread(requests.get, url)` |
| ❌ | `results = await asyncio.gather(*tasks)` — one failure swallows others silently |
| ✅ | `results = await asyncio.gather(*tasks, return_exceptions=True)` then check each result |

---

## 5. Error Handling

**Principle:** Catch the narrowest exception type possible. Bare `except:` and `except Exception:` without re-raise or logging are banned. Errors must be logged with context before being swallowed. Use custom exception classes for domain errors — string matching on exception messages is banned.

| | Example |
|---|---|
| ❌ | `try: ... except: pass` |
| ❌ | `except Exception as e: print(e)` — no structured logging, swallowed |
| ✅ | `except ValueError as e: logger.error("parse failed", extra={"input": raw, "error": str(e)}); raise` |
| ❌ | `if "not found" in str(e):` — string matching on exception message |
| ✅ | `except TaskNotFoundError:` — typed domain exception |

---

## 6. Structured Logging

**Principle:** Use the standard `logging` module configured with a structured formatter (e.g. `python-json-logger`). `print()` is banned in production paths. Every log call in a request or job handler includes the request/job ID as an extra field.

| | Example |
|---|---|
| ❌ | `print(f"processing task {task_id}")` |
| ✅ | `logger.info("processing task", extra={"task_id": task_id})` |
| ❌ | `logging.basicConfig(level=logging.DEBUG)` in library code |
| ✅ | Logger configured only at application entry point; libraries use `logging.getLogger(__name__)` |

---

## 7. Immutable Data and Mutable Defaults

**Principle:** Never use mutable objects as default argument values — they are shared across all calls. Use `None` as the default and initialize inside the function body. Prefer dataclasses or TypedDict over plain dicts for structured data passed between layers.

| | Example |
|---|---|
| ❌ | `def append_item(item, lst=[]):` — `lst` is shared across all calls |
| ✅ | `def append_item(item, lst=None): if lst is None: lst = []` |
| ❌ | `def configure(opts={}):` |
| ✅ | `def configure(opts: dict[str, str] | None = None): opts = opts or {}` |

---

## 8. Module and Package Structure

**Principle:** Each module has one coherent responsibility. `__init__.py` files export only the public API — implementation details are not re-exported. Circular imports are a structural failure, not something to work around with lazy imports inside functions.

| | Example |
|---|---|
| ❌ | `from .service import *` in `__init__.py` |
| ✅ | Explicit exports: `from .service import UserService` |
| ❌ | `def get_user(): from .models import User` — lazy import hiding a cycle |
| ✅ | Restructure to remove the cycle |
