import SwiftUI

/// A reusable SwiftUI view that listens to an `AsyncStream` and displays its items in real-time.
public struct RealtimeStreamView<Item: Identifiable, Content: View>: View {
    @State private var items: [Item] = [] // Holds the items emitted by the stream
    private let stream: AsyncStream<Item>
    private let content: (Item) -> Content

    public init(
        stream: AsyncStream<Item>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.stream = stream
        self.content = content
    }

    public var body: some View {
        List(items) { item in
            content(item)
        }
        .onAppear {
            Task.detached {
                for await item in stream {
                    items.append(item)
                }
            }
        }
    }
}