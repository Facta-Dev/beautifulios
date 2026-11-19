---
name: ios-best-practices
description: >-
  Write idiomatic, fast, maintainable native iOS apps in Swift 6 + SwiftUI
  written as code. Use this skill whenever you write, review, refactor, debug,
  or explain an iOS app: SwiftUI views, @Observable ViewModels, UDF state and
  intents, Swift packages and targets, NavigationStack and deep links, GRDB and
  the outbox, Keychain, APNs, StoreKit, ARKit/RealityKit, Swift Testing, or
  XcodeGen/Tuist manifests. Trigger on any mention of iOS, Swift, SwiftUI,
  Xcode, Swift 6, strict concurrency, @Observable, NavigationStack, SwiftPM,
  GRDB, Keychain, APNs, StoreKit, or "fix this screen" even when the user never
  says "best practices". Synthesized from Apple's SwiftUI and concurrency
  documentation, the App Store guidance, and the facta iOS handbook.
---

# iOS best practices

> Playbook set: start with [`PLAYBOOK_MASTER.md`](https://github.com/Facta-Dev/ai-coding-playbook/blob/main/PLAYBOOK_MASTER.md) —
> the catalog, precedence and cross-playbook invariants — then
> [`PLAYBOOK_MOBILE_IOS_SWIFT.md`](https://github.com/Facta-Dev/ai-coding-playbook/blob/main/PLAYBOOK_MOBILE_IOS_SWIFT.md). This skill is the runnable companion of that
> contract.

Distilled from Apple's SwiftUI and concurrency documentation, the App Store
guidance, and the facta iOS handbook (`PLAYBOOK_MOBILE_IOS_SWIFT.md`). The
digests live in `references/`; where they disagree, this file says which to
follow and why.

## 1. Mindset

- **Views are code.** Every view is SwiftUI written in Swift; no Storyboards,
  no XIBs, no Interface Builder, no visual project workflows as the source of
  truth. Previews are `#Preview` blocks in the same file.
- **Swift 6 language mode with strict concurrency.** Data races are compile
  errors; isolation is explicit; the main actor owns UI.
- **Modules enforce architecture.** Swift packages with a `Domain` target that
  imports no UI framework; a target that does not depend on another cannot
  import it.
- **Unidirectional data flow.** An `@Observable` ViewModel exposes state; the
  view sends intents; side effects go through ports.
- **One variant = one app target = one binary.** The market app does not ship a
  3D engine; entitlements and usage strings are scoped per variant.
- **Design for the floor, enhance upward** with capability tiers and a runtime
  quality governor, using Metal GPU families and memory APIs, not device lists.
- **The server is authoritative** for game state, prices, payments and
  entitlements; the app is untrusted.
- **Push is a channel, not a data path.** Minimal payloads; fetch after tap.
- **No vendor lock-in for irreplaceable assets.**
- **Measure on real older iPhones** and gate releases on MetricKit-style
  metrics.

## 2. Before you hand back code

Run these and fix everything they report:

```bash
swift test
swiftlint --strict
xcodebuild -scheme Market -destination 'platform=iOS Simulator,name=iPhone 16' build
```

- Fix a warning rather than silencing it. A `// swiftlint:disable` needs a
  reason on the narrowest line; a `nonisolated(unsafe)` or an
  `@unchecked Sendable` needs a comment naming the invariant the compiler
  cannot see.
- Lint config lives once, in `lints/.swiftlint.yml` and `lints/.swift-format`.
  If a project has none, suggest the BeautifuliOS drop-in of
  https://github.com/Facta-Dev/beautifulios.
- Test on a release build on an A12/A13-class device, not only a simulator on
  an Apple-silicon Mac.

## 3. Platform facts

- **Xcode 27.2 / Swift 6.4** is current (verify); the App Store floor is Xcode
  26 + the iOS 26 SDK, with the iOS 27 SDK deadline announced later.
- **iOS 18 deployment target** for all variants (iPhone XS/XR and later);
  lower only with fleet data.
- **SwiftPM local packages + a generated Xcode project** from a text manifest
  (Tuist `Project.swift` or XcodeGen `project.yml`); `.xcodeproj` is a build
  artifact, git-ignored, settings in `.xcconfig`.
- **No visual builders:** `.storyboard`, `.xib`, Reality Composer Pro scenes
  and the Core Data model editor are forbidden as the source of truth; CI
  blocks them.
- **NavigationStack** with typed route values + a router path owned by the app.
- **@Observable** ViewModels on the main actor; fine-grained invalidation is
  cheaper than `ObservableObject` on old CPUs.
- **Static linking** for SwiftPM libraries; few dynamic frameworks.

## 4. Architecture: Swift packages + vertical slices + UDF

| Layer | Target | Contains | Must not depend on |
|---|---|---|---|
| **Domain** | `Feature/<slice>/Domain` (pure Swift) | Entities, value objects, rules, ports | SwiftUI, UIKit, Foundation platform reach-through |
| **Data** | `Feature/<slice>/Data` | Adapters: SDK, GRDB, Keychain | SwiftUI, feature UI |
| **UI** | `Feature/<slice>/UI` | ViewModel, state, intents, effects, views | another feature's internals, data adapters |
| **App** | the app target | Composition root (`AppEnvironment`), router, DI | — |
| **Core** | `Kernel`, `UICore` | Shared value types, closed status set | feature code |

The contracts below are **unbreakable and non-waivable**: they are the reason
the app stays fast on an older iPhone and reviewable at year two. Projects can
restyle anything; developers cannot opt out, and neither can you.

1. **The main actor owns UI.** A view/model mutation happens on `@MainActor`;
   a data race is a compile error.
2. **Domain imports no UI framework.** No SwiftUI/UIKit in a Domain target;
   the package graph enforces it.
3. **UDF is the only presentation contract.** State down, intents up, effects
   once.
4. **The ViewModel never holds a `UIView`, a `UIViewController` or a view.**
5. **The server is authoritative.** The client hides an action; it never
   decides access.
6. **Every screen state is rendered**, including offline and forbidden.

When a change would cross a layer, **re-cut the layout**: move the logic to
the layer that owns it. The rule is never to weaken or delete the lints to
make a change pass; a config exception is a contract change.
Review treats a broken contract as an automatic Must fix; `ios-review`
ranks it above every other finding.

## 5. Swift 6 concurrency

- **`@MainActor` for UI state and ViewModels**; the view is main-actor
  isolated by SwiftUI.
- **Actors for shared mutable state**; `Sendable` for values crossing an
  isolation boundary.
- **`async`/`await` and `AsyncSequence`**; no completion-handler pyramids in
  new code.
- **Cancellation propagates:** a `Task` belongs to a scope; check
  `Task.isCancelled` in long loops; do not swallow `CancellationError`.
- **No `nonisolated(unsafe)` or `@unchecked Sendable` without a comment**
  naming the invariant and the lock/actor that enforces it.
- **No data races hidden by `DispatchQueue.main.async`**; use isolation.

## 6. UDF with Observation

- The ViewModel is `@MainActor @Observable`; it exposes `state` and `send(_
  intent:)`.
- The state is one closed enum plus its data; a `switch` that misses a case
  does not compile.
- Effects (navigation, alert, permission) leave through an `AsyncStream` with
  a single consumer; they never become state.
- The view renders the state and sends intents; no business logic in a view.
- Test the ViewModel without a UI: `@MainActor` tests, fake ports.

## 7. Navigation and deep links

- `NavigationStack(path:)` with a typed `[Route]`; the router owns the path.
- Routes mirror the URL playbook; a deep link is parsed against an allowlist,
  each parameter validated, unknown → not-found.
- A link received while signed out is queued and resumed after login.
- No state-changing action from a link; it opens a screen that offers it.
- Push taps use the same parser as a deep link.
- Authorization gates the destination server-side.

## 8. Data, offline and the outbox

- **GRDB** (SQLite, WAL) for the cache/outbox; code-defined migrations with
  fixtures for every release.
- `UserDefaults`/`@AppStorage` for non-sensitive prefs; **Keychain** for
  secrets.
- The outbox is persisted and drained on reconnect/foreground/background
  task, with an idempotency key and a dead-letter view.
- A conflict is resolved by the server; the local pending change is rejected
  visibly.
- Clear user data on sign-out/tenant switch.

## 9. SwiftUI

- **Views are code:** small views, `#Preview` in the same file, no visual
  builder.
- **State ownership:** `@State` for view-local state, `@Bindable` for a
  ViewModel binding, `@Environment` for dependency injection; never a global
  singleton.
- **Lists:** `ForEach(items, id: \.id)`; stable ids; `LazyVStack` for long
  content; avoid `AnyView` in hot paths.
- **Images:** Nuke/NukeUI with downsampling; `AsyncImage` does not cache.
- **Modifiers:** keep the view body small; extract subviews; avoid
  recomputing expensive values in `body`.
- **Accessibility:** labels, traits, Dynamic Type, VoiceOver, Reduce Motion;
  a tappable `Text` is not a button.
- **Localization:** String Catalogs, `String(localized:)`, no concatenated
  sentences; RTL and long translations survive.

## 10. Push notifications (APNs)

- **Token-based APNs** (`.p8`) from the backend; the app registers, sends the
  device token to the server, refreshes it, and revokes on logout.
- **Minimal payload:** `{ v, type, id, route }`; no personal data, no full
  resource, no action.
- The tap routes through the deep-link parser; the app fetches the resource.
- Permission primer before the system prompt; a denied permission is a state.
- Handle foreground, background and cold start; a deleted resource shows
  not-found.
- A notification service extension (code-only) handles rich content without
  trusting it.

## 11. Security

- **Keychain for tokens/secrets**, with the right accessibility class; never
  `UserDefaults`, logs, the bundle or a screenshot-visible screen.
- Auth: Sign in with Apple, passkeys, or OIDC + PKCE in
  `ASWebAuthenticationSession`; no embedded webview login.
- **ATS stays on**; no arbitrary-loads exception without a documented reason.
- **The server is authoritative** for game state, prices, payments and
  entitlements.
- App Attest is a server-side risk signal, never a client-side block.
- No secrets in the bundle; no certificate pinning without a rotation plan.

## 12. Performance

- **@Observable fine-grained invalidation**; keep view bodies small.
- **Startup:** lazy work, no heavy `App.init`/`didFinishLaunching`, static
  linking, few dynamic frameworks.
- **Images:** downsample to the display size; memory is the limit on old
  devices.
- **MetricKit + os.signpost** for launch, hang and memory diagnostics.
- **A runtime quality governor** lowers 3D/texture fidelity, never logic.
- **Device lab:** A12/A13-class, mid, newest; a launch/scroll regression fails
  CI.

## 13. Testing

- **Swift Testing** for domain/ViewModel; `@MainActor` tests; fake ports.
- **XCTest/XCUITest** for UI journeys and performance.
- **Snapshot tests** only where they earn their maintenance.
- **GRDB migrations** against fixtures of every released version; the outbox
  idempotency test.
- **Deep links and push** parsed by the same test table.
- **Device lab** metrics in CI; a regression is a failure.

## 14. Cross-skill contract

- `ios-review` reviews a change and ranks a broken architecture contract above
  every other finding.
- `ios-port` ports a React Native, web, UIKit/storyboard or legacy screen to
  SwiftUI-as-code with the same behavior and tests first.
- The `lints/` config is the machine-checkable half. When this skill and the
  config disagree, the config wins and this file is fixed.

## Sources

- `references/ios.md` — the platform digest: Xcode/Swift versions, SwiftUI,
  Swift 6 concurrency, SwiftPM, GRDB, APNs, MetricKit, no visual builders.
- `references/swiftui-patterns.md` — @Observable UDF, navigation, lists,
  images, accessibility.
- `references/ios-architecture.md` — packages/targets, layers, ports and the
  enforcement map.
- `references/swift-strict.md` — Swift 6, isolation, Sendable, value types,
  Result and swiftlint.
