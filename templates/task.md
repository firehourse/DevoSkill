# [Project/Feature Name] Execution Task List

This document acts as the sole source of truth for the Developer subagent. All actions must map to `architecture.md`. If architectural deviations are required, stop and update the architecture first.

## Global Constraints Reminder
- `NO FILE` shall exceed `600 lines`. If a task requires more, split the tasks into `Task 1.A` and `Task 1.B`, defining clear module boundaries.
- Adhere to the Python ecosystem rules (`uv`, etc.) if applicable.

---

## 1. Setup & Environment
*   **[Setup 1.1]**: Create `.devoskill` symlink if not already present.
*   **[Setup 1.2]**: Initialize `pyproject.toml` with `uv` (if Python).
    *   **Packages**: e.g., `fastapi`, `uvicorn`, `onnxruntime`

## 2. Core Implementation Tasks

### 2.1 [Module Name, e.g., Gateway Service]
*   **[Task 2.1.1]**: File: `src/api.py` (Ensure `< 600 lines`)
    *   **Dependency**: `FastAPI`
    *   **Logic**: Expose a single POST endpoint `/api/v1/process`. Parse incoming base64 payload.
*   **[Task 2.1.2]**: File: `src/core/image.py`
    *   **Logic**: Implement fixed `512x512` resize logic using `cv2.INTER_LINEAR`.

### 2.2 [Module Name, e.g., Triton Integration]
*   **[Task 2.2.1]**: File: `src/core/grpc_client.py`
    *   **Logic**: Instantiate Triton client and send FP32 tensors asynchronously.
    *   **Validation**: Must handle connection retries natively.

### 2.3 [CI/CD or Deployment]
*   **[Task 2.3.1]**: File: `docker-compose.yml`
    *   **Logic**: Orchestrate the gateway and backend processes, setting explicit resource limits.

---

## Developer Check-Off Protocol
- [ ] Symlink `.devoskill` validated.
- [ ] Task 1.1 - 1.2 Completed.
- [ ] Task 2.1.1 - 2.1.2 Code is clean, documented, and under 600 lines.
- [ ] Task 2.3.1 Deployment configurations created.
- [ ] **Review Request Generated.**
