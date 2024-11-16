import SwiftUI


public struct MillerView: View {
    
    @State private var selectedItems: [Item?] = Array(repeating: nil, count: 100)
    @State private var lastSelectedItem: Item? = nil  // Track the last selected item
    @Binding private var minedSymbols: [Item]
    @State private var totalColumns: Int = 6

    public init(minedSymbols: Binding<[Item]>) {
        self._minedSymbols = minedSymbols
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
            
            ForEach(1...9, id: \.self) { number in
                Button(action: {
                    handleCommandNumber(number)
                }) {
                    Text("\(number)")
                }
                .keyboardShortcut(KeyEquivalent(Character("\(number)")), modifiers: [.command])
                .hidden().frame(width: 0, height: 0)
            }
            
            Button(action: {
                if let firstChild = lastSelectedItem?.subItems?.first {
                    lastSelectedItem = firstChild
                    if let index = selectedItems.firstIndex(where: { $0 == nil }) {
                        selectedItems[index] = firstChild
                    }
                }
            }) {
                Text("Right buttom")
                
            }
            .keyboardShortcut(.rightArrow, modifiers: [])
            .hidden().frame(width: 0, height: 0)
            
            Button(action: {
                if let columnIndex = selectedItems.firstIndex(where: { $0 == lastSelectedItem }), columnIndex > 0 {
                    lastSelectedItem = selectedItems[columnIndex-1]
                    selectedItems = selectedItems.enumerated().map { myIndex, item in
                        if myIndex >= columnIndex {
                            return nil
                        } else {
                            return item
                        }
                    }
                }
            }) {
                Text("Left buttom")
            }
            .keyboardShortcut(.leftArrow, modifiers: [])
            .hidden().frame(width: 0, height: 0)
            
            Button(action: {
                if let columnIndex = selectedItems.firstIndex(where: { $0 == lastSelectedItem }) {
                    let parentColumnIndex = columnIndex - 1
                    let parent: Item
                    if columnIndex > 0 {
                        parent = selectedItems[parentColumnIndex]!
                    } else {
                        parent = Item("root", subItems: minedSymbols)
                    }
                    if let subItems = parent.subItems {
                        if let rowIndex = (parent.subItems ?? []).firstIndex(where: { $0 == lastSelectedItem }) {
                            if rowIndex == 0, let lastItem = subItems.last {
                                lastSelectedItem = lastItem
                            } else {
                                lastSelectedItem = subItems[rowIndex-1]
                            }
                            selectedItems[columnIndex] = lastSelectedItem
                        }
                    }
                }
            }) {
                Text("Up buttom")
            }
            .keyboardShortcut(.upArrow, modifiers: [])
            .hidden().frame(width: 0, height: 0)
            
            Button(action: {
                if let columnIndex = selectedItems.firstIndex(where: { $0 == lastSelectedItem }) {
                    let parentColumnIndex = columnIndex - 1
                    let parent: Item
                    if columnIndex > 0 {
                        parent = selectedItems[parentColumnIndex]!
                    } else {
                        parent = Item("root", subItems: minedSymbols)
                    }
                    if let subItems = parent.subItems {
                        if let rowIndex = (parent.subItems ?? []).firstIndex(where: { $0 == lastSelectedItem }) {
                            if rowIndex == subItems.count - 1, let firstItem = subItems.first {
                                lastSelectedItem = firstItem
                            } else {
                                lastSelectedItem = subItems[rowIndex+1]
                            }
                            selectedItems[columnIndex] = lastSelectedItem
                        }
                    }
                }
            }) {
                Text("Bottom buttom")
            }
            .keyboardShortcut(.downArrow, modifiers: [])
            .hidden().frame(width: 0, height: 0)
            
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    
                    ListColumn(
                        items: minedSymbols,
                        selectedItem: $selectedItems[0],
                        columnIndex: 0,
                        selectedItems: $selectedItems,
                        lastSelectedItem: $lastSelectedItem
                    ).frame(width: geometry.size.width / CGFloat(totalColumns))
                    
                    ForEach(1...totalColumns, id: \.self) { index in
                        let firstSelection = selectedItems[index-1]
                        let firstSubItems = firstSelection?.subItems ?? []
                        ListColumn(
                            items: firstSubItems,
                            selectedItem: $selectedItems[index],
                            columnIndex: index,
                            selectedItems: $selectedItems,
                            lastSelectedItem: $lastSelectedItem
                        ).frame(width: geometry.size.width / CGFloat(totalColumns))
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
