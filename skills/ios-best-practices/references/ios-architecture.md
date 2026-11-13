# iOS architecture contract

The layer contract from the facta iOS handbook, reduced to what a native app
must keep. The Swift package graph is the enforcement.

## 1. Layers and targets

| Layer | Target | Contains | Must not depend on |
|---|---|---|---|
| **Domain** | `Feature/<slice>/Domain` (pure Swift) | Entities, value objects, rules, ports | SwiftUI, UIKit, platform reach-through |
| **Data** | `Feature/<slice>/Data` | SDK, GRDB, Keychain adapters | SwiftUI, feature UI |
| **UI** | `Feature/<slice>/UI` | ViewModel, state, intents, effects, views | another feature's internals, data adapters |
| **App** | app target | Composition root (`AppEnvironment`), router, DI | — |
| **Kernel/UICore** | shared packages | value types, closed status set | feature code |

- A target's `dependencies` is the complete list of what it may import; a
  forbidden edge is a compile error.
- Domain targets are pure Swift; a SwiftUI import does not compile.
- One variant = one app target; entitlements and usage strings are scoped per
  variant.

## 2. Ports

The consumer declares the port; the data/platform target implements it.

| Port | Declared by | Implemented by |
|---|---|---|
| `InventoryRepository` | feature Domain | SDK + GRDB adapter |
| `SessionStore` | Domain | Keychain adapter |
| `TokenProvider` | Domain | Keychain adapter |
| `Navigator` | feature UI | Router (app target) |
| `Notifier` | feature UI | APNs/local notification adapter |
| `Clock` | Domain | system clock (tests use a fake) |
| `LocationSource` | feature Domain | CoreLocation adapter |
| `SceneEngine` | feature Domain | tiered 3D adapters + 2D fallback |
| `PermissionChecker` | feature UI | platform permission adapter |

Ports use domain types; no `UIView`/`UIViewController` crosses into Domain.

## 3. UDF

- One closed `State` enum, one `Intent` enum, effects on one `AsyncStream`.
- The ViewModel is `@MainActor @Observable`; `send(_ intent:)` is the entry.
- The view renders the state and sends intents; no business logic in a view.
- The ViewModel never holds a `UIView`, a `UIViewController` or a view.

## 4. Variants

- Three app targets share the feature/core packages.
- The market app does not depend on the game engine or its entitlements.
- Product flavors that merely hide code are not the architecture.

## 5. Concurrency

- `@MainActor` for UI state; actors for shared mutable state; `Sendable` at
  boundaries.
- `async`/`await` + `AsyncSequence`; no new completion-handler pyramids.
- Cancellation propagates; a long loop checks `Task.isCancelled`.
- No `nonisolated(unsafe)`/`@unchecked Sendable` without an invariant comment.

## 6. Data and offline

- GRDB (SQLite/WAL) + Keychain; `UserDefaults` for non-sensitive prefs.
- The outbox is a GRDB table drained on reconnect/foreground/background with
  an idempotency key.
- A conflict is resolved by the server; the local change is rejected visibly.
- Migrations are code-defined and tested against fixtures.

## 7. Navigation

- `NavigationStack(path:)` with a typed `[Route]` owned by the router.
- Deep links are parsed/validated before becoming a route; unknown →
  not-found.
- A signed-out link is queued and resumed after login.
- Push taps use the same parser.

## 8. Security

- Keychain for tokens/secrets; no secret in `UserDefaults`/logs/bundle.
- Sign in with Apple, passkeys, or OIDC + PKCE with
  `ASWebAuthenticationSession`.
- The server is authoritative for game state, prices, payments,
  entitlements.
- ATS on; App Attest is a server-side signal; pinning only with rotation.

## 9. Testing

- Swift Testing for domain/ViewModel; `@MainActor` tests; fake ports.
- XCTest/XCUITest for journeys and performance.
- GRDB migration fixtures; outbox idempotency.
- Deep-link/push parser table tests.
- Device lab metrics in CI.

## 10. The enforcement map

| Rule | Where |
|---|---|
| Domain has no SwiftUI/UIKit import | target dependency graph + a script check |
| feature UI does not import another feature's internals | package graph |
| the app target contains no business logic | review + package graph |
| no visual builder as the source of truth | CI file check (no .storyboard/.xib) |
| no data races | Swift 6 strict concurrency |
| no unused variant engine | package graph + a size check |

When a change needs an exception, re-cut the layout; do not add a dependency
or a lint suppression. A config exception is a contract change.
