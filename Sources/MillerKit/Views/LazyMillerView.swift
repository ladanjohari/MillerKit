import SwiftUI
import TSCUtility

public struct LazyMillerView: View {
    @State var selectedItem: LazyItem.ID?
    @State var selectionsPerColumn: [LazyItem?] = [nil, nil, nil, nil, nil, nil, nil, nil]

    @State private var totalColumns: Int = 6

    @State var root: LazyItem

    public init(root: LazyItem) {
        self.root = root
        selectionsPerColumn[0] = root
    }

    func handleCommandNumber(_ number: Int) {
        totalColumns = number
    }
    
    public var body: some View {
        VStack {
            millerColumns
        }
    }
    
    var millerColumns: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    LazyListColumn(
                        items: root.subItems!,
                        selectedItem: $selectedItem,
                        selectionsPerColumn: $selectionsPerColumn,
                        columnIndex: 0
                    ).frame(width: geometry.size.width / CGFloat(totalColumns))

                    ForEach(Array(selectionsPerColumn.compactMap { $0 }.enumerated()), id: \.element.id) { index, selection in
                        if let firstSelection = selectionsPerColumn[index] {
                            LazyListColumn(
                                items: firstSelection.subItems ?? { ctx in .init(unfolding: { nil }) },
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
