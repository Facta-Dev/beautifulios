# Swift strict for iOS

The Swift 6 subset and the type/isolation patterns that make a native app hard
to break.

## 1. The subset

- Swift 6 language mode, complete strict concurrency, warnings as errors in CI.
- `@MainActor` for UI state and ViewModels; actors for shared mutable state;
  `Sendable` for values crossing an isolation boundary.
- Value types (`struct`, `enum`) by default; classes only for identity or
  Observation.
- `let` over `var`; immutable state; one closed enum per screen.
- No force unwrap outside a proven invariant; no `try!` in product code.
- No `nonisolated(unsafe)`/`@unchecked Sendable` without an invariant
  comment.
- Typed ids (`struct InventoryId: Hashable, Sendable`) instead of raw strings.

## 2. Sealed state

```swift
enum InventoryState {
    case loading
    case empty
    case ready([InventoryRow])
    case forbidden(requiredPermission: String?)
    case offline
    case error(correlationId: String?)
}
```

- A `switch` over the enum is exhaustive; a new case is a compile error.
- Never model a screen with independent booleans.

## 3. Isolation

- The ViewModel is `@MainActor @Observable`; its state mutation happens on the
  main actor.
- A data adapter is an `actor` or a `Sendable` value; a blocking call runs off
  the main actor and is awaited.
- A closure crossing an isolation boundary is `@Sendable`; a captured
  reference is `Sendable`.
- `Task` inherits the actor context; `Task.detached` is for a deliberate
  non-isolated job and must be justified.

## 4. Errors

- Domain use cases return a `Result`/`Outcome` for expected failures; throw
  only for programmer errors.
- `CancellationError` is rethrown, never converted into a user error.
- Every error carries a stable `code` and a `correlationId`.

## 5. Foundation discipline

- Domain uses Foundation value types deliberately; no `URLSession`, no
  Keychain, no `FileManager` in Domain.
- Dates/decoding at the boundary; a DTO is mapped in Data, not in the UI.
- `Codable` models are `Sendable` value types.

## 6. SwiftUI type rules

- The view body is small; extract subviews.
- `@State` for view-local state; `@Bindable` for an Observable model;
  `@Environment` for injection.
- A `ForEach` has a stable id.
- No `AnyView` in a hot path; no expensive computation in `body`.

## 7. SwiftLint and swift-format

- SwiftLint `--strict`; a `// swiftlint:disable` names the rule and the
  reason.
- `swift-format` for whitespace; the formatter is not a debate.
- A baseline file is reviewed like code; growing it silently is a finding.

## 8. Review questions

1. Is the state one enum?
2. Is every `switch` exhaustive?
3. Is the UI mutation main-actor isolated?
4. Is `Sendable` satisfied at the boundary?
5. Is the id a typed value, or can a raw string stand in?
6. Is every external value parsed once (link, push, API)?
7. Is cancellation propagated, and is the error a value?
