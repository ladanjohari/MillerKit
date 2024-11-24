import Foundation
import TSCUtility
import SwiftUI

public struct LazyItem: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let subItems: ((Context) -> AsyncStream<LazyItem>)?
    public let attributes: ((Context) -> AsyncStream<Attribute>)?

    public static func == (lhs: LazyItem, rhs: LazyItem) -> Bool {
        return lhs.id == rhs.id
    }

    init(
        _ name: String,
        subItems: ((Context) -> AsyncStream<LazyItem>)? = nil,
        attributes: ((Context) -> AsyncStream<Attribute>)? = nil
    ) {
        self.name = name
        self.subItems = subItems
        self.attributes = attributes
    }
}


extension LazyItem {
    func icon(offset: Int) -> some View {
        Text("\(numberToLetterSequence(offset+1))")
            .font(.footnote)  // Smaller text size
            .fontWeight(.bold)
            .frame(minWidth: 15, minHeight: 15)  // Ensure perfect square
            .background(
                RoundedRectangle(cornerRadius: 5)
            )
            .foregroundColor(.white)
    }

    func body(offset: Int) -> some View {
        VStack(alignment: .leading) {
            HStack {
                self.icon(offset: offset)

                // let priorityStr: String = "(P\(item.priority)) "
                let priorityStr = ""

                Text("\(self.name)")
                    .font(.headline)

                Spacer()
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
