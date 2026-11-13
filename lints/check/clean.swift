import Foundation

struct Counter: Equatable, Sendable {
    let value: Int
}

func increment(_ counter: Counter) -> Counter {
    Counter(value: counter.value + 1)
}

func describe(_ counter: Counter) -> String {
    counter.value == 0 ? "empty" : "ready"
}
