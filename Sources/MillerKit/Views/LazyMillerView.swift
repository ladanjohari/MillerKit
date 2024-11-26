import SwiftUI
import TSCUtility

public struct LazyMillerView: View {
    @State var selectedItem: LazyItem.ID?
    @State var selectionsPerColumn: [LazyItem?] = [nil, nil, nil, nil, nil, nil, nil, nil]

    @State private var totalColumns: Int = 6

    @State var root: LazyItem? = nil

    var rootStream: AsyncStream<LazyItem>

    public init(rootStream: AsyncStream<LazyItem>) {
        self.rootStream = rootStream
    }

    func handleCommandNumber(_ number: Int) {
        totalColumns = number
    }
    
    public var body: some View {
        VStack {
            if let root {
                millerColumns
            } else {
                Text("...")
            }
        }.task {
            Task {
                for await root_ in rootStream {
                    print("Hello world \(root_.id)")
                    root = root_
                }
            }
        }
    }

    var millerColumns: some View {
        return VStack(spacing: 0) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    LazyListColumn(
                        root: $root,
                        selectedItem: $selectedItem,
                        selectionsPerColumn: $selectionsPerColumn,
                        columnIndex: 0
                    ).frame(width: geometry.size.width / CGFloat(totalColumns))

                    ForEach(Array(selectionsPerColumn.compactMap { $0 }.enumerated()), id: \.element.id) { index, selection in
                        if let firstSelection = selectionsPerColumn[index] {
                            LazyListColumn(
                                root: .constant(firstSelection),
                                selectedItem: $selectedItem,
                                selectionsPerColumn: $selectionsPerColumn,
                                columnIndex: index+1
                            ).frame(width: geometry.size.width / CGFloat(totalColumns))
                        } else {
                            Text("?")
                        }
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)   
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
