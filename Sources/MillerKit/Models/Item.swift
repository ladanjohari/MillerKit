import Foundation
import SwiftUI
import TSCUtility

public enum Status: Equatable, Hashable, Codable {
    case todo
    case planning
    case doing
    case done
    case paused
    case cancelled
    case blocked(on: String)
}




extension Item {
    func icon(offset: Int) -> some View {
        Text("\(numberToLetterSequence(offset+1))")
            .font(.footnote)  // Smaller text size
            .fontWeight(.bold)
            .frame(minWidth: 15, minHeight: 15)  // Ensure perfect square
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(self.colorBasedOnChildren)
            )
            .foregroundColor(.white)
    }

    func body(offset: Int) -> some View {
        VStack(alignment: .leading) {
            HStack {
                self.icon(offset: offset)

                // let priorityStr: String = "(P\(item.priority)) "
                let priorityStr = ""

                Text("\(self.starred ? "🌟 " : "")\(priorityStr)\(self.name)")
                    .font(.headline)

                Spacer()
                HStack {
                    ForEach(self.assignedTo, id: \.self) { assignee in
                        Text("\(assignee)")
                            .frame(minWidth: 15, minHeight: 15)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding(2)
                            .foregroundStyle(.white.gradient)
                            .background(RoundedRectangle(cornerRadius: 5).fill(.blue))
                    }
                }

                
                Text("\(self.subItems?.count ?? 0)")
            }

            // Show documentation (if available)
            if let documentation = self.documentation {
                Text("\(documentation)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            if self.ancestors.count > 0 {
                Text("\(self.ancestors.joined(separator: " → "))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

public struct Item: Identifiable, Hashable, Equatable, Comparable, Codable {
    public let id = UUID()
    public let name: String
    public let status: Status?
    public let subItems: [Item]?
    public let symbolKind: SymbolKind
    public let filePath: String
    public let lineLocation: LineLocation?
    public let documentation: String?
    public let tags: [String]
    public let priority: UInt
    public let assignedTo: [String]
    public let ancestors: [String]

    public init(
        _ name: String,
        priority: UInt = 4,
        status: Status? = nil,
        assignedTo: [String] = [],
        subItems: [Item]? = nil,
        symbolKind: SymbolKind = .unknown(""),
        filePath: String = "",
        lineLocation: LineLocation? = nil,
        documentation: String? = nil,
        tags: [String] = [],
        ancestors: [String] = []
    ) {
        self.name = name
        self.subItems = subItems
        self.symbolKind = symbolKind
        self.filePath = filePath
        self.lineLocation = lineLocation
        self.documentation = documentation
        self.tags = tags
        self.priority = priority
        self.status = status
        self.assignedTo = assignedTo
        self.ancestors = ancestors
        // Make sure to update withAncestors if you add new fields
    }

    public func stampAncestors(_ ancestors: [String]) -> Item {
        return Item(
            self.name,
            priority: self.priority,
            status: self.status,
            assignedTo: self.assignedTo,
            subItems: (self.subItems ?? []).map { $0.stampAncestors(ancestors + [self.name])},
            symbolKind: self.symbolKind,
            filePath: self.filePath,
            lineLocation: self.lineLocation,
            documentation: self.documentation,
            tags: self.tags,
            ancestors: ancestors
        )
    }

    var starred: Bool {
        tags.contains("starred")
    }
    
    var colorBasedOnChildren: Color {
        if let subItems {
            if subItems.count == 0 {
                return Color.gray
            } else if subItems.count == 1 {
                return Color.yellow
            } else if subItems.count == 2 {
                return Color.blue
            } else if subItems.count == 3 {
                return Color.green
            } else if subItems.count == 4 {
                return Color.orange
            } else if subItems.count >= 5 {
                return Color.red
            }
        }
        return Color.gray
    }
    
    public var source: String? {
        return try? String(contentsOf: URL(fileURLWithPath: self.filePath))
    }
    
    public static func < (lhs: Item, rhs: Item) -> Bool {
        lhs.priority < rhs.priority
    }
}

