# [Project/Feature Name] Execution Task List

This document acts as the sole source of truth for the Developer subagent. All actions must map to architecture.md.

Global Constraints Reminder
- NO FILE shall exceed 600 lines. Split tasks if necessary.
- Adhere to Python ecosystem rules (uv) if applicable.

## 1. Setup & Environment
* [Setup 1.1]: Create .devoskill symlink if not already present.
* [Setup 1.2]: Initialize pyproject.toml with uv (if Python).
  * Packages: fastapi, uvicorn, etc.

## 2. Core Implementation Tasks

### 2.1 [Module Name, e.g., Gateway Service]
* [Task 2.1.1]: File: src/api.py
  * Dependency: FastAPI
  * Logic: Expose POST endpoint /api/v1/process.
* [Task 2.1.2]: File: src/core/image.py
  * Logic: Implement fixed 512x512 resize logic using cv2.INTER_LINEAR.

### 2.2 [Module Name, e.g., Backend Integration]
* [Task 2.2.1]: File: src/core/grpc_client.py
  * Logic: Instantiate client and send FP32 tensors asynchronously.
  * Validation: Must handle connection retries natively.

### 2.3 [Deployment]
* [Task 2.3.1]: File: docker-compose.yml
  * Logic: Orchestrate services setting explicit resource limits.

---

Developer Check-Off Protocol
- [ ] Symlink .devoskill validated.
- [ ] Task 1.1 - 1.2 Completed.
- [ ] Task 2.1.1 - 2.1.2 Code is clean and under 600 lines.
- [ ] Task 2.3.1 Deployment configurations created.
- [ ] Review Request Generated.
