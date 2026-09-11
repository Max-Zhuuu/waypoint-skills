#!/usr/bin/env bash
# Verify chain graph consistency. Delegates to Python for reliable JSON + array handling.
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
python "$REPO_ROOT/tests/test_chain.py" "$REPO_ROOT"
