# iOS platform digest

The platform facts a native iOS app depends on, with the design consequence.
Apple's documentation is the source.

## 1. Toolchain and policy

- **Xcode 27.2 / Swift 6.4** is current; the App Store floor is Xcode 26 +
  the iOS 26 SDK (the iOS 27 SDK deadline is announced later). Verify.
- **iOS 18 deployment target** for all variants; lower only with fleet data.
- Swift 6 language mode with complete strict concurrency.
- SwiftPM local packages + a generated Xcode project from a text manifest
  (Tuist or XcodeGen); `.xcodeproj` is a git-ignored build artifact.
- **No visual builders** as the source of truth: no `.storyboard`, `.xib`,
  Reality Composer Pro scenes or Core Data model editor; CI blocks them.

## 2. UI

- SwiftUI written in code; `#Preview` in the same file.
- `@Observable` ViewModels on `@MainActor`; fine-grained invalidation.
- `NavigationStack(path:)` with typed routes.
- UIKit only in code when measured necessary (`UIViewRepresentable`,
  compositional layout).
- Lists with stable ids; Nuke/NukeUI for images with downsampling.
- String Catalogs + `String(localized:)`; design tokens in code.

## 3. Concurrency

- `@MainActor` for UI state; actors for shared mutable state; `Sendable` at
  isolation boundaries.
- `async`/`await` + `AsyncSequence`; no new completion-handler pyramids.
- Cancellation propagates; check `Task.isCancelled`; do not swallow
  `CancellationError`.
- `nonisolated(unsafe)`/`@unchecked Sendable` need an invariant comment.

## 4. Data

- **GRDB** (SQLite/WAL) for the cache/outbox; code-defined migrations and
  fixtures.
- `UserDefaults`/`@AppStorage` for non-sensitive prefs; **Keychain** for
  secrets.
- The outbox is persisted and drained on reconnect/foreground/background.
- A conflict is resolved by the server; the local change is rejected visibly.

## 5. Push

- Token-based APNs (`.p8`) from the backend.
- `UNUserNotificationCenter`; permission primer; denied is a state.
- Minimal payload `{ v, type, id, route }`; the tap uses the deep-link parser.
- Foreground/background/cold start handled the same way.
- Token lifecycle: register on login, refresh, revoke on logout.

## 6. Navigation and deep links

- Typed routes + a router-owned path; the route table mirrors the URL
  playbook.
- Deep links: allowlist, type/size validation, unknown → not-found.
- A signed-out link is queued and resumed after login.
- No state-changing action from a link; push uses the same parser.
- Authorization is server-side.

## 7. Device tiers

- Tier by silicon (A12/A13-class and up), memory and Metal GPU family; cache
  it.
- Budgets: launch, first frame, scroll FPS, memory, 3D frame time; calibrate
  on the older-iPhone pool.
- A runtime quality governor lowers fidelity, never logic.
- The low-end path is first-class and tested.

## 8. Performance

- Small view bodies; @Observable fine-grained invalidation; no `AnyView` in
  hot paths.
- Lazy startup; static linking; few dynamic frameworks.
- Downsample images to the display size; bounded caches.
- MetricKit + os.signpost for launch/hang/memory; a regression fails CI.

## 9. Security

- Keychain for tokens/secrets with the right accessibility class.
- Sign in with Apple, passkeys, or OIDC + PKCE in `ASWebAuthenticationSession`.
- ATS on; no arbitrary-loads exception without a documented reason.
- The server is authoritative for game state, prices, payments,
  entitlements.
- App Attest is a server-side signal; pinning only with rotation.

## 10. Testing

- Swift Testing for domain/ViewModel; `@MainActor` tests; fake ports.
- XCTest/XCUITest for UI journeys and performance.
- GRDB migrations against fixtures; outbox idempotency.
- Deep-link/push parser table tests.
- Device lab metrics in CI.
