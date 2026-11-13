import Testing
@testable import Minimal

@MainActor
struct InventoryModelTests {
    @Test
    func emptyListBecomesEmptyState() {
        let model = InventoryModel()

        model.load(rows: [])

        #expect(model.state == .empty)
    }

    @Test
    func rowsBecomeReadyState() {
        let model = InventoryModel()

        model.load(rows: ["first", "second"])

        #expect(model.state == .ready(["first", "second"]))
    }

    @Test
    func failureKeepsTheCorrelationId() {
        let model = InventoryModel()

        model.fail(correlationId: "c_01")

        #expect(model.state == .error("c_01"))
    }
}
