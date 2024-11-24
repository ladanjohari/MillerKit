import Foundation

public enum AttributeValue {
    case stringValue(String)
    case boolValue(Bool)
    case intValue(Int)
    case dateValue(Date)
    case timeIntervalValue(TimeInterval)
}

public struct Attribute {
    let name: String
    let value: AttributeValue

    static func documentation(_ doc: String) -> Self {
        return .init(name: "documentation", value: .stringValue(doc))
    }
}
