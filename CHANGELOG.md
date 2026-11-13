# Changelog

All notable changes to this project are listed here. Versions follow
[Semantic Versioning](https://semver.org/), and the version lives in
`.claude-plugin/plugin.json`.

## [Unreleased]

### Added

- **Three skills for native iOS.** `ios-best-practices` steers new code toward
  views as code with no visual builders, Swift 6 strict concurrency and
  main-actor isolation, Swift packages that enforce the Domain/Data/UI/App
  layers, UDF with `@Observable` ViewModels, NavigationStack and validated
  deep links, GRDB and the outbox, Keychain secrets, APNs and the older-iPhone
  performance budget. `ios-review` reviews a view, ViewModel, package
  boundary, concurrency change, GRDB path, deep link, APNs handler or diff and
  ranks architecture and main-actor contracts first. `ios-port` ports a React
  Native, web, UIKit/storyboard or legacy screen to SwiftUI-as-code.
- **A drop-in SwiftLint and swift-format config.** `lints/.swiftlint.yml`
  pins the force-unwrap, error-handling, length/complexity and naming rules
  with `--strict`; `lints/.swift-format` is the formatter.
- **A SwiftPM example and proof gates.** `examples/minimal/` is a Swift
  package with an `@Observable` model and Swift Testing tests;
  `scripts/check-build.sh` runs `swift test` when Swift is installed.
  `scripts/check-lints.sh` runs SwiftLint on the clean control and the
  violation harness, with a visible SKIP when the tool is absent.
- **A validator and a test suite.** `scripts/check-skill.py` checks
  frontmatter, links, eval cases and the plugin manifests; the offline
  `scripts/check-examples.py` balances every Swift block; `tests/` covers the
  validator, wording, lints config and gates.
- **A worked review.** `examples/review-inventory.md` shows the report shape
  and the architecture-first ranking on a small SwiftUI inventory screen.

[Unreleased]: https://github.com/Facta-Dev/beautifulios/compare/v0.1.0...HEAD
