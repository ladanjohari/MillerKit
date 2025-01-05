import Foundation
import TSCUtility
import SwiftUI

// MARK: LayzItem

public struct LazyItem: Identifiable, Equatable {
    public let id: String
    public let urn: String?
    public let name: String
    public let subItems: ((Context) -> AsyncStream<LazyItem>)?
    public let attributes: ((Context) -> AsyncStream<Attribute>)?
    public let staticAttributes: [Attribute]
    var alternativeSubItems: ((LazyItem, String) async throws  -> AsyncStream<LazyItem>)?

    public static func == (lhs: LazyItem, rhs: LazyItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

    public func withURN(_ urn: String) -> LazyItem {
        return LazyItem(name, urn: urn, subItems: subItems, attributes: attributes)
    }

    public init(
        _ name: String,
        urn: String? = nil,
        subItems: ((Context) -> AsyncStream<LazyItem>)? = nil,
        attributes: ((Context) -> AsyncStream<Attribute>)? = nil,
        staticAttributes: [Attribute] = [],
        alternativeSubItems: ((LazyItem, String) async throws  -> AsyncStream<LazyItem>)? = nil
    ) {
        self.name = name
        self.subItems = subItems
        self.attributes = attributes
        self.id = UUID().uuidString
        self.urn = urn
        self.staticAttributes = staticAttributes
        self.alternativeSubItems = alternativeSubItems
    }

    public func prompt() -> String? {
        for attr in staticAttributes {
            if attr.name == "prompt" {
                return attr.value.stringValue
            }
        }
        return nil
    }

    // MARK: tags
    public func tags(ctx: Context) -> AsyncStream<[String]> {
        AsyncStream { cont in
            Task {
                if let attributes {
                    for await doc in attributes(ctx) {
                        print(doc)
                        if doc.name == "tags" {
                            switch doc.value {
                            case .listValue(let el):
                                cont.yield(el.map { $0.stringValue })
                            default:
                                cont.yield([])
                            }
                        }
                    }
                    cont.yield([])
                    cont.finish()
                } else {
                    cont.yield([])
                    cont.finish()
                }
            }
        }
    }

    // MARK: documentation
    public func documentation(ctx: Context) -> AsyncStream<String?> {
        AsyncStream { cont in
            Task {
                cont.yield(nil)
                if let attributes {
                    for await doc in attributes(ctx) {
                        if doc.name == "documentation" {
                            switch doc.value {
                            case .stringValue(let str):
                                cont.yield(str)
                            default:
                                cont.yield("\(doc)")
                            }
                        }
                    }
                } else {
                    cont.finish()
                }
            }
        }
    }

    public func staticCreatedAt() -> Date? {
        if let createdAt = staticAttributes.first(where: { $0.name == "createdAt" })?.value {
            switch createdAt {
            case .dateValue(let date):
                return date
            default: return nil
            }
        } else {
            return nil
        }
    }

    public func staticCategory() -> String? {
        if let category = staticAttributes.first(where: { $0.name == "category" })?.value {
            switch category {
            case .stringValue(let cat):
                return cat
            default: return nil
            }
        } else {
            return nil
        }
    }

    // MARK: Extract priority from name
    public func staticPriority() -> Int {
        staticPriority_().first ?? 999
    }

    public func staticPriority_() -> [Int] {
        let input = self.name
        if input.contains("🪴") {
            return [0]
        }

        // Define the regex pattern to match `(P1)`, `(P2)`, etc.
        let pattern = #"\(P(\d+)\)"#
        
        // Create a regular expression instance
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        
        // Find matches in the input string
        let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        
        // Extract numbers from matches
        return matches.compactMap { match in
            if let range = Range(match.range(at: 1), in: input) {
                return Int(input[range])
            }
            return nil
        }
    }
}

// MARK: LayzItem.iconSquare

extension LazyItem {
    func iconSquare(_ text: String) -> some View {
        Text(text)
            .font(.footnote)  // Smaller text size
            .fontWeight(.bold)
            .frame(minWidth: 15, minHeight: 15)  // Ensure perfect square
            .background(
                RoundedRectangle(cornerRadius: 5).fill(.purple)
            )
    }

    func icon(offset: Int) -> some View {
        iconSquare(numberToLetterSequence(offset+1))
    }

    func body(offset: Int, ctx: Context) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if !self.name.isEmpty {
                    self.icon(offset: offset)
                    
                        // let priorityStr: String = "(P\(item.priority)) "
                    let priorityStr = ""
                    
                    
                    Text("\(self.name)")
                        .font(.headline)
                }
                Spacer()
                // viewNumberOfChildren
            }
            viewDocumentation(ctx: ctx)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
