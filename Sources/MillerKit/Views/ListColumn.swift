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
            let itemsWithIndex: [(offset: Int, element: Item)] = items.sorted().enumerated().map { $0 }
            List(itemsWithIndex, id: \.element) { (offset, item) in
                VStack(alignment: .leading) {
                    HStack {
                        //Text(item.symbolKind.caps)
                        Text("\(numberToLetterSequence(offset+1))")
                            .font(.footnote)  // Smaller text size
                            .fontWeight(.bold)
                            .frame(minWidth: 15, minHeight: 15)  // Ensure perfect square
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(item.colorBasedOnChildren)
                            )
                            .foregroundColor(.white)

                        // let priorityStr: String = "(P\(item.priority)) "
                        let priorityStr = ""

                        Text("\(item.starred ? "🌟 " : "")\(priorityStr)\(item.name)")
                            .font(.headline)

                        Spacer()
                        HStack {
                            ForEach(item.assignedTo, id: \.self) { assignee in
                                Text("\(assignee)")
                                    .frame(minWidth: 15, minHeight: 15)
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(2)
                                    .foregroundStyle(.white.gradient)
                                    .background(RoundedRectangle(cornerRadius: 5).fill(.blue))
                            }
                        }

                        
                        Text("\(item.subItems?.count ?? 0)")
                    }

                    // Show documentation (if available)
                    if let documentation = item.documentation {
                        Text("\(documentation)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    if item.ancestors.count > 0 {
                        Text("\(item.ancestors.joined(separator: " → "))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
