# Performance Profiling & Debugging

When tasked with optimizing system performance, debugging latency spikes, or analyzing bottlenecks (especially in high-concurrency or AI inference services like Triton), adhere to the following systematic procedures.

## 1. Baseline Establishment
- Never optimize blindly. Establish a quantitative baseline before changing any code.
- Construct and execute a stress test (e.g., sending batches of requests at varying concurrency levels, such as 4, 8, or 16 workers).
- Record the critical metrics: P50 latency, P95 long-tail latency, CPU utilization (%), and Memory/VRAM footprint.

## 2. Profiling Tools & Execution
- System Resource Monitoring: Utilize `htop` or `nvidia-smi` to log active loads precisely during the stress test window.
- Flame Graph Generation:
  - Utilize profiling tools (e.g., `py-spy` for Python) to generate CPU flame graphs while the stress test is actively running.
  - Analyze the flame graph to identify function calls with the highest exclusive execution time (e.g., expensive image resizing, redundant memory copies, or thread contention).

## 3. Architecture-Specific Analysis (Inference/Gateway)
If debugging a backend or inference service:
- Python vs Backend Overhead: Isolate whether the latency belongs to the preprocessing layer (e.g., OpenCV cv2.INTER_CUBIC vs INTER_LINEAR) or the actual model backend (e.g., ONNX/CUDA execution).
- Thread Contention: Check if high concurrency is causing thread thrashing. Adjust variables like `intra_op_num_threads` or uvicorn worker counts to stabilize CPU usage.

## 4. Documentation & Reporting
- Do not output lengthy text summaries.
- Update the Benchmarks table in `skilldocs/<Project_Name>/architecture.md` with "Before vs After" results.
- Translate any findings from the flame graph directly into actionable refactoring steps in `task.md`.
