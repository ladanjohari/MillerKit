import Foundation

public var nullStream: AsyncStream<()> = AsyncStream { cont in
    cont.finish()
}

public func singletonStream<Elem>(_ elem: Elem) -> AsyncStream<Elem> {
    AsyncStream { cont in
        cont.yield(elem)
        cont.finish()
    }
}

public func numberStream() -> AsyncStream<Int> {
    AsyncStream { continuation in
        Task {
            // Generate numbers from 1 to 5 with a delay
            try await (1...5).parallelMap { number in
                try await randomDelay()
                continuation.yield(number) // Emit a value to the stream
            }
            continuation.finish() // End the stream
        }
    }
}

public func randomDelay() async throws {
    try await Task.sleep(nanoseconds: UInt64(4*500_000_000*Double.random(in: 0...1))) // Simulate delay
}
// Stream 2: Produces letters for each number
func itemStream(for number: Int) -> AsyncStream<LazyItem> {
    AsyncStream { continuation in
        Task {
            try await ["A", "B", "C"].parallelMap { char in
                try await randomDelay()
                continuation.yield(LazyItem("\(char) for \(number) \(Date.now)", subItems: { ctx in
                    let numberPlusOne = chainStreams(inputStream: numberStream(), pureTransform: { a in a * number })
                    return chainStreams(inputStream: numberPlusOne, transform: itemStream)
                }))
            }
            continuation.finish()
        }
    }
}

public func chainStreams<Input, Output>(
    inputStream: AsyncStream<Input>,
    pureTransform: @escaping (Input) async -> Output
) -> AsyncStream<Output> {
    AsyncStream { continuation in
        Task.detached {
            for await input in inputStream {
                let output = await pureTransform(input)
                continuation.yield(output)
            }
            continuation.finish()
        }
    }
}

public func chainStreams<Input, Output>(
    inputStream: AsyncStream<Input>,
    transform: @escaping (Input) async -> AsyncStream<Output>
) -> AsyncStream<Output> {
    AsyncStream { continuation in
        Task.detached {
            for await input in inputStream {
                let outputStream = await transform(input)
                for await output in outputStream {
                    continuation.yield(output) // Emit values from the second stream
                }
            }
            continuation.finish() // End the chained stream
        }
    }
}

public let exampleLazyItem: LazyItem = .init(
    "Greeting",
    subItems: { ctx in
        return chainStreams(inputStream: numberStream(), transform: itemStream)
    },
    attributes: { ctx in
        return .init(unfolding: {
            // .documentation(greetingBasedOnTime())
            nil
        })
    }
)
