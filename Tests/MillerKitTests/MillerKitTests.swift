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
