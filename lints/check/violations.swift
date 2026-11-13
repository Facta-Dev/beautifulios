import Foundation

// Deliberate violations for the CI harness. Do not copy this file.

func forceUnwrapped(_ value: String?) -> String {
    value!  // force_unwrapping
}

func forceTried(_ body: () throws -> Void) {
    try! body()  // force_try
}

func longFunction(seed: Int) -> Int {  // function_body_length
    var total = seed
    total += 1
    total += 2
    total += 3
    total += 4
    total += 5
    total += 6
    total += 7
    total += 8
    total += 9
    total += 10
    total += 11
    total += 12
    total += 13
    total += 14
    total += 15
    total += 16
    total += 17
    total += 18
    total += 19
    total += 20
    total += 21
    total += 22
    total += 23
    total += 24
    total += 25
    total += 26
    total += 27
    total += 28
    total += 29
    total += 30
    return total
}

// TODO: implement this before shipping  (todo)
func pending() {}
