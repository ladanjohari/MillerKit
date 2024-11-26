import SwiftUI
import TSCUtility

extension LazyItem {
    func allChildren() -> AsyncStream<LazyItem> {
        AsyncStream { cont in
            Task {
                if let subItems = self.subItems {
                    for await subItem in subItems(Context()) {
                        cont.yield(subItem)
                        for await child in subItem.allChildren() {
                            cont.yield(child)
                        }
                    }
                }
                cont.finish()
            }
        }
    }

    var viewNumberOfChildren: some View {
        if let subItems = self.subItems {
            var i = 0
            let toBeCounted0 = subItems(Context())
            let toBeCounted1 = allChildren()
            
            let stream = chainStreams(inputStream: toBeCounted1, pureTransform: { input in
                i += 1
                return i
            })
            return RealtimeStreamView(
                stream: stream, content: { val in
                    if let val {
                        return Text("\(val)")
                    } else {
                        return Text("")
                    }
                })
        } else {
            return RealtimeStreamView(stream: singletonStream(0), content: { _ in Text("") })
        }
    }

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
