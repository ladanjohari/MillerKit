import SwiftUI
import TSCUtility

public struct LazyMillerView: View {
    let ctx: Context
    @State var selectedItem: LazyItem.ID?
    @State var selectionsPerColumn: [LazyItem?] = Array(repeating: nil, count: 100)

    var showPrompt = true

    private var totalColumns: Int {
        max(selectionsPerColumn.prefix(while: { $0 != nil }).count+1, 4)
    }
    
    @State var root: LazyItem? = nil
    
    var rootStream: AsyncStream<LazyItem>

    static func traverse(path: [UInt], root: LazyItem, ctx: Context) async -> LazyItem? {
        if let head = path.first {
           if let subItems = root.subItems {
               var i = 0
               for await child in await subItems(ctx) {
                   if i == head {
                       return await traverse(path: Array(path.dropFirst()), root: child, ctx: ctx)
                   }
                   i += 1
               }
               return nil
           } else {
               return nil
           }
        } else {
            return root
        }
    }

    public init(rootStream: AsyncStream<LazyItem>,
                jumpTo path: [UInt],
                ctx: Context,
                showPrompt: Bool = true
    ) {
        self.rootStream = chainStreams(inputStream: rootStream, pureTransform: { item in
            await Self.traverse(path: path, root: item, ctx: ctx) ?? LazyItem("Path not found \(path)")
        })
        self.ctx = ctx
        self.showPrompt = showPrompt
    }
    
        //    func handleCommandNumber(_ number: Int) {
        //        totalColumns = number
        //    }
    
    public var body: some View {
        let x = VStack {
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
        x
    }


    var millerColumns: some View {
        return VStack(spacing: 0) {
            Text("📝")
            GeometryReader { geometry in
                // let desiredWidth = geometry.size.width / CGFloat(totalColumns)
                let desiredWidth = CGFloat(400)
                let s = ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        LazyListColumn(
                            ctx: ctx,
                            root: $root,
                            selectedItem: $selectedItem,
                            selectionsPerColumn: $selectionsPerColumn,
                            columnIndex: 0,
                            showPrompt: showPrompt
                        ).frame(width: desiredWidth).id("scroll-0")
                        
                        ForEach(Array(selectionsPerColumn.compactMap { $0 }.enumerated()), id: \.element.id) { index, selection in
                            Group {
                                if let firstSelection = selectionsPerColumn[index] {
                                    LazyListColumn(
                                        ctx: ctx,
                                        root: .constant(firstSelection),
                                        selectedItem: $selectedItem,
                                        selectionsPerColumn: $selectionsPerColumn,
                                        columnIndex: index+1,
                                        showPrompt: showPrompt
                                    ).frame(width: desiredWidth)
                                } else {
                                    Text("?")
                                }
                            }.id("scroll-\(index+1)")
                        }
                    }.frame(maxWidth: .infinity)
                }.scrollIndicators(.visible, axes: .horizontal)
                ScrollViewReader { scrollView in
                    s.onChange(of: selectionsPerColumn, {
                        withAnimation(.easeIn) {
                            let target = "scroll-\(selectionsPerColumn.prefix(while: { $0 != nil }).count)"
                            print("scrolling to \(target)")
                            scrollView.scrollTo(target, anchor: .leading)
                        }
                    })
//                    .overlay {
//                        MouseWheelEventCatcher { delta in
//                            if let current = selectionsPerColumn.firstIndex(where: { $0?.id == selectedItem }) {
//                                print(delta)
//                                if delta > 0 {
//                                    scrollView.scrollTo("scroll-\(current+1)")
//                                } else {
//                                    scrollView.scrollTo("scroll-\(current-1)")
//                                }
//                            }
//                        }
//                    }
                }.frame(maxWidth: geometry.size.width*5)
            }.frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
    }
}
