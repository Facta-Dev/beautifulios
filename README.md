<p align="center">
  <img src="assets/icon.png" alt="Beautiful iOS: a blue swift on a dark field" width="160">
</p>

# Beautiful iOS

Three standard [Agent Skills](https://agentskills.io) and a lints config that
teach coding agents to write, review, port, and enforce idiomatic
**native iOS apps in Swift 6 + SwiftUI written as code**:

- **`ios-best-practices`** loads whenever an agent writes or changes an iOS
  app, and steers it toward views as code, strict concurrency, a package
  architecture and an older-iPhone performance budget.
- **`ios-review`** reviews existing code — a SwiftUI view, `@Observable`
  ViewModel, package boundary, concurrency change, GRDB path, deep link, APNs
  handler, or diff — and writes a prioritized report where every finding cites
  the rule it breaks and shows the fix.
- **`ios-port`** ports a React Native app, a web app, a UIKit/storyboard app,
  or a legacy screen to SwiftUI-as-code with the same behavior, porting the
  original tests first.
- **`lints/`** is a drop-in SwiftLint + swift-format unit that runs in CI.

They work with Claude Code, OpenAI Codex, GitHub Copilot, Cursor, Gemini CLI,
and any other agent that reads the Agent Skills format.

## Why

iOS rewards discipline and punishes shortcuts, especially on older iPhones:

- A Storyboard is not reviewable, diffable or generatable; it hides the view.
- A data race or a main-actor violation is a crash on a real device.
- A ViewModel that holds a `UIViewController` leaks the screen.
- A screen with three booleans renders impossible states.
- A token in `UserDefaults` is a breach on a shared device.
- A full-resolution image is a memory kill on an A12.
- A market app that ships a 3D engine is a download and review problem.

Beautiful iOS is the contract that catches those before review.

## Install

### Claude Code

```bash
/plugin marketplace add Facta-Dev/beautifulios
/plugin install beautiful-ios@beautiful-ios
```

### OpenAI Codex and ChatGPT

The repository ships a portable `plugin.json` with the `com.openai` interface
block. Point Codex at the repository, or package it with:

```bash
python3 scripts/package-openai-plugin.py --out beautiful-ios.zip
```

### Any agent

Copy `skills/ios-best-practices`, `skills/ios-review`, and `skills/ios-port`
into your agent's skills directory. Each skill is a `SKILL.md` plus a
`references/` digest; no runtime, no network.

## A worked example

Without the skill, an agent writes a screen that fetches in the view and
models the state with booleans:

```swift
// Without the skill: fetch in the view, three booleans, no isolation.
struct InventoryView: View {
    @State private var rows: [InventoryRow] = []
    @State private var loading = true
    @State private var error = false

    var body: some View {
        if loading {
            ProgressView()
        } else {
            List(rows, id: \.id) { row in
                Text(row.name).onTapGesture { archive(row.id) }
            }
        }
        .task { await load() }
    }
}
```

Problems: the view talks to the network, `loading`, `error` and `rows` can
contradict each other, the tap target is text rather than a button, and the
state is not isolated to a ViewModel.

With the skill, the view renders one state and sends an intent:

```swift
// With the skill: @Observable ViewModel, one state, button actions.
@MainActor
struct InventoryView: View {
    @State private var model: InventoryModel

    var body: some View {
        Group {
            switch model.state {
            case .loading: ProgressView()
            case .empty: Text("No inventory yet.")
            case .offline: Text("You are offline.")
            case .forbidden: Text("You do not have permission.")
            case .error: Button("Retry") { model.send(.refresh) }
            case .ready(let rows):
                List(rows, id: \.id) { row in
                    Text(row.name)
                    Button("Archive") { model.send(.archive(row.id)) }
                }
            }
        }
        .task { await model.refresh() }
    }
}
```

The package graph, the UDF contract and the enforcement map are in
[`skills/ios-best-practices/references/ios-architecture.md`](skills/ios-best-practices/references/ios-architecture.md).

## The architecture contract

```text
Feature/<slice>/UI  ──►  Feature/<slice>/Domain  ──►  ports
        │                        ▲
        └── state / intents ─────┘
Feature/<slice>/Data (SDK, GRDB, Keychain)  ──►  the ports
App target (composition root, router, DI)
```

| Layer | Owns | Must not depend on |
|---|---|---|
| **Domain** | Entities, rules, ports (pure Swift) | SwiftUI, UIKit, platform reach-through |
| **Data** | SDK, GRDB, Keychain adapters | SwiftUI, feature UI |
| **UI** | ViewModel, state, intents, effects, views | another feature's internals |
| **App** | Composition root, router, DI | — |

The unbreakable rules:

1. The main actor owns UI; a data race is a compile error.
2. Domain imports no UI framework.
3. UDF is the only presentation contract.
4. The ViewModel never holds a view/controller.
5. The server is authoritative.
6. Every state is rendered, including offline and forbidden.

## The lints config

[`lints/.swiftlint.yml`](lints/.swiftlint.yml) and
[`lints/.swift-format`](lints/.swift-format) are copy-in units:

- **SwiftLint:** force unwrapping, implicitly unwrapped optionals, untyped
  errors, length/complexity budgets, naming, `--strict`.
- **swift-format:** 4-space indent, 120 columns, existing line breaks
  respected.

[`scripts/check-lints.sh`](scripts/check-lints.sh) runs SwiftLint on the clean
control and the violation harness. A missing tool prints a visible `SKIP`; CI
(macOS) installs it and runs the same script. [`lints/check/`](lints/README.md)
holds the deliberate findings.

The Swift package in [`examples/minimal/`](examples/minimal/Package.swift) is
compiled and tested by [`scripts/check-build.sh`](scripts/check-build.sh) when
Swift is installed; the offline
[`scripts/check-examples.py`](scripts/check-examples.py) balances every Swift
block everywhere.

## What it does not do

- The skills contain instructions and reference text only. They make no
  network calls and collect no data ([PRIVACY.md](PRIVACY.md)).
- When a Swift/Xcode toolchain is available, the skills run `swift test`,
  `swiftlint`, and `xcodebuild`; without one, they work from the code alone.
- The lint config is a copy-in unit, not a dependency.
- The skills do not replace an iPhone device lab or an App Store review; they
  tell the agent what those must prove.

## Repository layout

```text
skills/
  ios-best-practices/  SKILL.md + references/ (platform, SwiftUI,
                       architecture, strict Swift)
  ios-review/          SKILL.md (report format, ranking, waived gates)
  ios-port/            SKILL.md (RN/web/UIKit → SwiftUI as code)
lints/
  .swiftlint.yml       the drop-in rules
  .swift-format        the formatter
  check/               the violation harness + clean control
scripts/
  check-skill.py       frontmatter, links, evals, manifests
  check-examples.py    Swift block balance (offline gate)
  check-build.sh       swift test of the example (SKIP without Swift)
  check-lints.sh       SwiftLint clean/violation harness (SKIP if absent)
  package-openai-plugin.py
tests/                 validator, wording, lints-config and gate tests
examples/
  minimal/             a SwiftPM package + Swift Testing example
  review-inventory.md  a full worked review
```

## Sources

- Apple's SwiftUI, Observation and Swift concurrency documentation.
- The facta iOS handbook (`PLAYBOOK_MOBILE_IOS_SWIFT.md`): views as code,
  packages, strict concurrency, UDF, GRDB, APNs, MetricKit.
- The App Store Review Guidelines and Human Interface Guidelines.

## Contributing

Rule proposals are welcome; open an issue with the
[rule template](.github/ISSUE_TEMPLATE/propose-a-rule.yml) and a source. A
rule without a source and a failing example is a preference, not a rule. See
[CONTRIBUTING.md](CONTRIBUTING.md).

## Siblings

Beautiful iOS is part of the Beautiful series for the facta playbooks:
[beautiful-j2ee](https://github.com/Facta-Dev/beautiful-j2ee),
[beautifulandroid](https://github.com/Facta-Dev/beautifulandroid),
[beautifulcli](https://github.com/Facta-Dev/beautifulcli),
[beautifulextension](https://github.com/Facta-Dev/beautifulextension),
[beautifulgo](https://github.com/Facta-Dev/beautifulgo),
[beautifulnodejs](https://github.com/Facta-Dev/beautifulnodejs),
[beautifulpython](https://github.com/Facta-Dev/beautifulpython),
[beautifulqt](https://github.com/Facta-Dev/beautifulqt),
[beautifulreact](https://github.com/Facta-Dev/beautifulreact),
[beautifulreactnative](https://github.com/Facta-Dev/beautifulreactnative),
[beautifulrust](https://github.com/Facta-Dev/beautifulrust).

## License

MIT — see [LICENSE](LICENSE).
