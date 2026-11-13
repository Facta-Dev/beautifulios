# SwiftUI patterns

The patterns a SwiftUI app needs, with the failure mode each prevents.

## 1. The UDF ViewModel

```swift
@MainActor
@Observable
final class InventoryModel {
    enum State {
        case loading
        case empty
        case ready([InventoryRow])
        case forbidden(requiredPermission: String?)
        case offline
        case error(correlationId: String?)
    }

    private(set) var state: State = .loading
    private let useCases: InventoryUseCases

    init(useCases: InventoryUseCases) {
        self.useCases = useCases
    }

    func send(_ intent: InventoryIntent) {
        switch intent {
        case .refresh: Task { await refresh() }
        case .archive(let id): Task { await archive(id) }
        }
    }

    private func refresh() async {
        state = .loading
        do {
            let page = try await useCases.load()
            state = page.rows.isEmpty ? .empty : .ready(page.rows)
        } catch {
            state = Self.state(for: error)
        }
    }
}
```

- One closed `State`; a `switch` that misses a case does not compile.
- The model is `@MainActor @Observable`; the view renders and sends intents.
- Effects leave through an `AsyncStream`, not through state.

## 2. State ownership

- `@State` for view-local state (a sheet, a draft).
- `@Bindable` for a binding into an `@Observable` model.
- `@Environment` for dependency injection (the app environment, the router).
- No global mutable singleton.
- A view never constructs a repository; the composition root does.

## 3. Navigation

- `NavigationStack(path: $router.path)` with a typed `[Route]`.
- The router owns the path; a deep link appends validated routes.
- A screen never pushes by string; it appends a typed route.
- Restore the path on launch where the product requires it.

## 4. Lists and images

- `ForEach(rows, id: \.id)`; stable id; no `\.self` on a mutable value.
- `LazyVStack`/`List` for long content; avoid `AnyView`.
- Nuke/NukeUI with a downsampling processor; `AsyncImage` does not cache.
- A placeholder and an error state per image.

## 5. Effects and lifecycle

- `task { await model.refresh() }` for a keyed async load; it cancels when the
  view disappears or the id changes.
- `onChange(of:)` for a value transition; not for a load.
- `onDisappear`/`deinit` for cleanup; do not leak a stream consumer.
- One consumer for the effect stream.

## 6. Accessibility

- `Button` for actions; `accessibilityLabel`/`accessibilityHint` where the
  label is not obvious.
- Dynamic Type: no fixed font sizes that break at large sizes.
- VoiceOver: logical order, traits, focus after navigation.
- Reduce Motion: no essential information in an animation.

## 7. Localization

- String Catalogs; `String(localized:)`; no concatenated sentences.
- Numbers/dates via `FormatStyle`; RTL and long translations survive.

## 8. Testing

- Swift Testing for the model with fake use cases; `@MainActor` tests.
- XCTest/XCUITest for the critical journey and performance.
- Snapshot tests only where the maintenance is justified.
