# A worked review: the inventory screen

The subject is a small SwiftUI inventory screen. It renders, it works on a
simulator, and it has five findings that a review must rank in a useful order.
The fixed version follows the contract in `ios-best-practices`.

## The module under review

```swift
// InventoryView.swift
struct InventoryView: View {
    @State private var rows: [InventoryRow] = []
    @State private var loading = true
    @State private var error = false

    var body: some View {
        Group {
            if loading {
                ProgressView()
            } else if error {
                Text("Error")
            } else {
                List(rows, id: \.self) { row in
                    Text(row.name)
                        .onTapGesture { archive(row.id) }
                }
            }
        }
        .task {
            do {
                rows = try await fetchRows()
                loading = false
            } catch {
                error = true
            }
        }
    }

    private func fetchRows() async throws -> [InventoryRow] {
        let token = UserDefaults.standard.string(forKey: "token")!
        // URLSession request with the token...
        return []
    }
}
```

## The report

### Verdict

The screen renders on a simulator and hides the offline, forbidden and empty
states. Not safe to ship; the view-owned network call is first because it is
the one every screen copies.

### Must fix

1. `InventoryView.swift:21` — the **view** calls the network and reads the
   token. Rule: *the view never talks to the network; the ViewModel calls a
   use case*. Fix: an `@MainActor @Observable` `InventoryModel` with a
   refresh use case; the view sends `.refresh`.
2. `InventoryView.swift:23` — `UserDefaults` holds a token and the force
   unwrap crashes on a fresh install. Rule: *tokens live in the Keychain; no
   force unwrap outside a proven invariant*. Fix: a `SecretStore` port backed
   by the Keychain, throwing a typed error.
3. `InventoryView.swift:4` — `loading`, `error` and `rows` can contradict each
   other; offline, forbidden and empty never render. Rule: *one closed state;
   every state is rendered*. Fix: a `State` enum and a `switch` that misses a
   case does not compile.
4. `InventoryView.swift:14` — `id: \.self` on a mutable value and a `Text`
   with `onTapGesture` as the action. Rule: *stable ids; an action is a
   `Button` with an accessible label*. Fix: `id: \.id` and a `Button`.
5. `InventoryView.swift:26` — a fire-and-forget `archive` with no idempotency
   key and no rollback. Rule: *a mutation uses the persisted outbox*. Fix: a
   GRDB outbox row drained on reconnect/foreground, with a visible rejection.

### Should fix

6. `InventoryView.swift:19` — the whole load runs in the view's `.task`;
   cancellation is not handled and a stale result can overwrite a newer one.
   Fix: the ViewModel owns the task and a request id.
7. `InventoryView.swift:16` — the image (in the full version) is loaded at
   full resolution. Fix: Nuke with a downsampling processor sized for the
   row.
8. `InventoryView.swift:13` — the list has no empty state. Fix: `case .empty`
   with a message and a refresh button.

### Waived gates

None. The diff does not touch the lint config, the tests, or the device
budgets.

## The fixed module

```swift
// InventoryModel.swift
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

```swift
// InventoryView.swift
@MainActor
struct InventoryView: View {
    @State private var model: InventoryModel

    var body: some View {
        Group {
            switch model.state {
            case .loading: ProgressView()
            case .empty:
                Button("No inventory yet. Refresh") { model.send(.refresh) }
            case .offline: Text("You are offline.")
            case .forbidden: Text("You do not have permission.")
            case .error: Button("Retry") { model.send(.refresh) }
            case .ready(let rows):
                List(rows, id: \.id) { row in
                    Text(row.name)
                    Button("Archive") { model.send(.archive(row.id)) }
                        .accessibilityLabel("Archive \(row.name)")
                }
            }
        }
        .task { await model.refresh() }
    }
}
```

## What changed, and why it matters

| Finding | The fixed version |
|---|---|
| View fetches and reads the token | `InventoryModel` calls a use case; a `SecretStore` port |
| Token in `UserDefaults`, force unwrap | Keychain + typed error |
| Three booleans, missing states | one closed `State`, every state rendered |
| `id: \.self`, tappable `Text` | `id: \.id`, `Button` with a label |
| Fire-and-forget archive | GRDB outbox with idempotency and rollback |
| View `.task` with no request id | the ViewModel owns the task and cancellation |

The review is short on purpose. Five Must-fix findings, each with a location,
a rule, and a fix, is a better review than twenty comments that repeat the
same contract in different words.
