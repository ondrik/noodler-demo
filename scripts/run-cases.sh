#!/usr/bin/env bash
# Runs every cases/*.smt2 with Z3-Noodler and records the answer, the model and the time in
# cases/results.json (read by build.py).
#
# Usage: scripts/run-cases.sh [path/to/z3-noodler]   (default: z3-noodler on PATH)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
Z3="${1:-z3-noodler}"
TIMEOUT_MS=10000

python3 - "$ROOT" "$Z3" "$TIMEOUT_MS" <<'EOF'
import json, pathlib, subprocess, sys, time

root, z3, timeout_ms = pathlib.Path(sys.argv[1]), sys.argv[2], sys.argv[3]
version = subprocess.run([z3, "--version"], capture_output=True, text=True).stdout.strip()
results = {"solver": version, "cases": {}}
for path in sorted((root / "cases").glob("*.smt2")):
    start = time.perf_counter()
    proc = subprocess.run([z3, "model=true", f"timeout={timeout_ms}", str(path)],
                          capture_output=True, text=True)
    seconds = time.perf_counter() - start
    output = (proc.stdout + proc.stderr).strip()
    answer = output.splitlines()[0] if output else "error"
    results["cases"][path.stem] = {"answer": answer, "output": output, "seconds": round(seconds, 3)}
    print(f"{path.name:32} {answer:8} {seconds:.2f}s")
(root / "cases" / "results.json").write_text(json.dumps(results, indent=2) + "\n")
EOF
