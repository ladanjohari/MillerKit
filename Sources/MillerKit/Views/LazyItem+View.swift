import SwiftUI

extension LazyItem {
    var viewDocumentation: some View {
        let stream = self.documentation()

        return RealtimeStreamView(stream: stream, content: { str in
            if let doc = str {
                if let doc {
                    Text(doc)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("")
            }
        })
    }
}
