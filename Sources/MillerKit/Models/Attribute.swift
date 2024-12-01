import Foundation

public enum AttributeValue {
    case stringValue(String)
    case boolValue(Bool)
    case intValue(Int)
    case dateValue(Date)
    case timeIntervalValue(TimeInterval)

    var stringValue: String {
        switch self {
        case .stringValue(let str):
            return str
        case .boolValue(let bool):
            return "\(bool)"
        case .intValue(let int):
            return "\(int)"
        case .dateValue(let date):
            return "\(date)"
        case .timeIntervalValue(let ti):
            return "\(ti)"
        }
    }
}

public struct Attribute {
    let name: String
    let value: AttributeValue

    public static func prompt(_ prompt: String) -> Self {
        return .init(name: "prompt", value: .stringValue(prompt))
    }

    public static func documentation(_ doc: String) -> Self {
        return .init(name: "documentation", value: .stringValue(doc))
    }
}
