# beautifulios — Architecture Diagrams

Rendered with [Archify](https://github.com/tt-a1i/archify). Each entry is a standalone,
explorable HTML page (inline SVG, dark/light themes, live motion) paired with its source
JSON candidate. The set documents the native iOS architecture this repo teaches and
enforces: Swift 6 + SwiftUI written as code, a SwiftPM package graph cut into vertical
slices (Domain / Data / UI / App), unidirectional data flow with one closed state enum,
GRDB for the cache and the outbox, the Keychain for secrets, and the server as the only
authority — with `lints/`, the skills and the CI gates as the delivery mechanism.

| Diagram | Type | What it shows | JSON | HTML |
|---|---|---|---|---|
| c4-containers | architecture | Container view: the iPhone user → the app target (composition root, router, DI) → the feature packages (UI / Domain / Data) → GRDB and the Keychain as the device-local state, and the backend API as the authority — with the APNs push channel and the skills/lints contract as the framing layer | [json](c4-containers.json) | [html](c4-containers.html) |
| services-slices | architecture | Package topology: the app target, one feature slice, and the shared packages and platform, with the dependency walls named — no cross-feature imports, no UI framework in Domain, no feature code in Kernel/UICore — and the port table (SessionStore, TokenProvider, Navigator, InventoryRepository) with who declares and who implements each | [json](services-slices.architecture.json) | [html](services-slices.architecture.html) |
| auth-algorithm | workflow | The trust algorithm as gated steps: sign in with Apple, a passkey or OIDC + PKCE in `ASWebAuthenticationSession` → server token exchange → the token written to the Keychain → the `TokenProvider` port attaches it per request → refresh rotates it → a 403 becomes a rendered `.forbidden` state → sign out wipes the Keychain and the GRDB user data | [json](auth-algorithm.workflow.json) | [html](auth-algorithm.workflow.html) |
| outbox-algorithm | workflow | The offline outbox as gated steps: the mutation and its outbox row commit in one GRDB transaction with an idempotency key → three drain triggers (reconnect, foreground, background task) → the server commits and the row is deleted → a conflict comes back rejected visibly → an exhausted row lands in a dead-letter view | [json](outbox-algorithm.workflow.json) | [html](outbox-algorithm.workflow.html) |
| auth-sequence | sequence | The full sign-in and authorized-call chain across the screen, the `@MainActor @Observable` ViewModel, the identity provider, the backend API and the Keychain — code + PKCE verifier, token write, bearer per request, refresh rotation, the rendered `.forbidden` state and the sign-out wipe | [json](auth-sequence.sequence.json) | [html](auth-sequence.sequence.html) |
| outbox-sequence | sequence | The offline mutation and drain trace: `send(.archive(id))` → one transaction writing the local row and the outbox row → the optimistic state with rollback armed → the drain trigger reads a bounded batch → `POST` with the idempotency key → the row is deleted, or a 409 comes back rejected and visible | [json](outbox-sequence.sequence.json) | [html](outbox-sequence.sequence.html) |
| database-dataflow | dataflow | Where persistent and state data goes: the screen → the use case → the SDK, GRDB and Keychain adapters → GRDB (SQLite/WAL) for the cache and the outbox table, the Keychain for tokens and secrets → the backend API, with the drain path drawn as the dashed flow | [json](database-dataflow.dataflow.json) | [html](database-dataflow.dataflow.html) |
| runtime-lifecycle | lifecycle | App runtime states: lazy launch → compose (`AppEnvironment`, DI, router) → scene active → the load gate → ready, with the rendered empty/offline/forbidden/error branches, the background → drain → foreground loop, and the retry and reconnect recoveries | [json](runtime-lifecycle.lifecycle.json) | [html](runtime-lifecycle.lifecycle.html) |

Authored with Archify. The content is grounded in the README's architecture contract, the
digests the skills carry (`skills/ios-best-practices/references/ios-architecture.md`,
`ios.md`, `swiftui-patterns.md`, `swift-strict.md`), the worked review in
`examples/review-inventory.md` and the drop-in config in `lints/`.

The diagrams are conceptual and source-backed: every component, boundary and edge is
traceable to the README, the skills, the lints config or the example package. Two roles
are adapted to this repo's real mechanisms and carry no server counterpart — the **auth**
role is the iOS Keychain plus `ASWebAuthenticationSession` credential boundary rather
than a login service, and the **outbox** role is the client-side GRDB outbox table
drained by reconnect/foreground/background tasks rather than a transactional server
outbox. The **database** role is likewise local-first — GRDB (SQLite/WAL) plus the
Keychain and the backend API — with no separate cache server or message broker.
