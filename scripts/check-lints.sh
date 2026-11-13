#!/usr/bin/env bash
# check-lints.sh — prove the drop-in SwiftLint config fires.
# The clean control must stay quiet; the violation harness must fail.
# A missing swiftlint is a visible SKIP, never a silent pass; CI installs it.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v swiftlint >/dev/null 2>&1; then
  echo "check-lints: SKIP swiftlint — not installed (CI runs it)"
  exit 0
fi

if swiftlint --strict --config lints/.swiftlint.yml lints/check/clean.swift >/tmp/swiftlint-clean.log 2>&1; then
  echo "check-lints: clean control is quiet"
else
  cat /tmp/swiftlint-clean.log >&2
  echo "check-lints: FAIL — the clean control reported a finding" >&2
  exit 1
fi

if swiftlint --strict --config lints/.swiftlint.yml lints/check/violations.swift >/tmp/swiftlint-violations.log 2>&1; then
  echo "check-lints: FAIL — the violation harness stayed quiet" >&2
  exit 1
fi

echo "check-lints: violation harness fired; OK"
