# Beautiful iOS lints

The two-file unit that turns the ios-best-practices skill into red-on-save
output:

- `.swiftlint.yml` — the drop-in rules: force unwrapping, implicitly
  unwrapped optionals, force try-adjacent patterns, untyped errors, length and
  complexity budgets, naming. Run with `swiftlint --strict`.
- `.swift-format` — the formatter (4-space indent, 120 columns, existing line
  breaks respected).

## Running it

```bash
swiftlint --strict
swift-format lint --strict --recursive Sources Tests
```

`scripts/check-lints.sh` runs SwiftLint on the clean control and the violation
harness when SwiftLint is installed. When it is missing it prints a visible
`SKIP` and exits 0 — the gate runs in CI (macOS), never silently downgraded on
a machine that has it.

## The check project

`lints/check/clean.swift` must stay quiet; `lints/check/violations.swift` holds
deliberate findings (a force unwrap, a force try, a long function, a TODO).
CI fails if either expectation breaks.

A `// swiftlint:disable` in product code names the rule and the reason on the
narrowest line. A module-wide disable or a grown baseline is a finding, not a
fix.
