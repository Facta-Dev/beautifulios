import Foundation
import Observation

public enum InventoryState: Equatable, Sendable {
    case loading
    case empty
    case ready([String])
    case error(String?)
}

@MainActor
@Observable
public final class InventoryModel {
    public private(set) var state: InventoryState = .loading

    public init() {}

    public func load(rows: [String]) {
        state = rows.isEmpty ? .empty : .ready(rows)
    }

    public func fail(correlationId: String?) {
        state = .error(correlationId)
    }
}
