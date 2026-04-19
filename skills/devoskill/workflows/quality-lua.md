# Quality Workflow — Lua

Apply after `05-quality.md`. Fix any failures before writing back to `task.md`.

---

## 1. Module Pattern

**Principle:** Every module must follow the `local M = {}; return M` pattern. Global variable assignment at module scope is banned — all state lives inside the returned table or inside local-scoped upvalues. Functions intended as private must be `local` and not added to `M`.

| | Example |
|---|---|
| ❌ | `function setup() ... end` — pollutes global namespace |
| ✅ | `local M = {}; function M.setup() ... end; return M` |
| ❌ | `config = {}` at module scope — global leak |
| ✅ | `local config = {}` — module-local upvalue |

---

## 2. Error Handling with pcall

**Principle:** Any call that can fail at runtime (I/O, JSON decode, external API, `vim.api` calls on potentially invalid buffers) must be wrapped in `pcall` or `xpcall`. Bare function calls that can error will crash the calling context silently in Neovim. `xpcall` is preferred when a traceback is needed.

| | Example |
|---|---|
| ❌ | `local data = vim.json.decode(raw)` — crashes on invalid JSON |
| ✅ | `local ok, data = pcall(vim.json.decode, raw); if not ok then return end` |
| ❌ | `vim.api.nvim_buf_set_text(buf, ...)` without checking buffer validity |
| ✅ | `if not vim.api.nvim_buf_is_valid(buf) then return end` before API calls |

---

## 3. Nil Guards

**Principle:** Lua silently propagates `nil` through table indexing — `a.b.c` where `b` is `nil` raises an error. All multi-level table accesses must be guarded. Use `vim.tbl_get` for deep access into tables you do not own.

| | Example |
|---|---|
| ❌ | `local text = data.candidates[1].content.parts[1].text` — any nil crashes |
| ✅ | `local text = vim.tbl_get(data, "candidates", 1, "content", "parts", 1, "text")` |
| ❌ | `if result and result.value then` — only one level deep |
| ✅ | `vim.tbl_get` or explicit guard at each level |

---

## 4. Neovim API Usage

**Principle:** Always use `vim.schedule_wrap` when calling `vim.api.*` from inside async callbacks (timers, `vim.system`, coroutines). Direct `vim.api` calls from non-main contexts cause crashes. Use `vim.uv` (not deprecated `vim.loop`) for libuv operations.

| | Example |
|---|---|
| ❌ | `vim.system({...}, {}, function(r) vim.api.nvim_buf_set_text(...) end)` |
| ✅ | `vim.system({...}, {}, vim.schedule_wrap(function(r) vim.api.nvim_buf_set_text(...) end))` |
| ❌ | `vim.loop.new_timer()` |
| ✅ | `vim.uv.new_timer()` |

---

## 5. Timer and Resource Lifecycle

**Principle:** Every `vim.uv.new_timer()` must be explicitly stopped and closed when no longer needed. Unreferenced running timers are not garbage-collected — they leak until the session ends. Store the timer reference and call `:stop()` then `:close()` before replacing or discarding it.

| | Example |
|---|---|
| ❌ | `pending = vim.uv.new_timer(); pending:start(500, 0, cb)` — old timer leaked when `pending` is overwritten |
| ✅ | `if pending then pending:stop(); pending:close() end; pending = vim.uv.new_timer()` |
| ❌ | `timer:stop()` only — timer object not closed, fd leaked |
| ✅ | `timer:stop(); timer:close()` always in sequence |

---

## 6. Namespace and Extmark Hygiene

**Principle:** Each plugin must create exactly one namespace with `vim.api.nvim_create_namespace` at module load time and reuse it. Extmarks must be explicitly deleted when cleared — setting new extmarks does not remove old ones. Buffer-local state (extmark IDs) must be invalidated when the buffer changes.

| | Example |
|---|---|
| ❌ | `vim.api.nvim_create_namespace("myplugin")` called on every operation — creates duplicate namespaces |
| ✅ | `local ns = vim.api.nvim_create_namespace("myplugin")` once at module scope |
| ❌ | Drawing a new ghost text without deleting the previous extmark |
| ✅ | `vim.api.nvim_buf_del_extmark(buf, ns, id)` before creating a replacement |

---

## 7. No Magic Strings and Keys

**Principle:** Keymaps, autocmd events, highlight group names, and API constant strings must be declared as named locals at module top. Bare string literals in `vim.keymap.set` calls or `nvim_create_autocmd` are invisible to search and break silently on typo.

| | Example |
|---|---|
| ❌ | `vim.keymap.set("i", "<Tab>", ...)` repeated in multiple places |
| ✅ | `local ACCEPT_KEY = "<Tab>"` at module top; reused in keymap and documentation |
| ❌ | `vim.api.nvim_create_autocmd("TextChangedI", ...)` as a bare string in multiple places |
| ✅ | Constant or clearly named variable for repeated event strings |
