import Testing
@testable import MillerKit

@Test func example() async throws {
    let item = LazyItem("My item", subItems: { ctx in
        AsyncStream { cont in
            cont.yield(LazyItem("child 1"))
            cont.yield(LazyItem("child 2"))
        }
    })
}

@Test func example2() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    #expect(numberToLetterSequence(0) == "a")
    #expect(numberToLetterSequence(28) == "ab")
    #expect(numberToLetterSequence(280) == "jt")
    #expect(numberToLetterSequence(158000) == "hyrx")
    #expect(numberToLetterSequence(-158000) == "a")
    #expect(numberToLetterSequence(-177777700) == "a")
}
