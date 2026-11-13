#!/usr/bin/env bash
# check-build.sh — compile and test the Swift package example.
# A missing Swift toolchain is a visible SKIP; CI (macOS) runs it.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v swift >/dev/null 2>&1; then
  echo "check-build: SKIP — swift not found (CI runs it on macOS)"
  exit 0
fi

swift test --package-path examples/minimal
echo "check-build: OK"
