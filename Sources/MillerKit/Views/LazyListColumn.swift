import SwiftUI
import TSCUtility

struct LazyListColumn: View {
    let ctx: Context
    let columnIndex: Int
    @Binding var root: LazyItem?
    @State var items: [LazyItem] = []
    @Binding var selectedItem: String?
    @Binding var selectionsPerColumn: [LazyItem?]
    @State var itemsWithIndex = [(offset: 1, element: LazyItem("foo")), (offset: 2, element: LazyItem("bar"))]
    @State var prompt: String = ""

    public init(
        ctx: Context,
        root: Binding<LazyItem?>,
        selectedItem: Binding<LazyItem.ID?>,
        selectionsPerColumn: Binding<[LazyItem?]>,
        columnIndex: Int
    ) {
        self.ctx = ctx
        self._root = root
        self.columnIndex = columnIndex
        self._selectionsPerColumn = selectionsPerColumn
        self._selectedItem = selectedItem

        let candidatePrompt = root.wrappedValue?.prompt() ?? "..."
        self.prompt = candidatePrompt
    }

    private func getBackgroundColor(for item: LazyItem) -> Color {
        if item.urn == selectedItem {
            return Color.blue.opacity(0.5)  // Current selected item is blue
        } else if selectionsPerColumn.contains(where: { $0?.urn == item.urn }) {
            return Color.gray.opacity(0.3)
        } else if item.name.contains("♦️") {
            return Color.red.opacity(0.3)
        } else if item.name.contains("⚠️") {
            return Color.yellow.opacity(0.3)
        } else if item.name.contains("✅") || item.name.contains("🟩") {
            return Color.green.opacity(0.3)
        } else if item.name.contains("👎") {
            return Color.cyan.opacity(0.3)
        } else {
            return Color.white  // Unselected items are white
        }
    }

    func modifiedItem(_ item: LazyItem) -> LazyItem {
        let modifiedItem: LazyItem
        print("YYYY '\(self.prompt)'")
        if !self.prompt.isEmpty, let alternativeSubItems = item.alternativeSubItems {
            modifiedItem = LazyItem(item.name, subItems: { ctx in
                AsyncStream { cont in
                    Task {
                        do {
                            for await response in try await alternativeSubItems(item, prompt) {
                                cont.yield(response)
                            }
                        } catch {
                            cont.yield(LazyItem("\(error)"))
                        }
                        cont.finish()
                    }
                }
            }, staticAttributes: [.prompt(prompt)])
        } else {
            modifiedItem = item
        }
        return modifiedItem
    }

    public var body: some View {
        VStack {
            let itemsWithIndex2: [(offset: Int, element: LazyItem)] = items.enumerated().map { $0 }
            List(.constant(itemsWithIndex2), id: \.element.id, editActions: .move) { x in
                let (offset, item) = x.wrappedValue
                modifiedItem(item).body(offset: offset, ctx: ctx).background(getBackgroundColor(for: item))
                .onTapGesture {
                    // Set the current item as selected
                    selectedItem = item.urn

                    // Reset the selections for subsequent columns
                    for i in (columnIndex+1)..<selectionsPerColumn.count {
                        selectionsPerColumn[i] = nil
                    }

                    selectionsPerColumn[columnIndex] = modifiedItem(item)
                }
            }
            TextField("prompt", text: $prompt, axis: .vertical).lineLimit(5, reservesSpace: true)
        }.onChange(of: root) {
            Task {
                await fetchChildren()
            }
        }.onAppear {
            Task {
                await fetchChildren()
            }
        }
    }
    

    func fetchChildren() async {
        items = []
        if let root, let subItems = root.subItems {
            for await item in subItems(ctx) {
                items.append(modifiedItem(item))
            }
            items = items.sorted(by: { $0.staticPriority() < $1.staticPriority() })

            var parent = root
            print("Root for \(columnIndex) is \(root.name)")
            for i in (columnIndex..<selectionsPerColumn.count) {
                if let furtherSelection = selectionsPerColumn[i] {
                    print("Column \(i) has a selection \(furtherSelection.name)")
                    if let subItems = parent.subItems {
                        var found = false
                        for await item in subItems(ctx) {
                            if item.urn == furtherSelection.urn {
                                print("[MATCH] \(item.urn) == \(furtherSelection.urn)")
                                selectionsPerColumn[i] = item
                                parent = item
                                found = true
                                break
                            } else {
                                print("\(item.urn) does not match \(furtherSelection.urn)")
                            }
                        }
                        if !found {
                            selectionsPerColumn[i] = nil
                        }
                    }
                } else {
                    break
                }
            }
        }
    }
}
