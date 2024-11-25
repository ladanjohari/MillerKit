import SwiftUI
import TSCUtility

public struct LazyListColumn: View {
    let columnIndex: Int
    let items_: ((Context) -> AsyncStream<LazyItem>)
    @State var items: [LazyItem] = []
    @Binding var selectedItem: LazyItem.ID?
    @Binding var selectionsPerColumn: [LazyItem?]

    public init(
        items: @escaping ((Context) -> AsyncStream<LazyItem>),
        selectedItem: Binding<LazyItem.ID?>,
        selectionsPerColumn: Binding<[LazyItem?]>,
        columnIndex: Int
    ) {
        self.items_ = items
        self.columnIndex = columnIndex
        self._selectionsPerColumn = selectionsPerColumn
        self._selectedItem = selectedItem
    }

    public var body: some View {
        VStack {
            let itemsWithIndex: [(offset: Int, element: LazyItem)] = items.enumerated().map { $0 }
            List(itemsWithIndex, id: \.element.id) { (offset, item) in
                item.body(offset: offset)
                .onTapGesture {
                    // Set the current item as selected
                    selectedItem = item.id

                    // Reset the selections for subsequent columns
                    for i in (columnIndex+1)..<selectionsPerColumn.count {
                        selectionsPerColumn[i] = nil
                    }

                    selectionsPerColumn[columnIndex] = item
                }
            }
        }.onAppear {
            Task.detached {
                for await item in items_(Context()) {
                    items.append(item)
                }
            }
        }
    }
}
