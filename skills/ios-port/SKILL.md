---
name: ios-port
description: >-
  Port an existing UI to an idiomatic native iOS app in Swift 6 + SwiftUI
  written as code, with the same behavior: a React Native app, a web app, a
  UIKit/storyboard app, or a legacy screen. Use this skill whenever the user
  asks to migrate, convert, rewrite, or port an app or screen to SwiftUI, or
  to modernize a UIKit/Storyboard app. Trigger on port, migrate, convert to
  SwiftUI, "turn this React Native app native", "move this storyboard to
  code", or a pasted Swift/UIKit/RN file. Port the original tests first, keep
  behavior identical, and write a PORTING.md.
---

# iOS port

A port preserves behavior while changing the implementation. The output is not
a UIKit screen wrapped in a `UIHostingController` or a web page in a WebView;
it is a SwiftUI app an iOS developer would have written, with the same
observable behavior and tests proving it.

## 1. The order of work

1. **Read the source and its tests.** The tests are the specification. If
   there are none, write characterization tests against the current behavior
   first.
2. **Port the tests first.** Same cases, same assertions, expressed in Swift
   Testing or XCTest. A port without a failing test is a rewrite with hope.
3. **Map every screen, state, intent, navigation path, network call and
   storage key.**
4. **Define the packages.** Domain (pure Swift), Data, Feature UI, App; ports
   for platform capabilities.
5. **Port one screen at a time**, with the closed state enum and the five
   states (loading, empty, error, forbidden, offline, ready).
6. **Run the gates.** `swift test`, `swiftlint --strict`, `xcodebuild`, a
   release run on an A12/A13-class device.
7. **Write `PORTING.md`.** Every deliberate difference, every platform feature
   not reproduced, every entitlement/usage-string change, and why.

## 2. React Native → native iOS

| RN | iOS |
|---|---|
| `View`/`Text` | `VStack`/`HStack`/`Text` |
| `Pressable` | `Button` with an accessible label |
| `FlatList`/`FlashList` | `List`/`LazyVStack` with stable ids |
| `expo-image` | Nuke/NukeUI with downsampling |
| `useState`/`useReducer` | `@Observable` ViewModel state |
| `useEffect` fetch | an async use case; the ViewModel awaits it |
| MMKV/AsyncStorage | GRDB / `UserDefaults` |
| Keychain/Keystore | Keychain |
| Expo Router | `NavigationStack` + typed routes |
| expo-notifications | APNs + `UNUserNotificationCenter` |
| `fetch` in a screen | the SDK adapter behind a port |
| Hermes/JS thread | Swift concurrency, main-actor isolation |

- **Keep the ViewModel contract, not the hook shape.** A hook becomes an
  `@MainActor @Observable` ViewModel with `state` and `send(intent:)`.
- **Keep the same route table**; deep links and push use one parser.
- **Move secure storage first**; a token in `UserDefaults` is a port that is
  not done.

## 3. UIKit/Storyboard → SwiftUI as code

- **Map the screen state and intents**, not the view tree.
- **Delete the storyboard/XIB**; every view is Swift, previews are `#Preview`.
- **Replace delegates/callbacks with async/await** and an `@Observable`
  ViewModel.
- **Replace `UICollectionView` with `List`/`LazyVStack`** unless a measured
  need requires a compositional layout in code.
- **Replace `UIViewController` navigation with `NavigationStack`** and typed
  routes.
- **Keep accessibility parity:** labels, traits, Dynamic Type, VoiceOver.
- **Do not embed a WebView** to keep a web screen; port the screen.

## 4. Web → iOS

- **Same SDK, different client.** Do not duplicate request logic; use the
  generated Swift SDK.
- **Same states** as SwiftUI, not a webview.
- **Auth:** Sign in with Apple, passkeys or OIDC + PKCE in
  `ASWebAuthenticationSession`; tokens in the Keychain.
- **Offline:** GRDB + the outbox; `localStorage` is not a mobile store.
- **Permissions:** a primer and a denied state; no crash.

## 5. Behavior parity checklist

- [ ] Every screen, action, shortcut and deep link exists.
- [ ] Every state is rendered: loading, ready, empty, forbidden, not-found,
      offline, error.
- [ ] Every network call has the same method, path, payload and headers.
- [ ] Every list has stable ids and survives a reload.
- [ ] UI mutations are main-actor isolated; data races are compile errors.
- [ ] Tokens are in the Keychain; no secret in `UserDefaults`/logs/bundle.
- [ ] The outbox is persisted and drained.
- [ ] Accessibility labels, traits, Dynamic Type and VoiceOver survive.
- [ ] The release build meets the launch/scroll budgets on the older iPhone.
- [ ] The original tests pass, ported; new tests cover the iOS-only paths.
- [ ] `PORTING.md` lists every deliberate difference.

## 6. What not to do

- **Do not keep the source framework's shape.** A React Native state tree in
  a ViewModel, a UIKit delegate chain, or a storyboard is a port that will be
  rewritten.
- **Do not wrap a web page in a WebView.**
- **Do not skip the tests.** A port validated only by tapping through it ships
  the source's bugs plus new ones.
- **Do not ship a variant with another variant's engine/entitlements.**
- **Do not silently change behavior.** Reproduce the source quirk, pin it with
  a test, and list the fix as a follow-up — or fix it deliberately and say so.

## 7. Cross-skill contract

- `ios-best-practices` is the target style; every ported screen follows it.
- `ios-review` reviews the port before release and ranks a broken
  architecture contract above every other finding.
- The `lints/` config is the machine-checkable half; a port that needs a lint
  exception is a port that has not finished.
