import SwiftUI
import AppKit


struct MouseWheelEventCatcher: NSViewRepresentable {
    let onScroll: (CGFloat) -> Void

    func makeNSView(context: Context) -> NSView {
        return EventCatchingView(onScroll: onScroll)
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

class EventCatchingView: NSView {
    let onScroll: (CGFloat) -> Void

    init(onScroll: @escaping (CGFloat) -> Void) {
        self.onScroll = onScroll
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func scrollWheel(with event: NSEvent) {
        onScroll(event.scrollingDeltaX) // Pass horizontal scroll delta
    }
}
