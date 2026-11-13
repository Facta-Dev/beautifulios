#!/usr/bin/env python3
"""Contract tests: the drop-in SwiftLint/swift-format config stays pinned."""

from __future__ import annotations

import json
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
LINT = REPO_ROOT / "lints" / ".swiftlint.yml"
FORMAT = REPO_ROOT / "lints" / ".swift-format"


class SwiftLintConfig(unittest.TestCase):
    def setUp(self):
        self.text = LINT.read_text(encoding="utf-8")

    def test_force_rules_are_opted_in(self):
        for rule in ("force_unwrapping", "implicitly_unwrapped_optional", "untyped_error_in_catch"):
            self.assertIn(rule, self.text)

    def test_length_budgets_are_pinned(self):
        for key in ("line_length:", "file_length:", "function_body_length:", "cyclomatic_complexity:"):
            self.assertIn(key, self.text)

    def test_strict_reporting(self):
        self.assertIn("ignores_comments: false", self.text)


class SwiftFormatConfig(unittest.TestCase):
    def test_format_file_pins_the_style(self):
        data = json.loads(FORMAT.read_text(encoding="utf-8"))
        self.assertEqual(data.get("lineLength"), 120)
        self.assertEqual(data.get("indentation", {}).get("spaces"), 4)


if __name__ == "__main__":
    unittest.main()
