---
name: ios-review
description: >-
  Review a native iOS change — a SwiftUI view, an @Observable ViewModel, a
  Swift package/target boundary, a concurrency/isolation change, GRDB and the
  outbox, a deep link, APNs handling, or a diff — and produce a prioritized
  report where every finding cites the file and line, the rule it breaks, and
  the smallest fix. Use this skill whenever the user asks to review, audit,
  critique, or "find problems in" an iOS app, screen, ViewModel or package
  graph. Trigger on review, audit, code review, PR review, "what is wrong with
  this screen", "check this ViewModel", "review this package", or a pasted
  .swift file. Architecture and main-actor contracts always rank first.
---

# iOS review

A review is a prioritized list of findings, not a rewrite. Read the whole
change first. Every finding has four parts: **location** (file and line),
**severity**, **the rule it breaks** (named or quoted), and **the smallest
fix**. If you cannot cite a rule or a user-visible consequence, it is not a
finding; it is a preference for the Notes section, if anywhere.

## 1. Report shape

```text
## Verdict
<one paragraph: what this change does, whether it is safe to ship, and the
single most important thing to fix>

## Must fix
1. <file>:<line> — <finding>. Rule: <rule or contract>. Fix: <smallest fix>.

## Should fix
...

## Notes
...

## Waived gates
...
```

- **Must fix** blocks merge or release: a data race or a main-actor
  violation, a broken package boundary, a missing state, a token outside the
  Keychain, an outbox that loses a mutation, an unvalidated deep link.
- **Should fix** is worth doing in this change or the next: an unstable view
  identity, an image without downsampling, a launch-time regression.
- **Notes** is optional. Do not pad the report to look thorough.

## 2. Categories, in ranking order

### Architecture contracts (always Must fix, ranked first)

A broken architecture contract (ranked above everything) is a Must fix even
when the screen works. Check:

- A **Domain** target imports SwiftUI/UIKit or reaches through Foundation to
  the platform. Domain is pure Swift.
- A **view** calls a repository/SDK or contains a business rule; it must send
  an intent to its ViewModel.
- A **ViewModel** holds a `UIView`/`UIViewController` or a view.
- A feature imports another feature's internals; the app target contains
  business logic.
- One variant reaches another variant's engine/entitlements.
- A client-side permission check presented as access control.

### Swift 6 concurrency and isolation

- A UI mutation off the main actor; a `Task` that mutates `@MainActor` state
  without isolation.
- `nonisolated(unsafe)` or `@unchecked Sendable` without a comment naming the
  invariant and the lock/actor.
- A `DispatchQueue.main.async` used to hide a race; a completion-handler
  pyramid in new code.
- A `Task` with no cancellation check in a long loop; `CancellationError`
  swallowed.
- A shared mutable value crossing an isolation boundary without `Sendable`.
- An `Actor` whose state leaks through a non-`Sendable` return.

### UDF and SwiftUI

- State modeled as independent booleans instead of one closed enum.
- `@Observable` state mutated in a view; business logic in `body`.
- A view body that recomputes an expensive value or builds `AnyView` in a hot
  path.
- `ForEach` without a stable `id`; `id: \.self` on a mutable value.
- Effects stored in state instead of delivered once; a second consumer of an
  effect stream.
- Accessibility: a tappable `Text`/`Image` without a button trait or label;
  Dynamic Type/VoiceOver/Reduce Motion ignored.
- A storyboard/XIB or a visual-builder artifact as the source of truth.

### Data, offline and outbox

- A GRDB query on the main actor; a migration without fixtures; a destructive
  fallback that loses data.
- An outbox that is not persisted, not idempotent, or not drained on
  reconnect/foreground/background.
- An optimistic update with no rollback; a conflict silently overwritten.
- `UserDefaults`/`@AppStorage` holding a token or personal data instead of the
  Keychain.
- A cache with no eviction or a full-resolution image.

### Navigation and deep links

- A deep link parsed without an allowlist/type/size validation; unknown URL
  still navigates.
- A link that performs a state-changing action.
- A signed-out link dropped or replayed blindly.
- A second parser for push; a route not in the typed route table.
- A route guard presented as server authorization.

### Push

- A payload with personal data or a full resource; an action in the payload.
- A tap that does not use the deep-link parser; foreground/background/cold
  start handled differently.
- A denied notification permission treated as a crash; no primer.
- Token not refreshed/revoked; the server not deduping tokens.

### Security

- A secret in `UserDefaults`, a log, the bundle or a crash report.
- A client-side entitlement/payment decision; the server must be
  authoritative.
- An auth flow in a webview instead of `ASWebAuthenticationSession` + PKCE.
- ATS disabled or an arbitrary-loads exception without a documented reason.
- App Attest used as the only authorization decision; pinning without a
  rotation plan.

### Performance

- Heavy work in `App.init`/`didFinishLaunching`; no lazy startup path.
- A large view body, `AnyView` in a list, or an unstable identity causing a
  full reload.
- A full-resolution image/downsampling missing; an unbounded cache.
- No MetricKit/signpost evidence; no device-lab budget.
- A game engine/entitlements in the market variant.

### Tests

- No Swift Testing coverage for the ViewModel/domain; no fake ports.
- No XCTest/XCUITest journey for the critical flow; no snapshot test where it
  earns its place.
- No GRDB migration fixtures; no outbox idempotency test.
- No deep-link/push parser table test; no device-lab metrics.

## 3. Waived gates

If the diff deletes or weakens a lint, a test, a type, an isolation check or a
budget, flag the deletion itself, loudly — even when the new code looks fine.
Look for:

- A new `// swiftlint:disable` **without a reason**; a file/module-wide
  disable; a rule disabled in `.swiftlint.yml` or a baseline grown silently.
- A new `nonisolated(unsafe)`/`@unchecked Sendable` without the invariant
  comment.
- A package dependency added to cross a target boundary; an `@testable`
  import used to reach internals.
- A skipped test without an owner and expiry; a migration fixture deleted; a
  device-lab budget raised without evidence.
- A storyboard/XIB added; the deployment target lowered without fleet data.

State the deletion, the reason it claims, and what it would take to keep the
gate. "Temporarily" is not a reason; an expiring waiver with an owner is.

## 4. How to review

1. **Read the change twice.** First for intent, then for the diff.
2. **Run the gates if you can:** `swift test`, `swiftlint --strict`,
   `xcodebuild`, a release run on an older iPhone.
3. **Check isolation and the package graph first.** They are the expensive
   findings; style is cheap.
4. **Cite evidence.** File and line for every Must fix; a rule name or a
   quoted contract for every finding.
5. **Propose the smallest fix.** "Rewrite the screen" is not a fix; "move the
   GRDB read into a `nonisolated` data adapter and await it from the
   ViewModel" is.
6. **Stop when the change is safe.** An empty Should-fix section is a valid
   review.

## 5. Worked example

`examples/review-inventory.md` is a full review of a small SwiftUI inventory
screen: the blocking model, the state and list issues, the findings in ranking
order, and the fixed module. It shows the main-actor/isolation violation first,
then the UDF/state bug, then the list/accessibility gap.

## 6. Cross-skill contract

- `ios-best-practices` defines the rules this review cites. When a finding and
  the skill disagree, the skill is the source.
- `ios-port` produces the change; this review checks it before release.
- The `lints/` config is the machine-checkable subset. A finding the config
  can catch should become a rule, not a repeated comment.
