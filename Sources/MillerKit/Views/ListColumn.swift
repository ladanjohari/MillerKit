import SwiftUI

func numberToLetterSequence(_ number: Int) -> String {
    var result = ""
    var num = number
    
    while num > 0 {
        // Calculate the character for the current "digit"
        num -= 1  // Adjust for 0-based indexing
        let remainder = num % 26
        let char = Character(UnicodeScalar(remainder + Int(("a" as UnicodeScalar).value))!)
        result = String(char) + result
        num /= 26
    }
    
    return result.isEmpty ? "a" : result
}

public struct ListColumn: View {
    let items: [Item]
    @Binding var selectedItem: Item?
    let columnIndex: Int
    @Binding var selectedItems: [Item?]
    @Binding var lastSelectedItem: Item?

    public init(
        items: [Item],
        selectedItem: Binding<Item?>,
        columnIndex: Int,
        selectedItems: Binding<[Item?]>,
        lastSelectedItem: Binding<Item?>
    ) {
        self.items = items
        self._selectedItem = selectedItem
        self.columnIndex = columnIndex
        self._selectedItems = selectedItems
        self._lastSelectedItem = lastSelectedItem
    }

    public var body: some View {
        VStack {
            let itemsWithIndex: [(offset: Int, element: Item)] = items.enumerated().map { $0 }
            List(itemsWithIndex, id: \.element) { (offset, item) in
                item.body(offset: offset)
                .background(getBackgroundColor(for: item))
                .onTapGesture {
                    // Set the current item as selected
                    selectedItem = item
                    lastSelectedItem = item
                    
                    // Reset the selections for subsequent columns
                    for i in (columnIndex + 1)..<selectedItems.count {
                        selectedItems[i] = nil
                    }
                }
            }
        }
    }

    // Determine the background color for each item
    private func getBackgroundColor(for item: Item) -> Color {
        if item.id == lastSelectedItem?.id {
            return Color.blue.opacity(0.5)  // Current selected item is blue
        } else if selectedItems.contains(where: { $0?.id == item.id }) {
            return Color.gray.opacity(0.3)
        } else if item.starred {
            return Color.yellow.opacity(0.3)
        } else if item.status == .done {
            return Color.green.opacity(0.3)
        } else if item.status == .paused {
            return Color.brown.opacity(0.3)
        } else if item.status == .doing {
            return Color.purple.opacity(0.3)
        } else {
            return Color.white  // Unselected items are white
        }
    }
}
