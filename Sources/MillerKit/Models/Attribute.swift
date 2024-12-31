import Foundation

public indirect enum AttributeValue {
    case stringValue(String)
    case boolValue(Bool)
    case intValue(Int)
    case dateValue(Date)
    case doubleValue(Double)
    case timeIntervalValue(TimeInterval)
    case listValue([AttributeValue])
    case jsonValue(String)

    public var jsonValue: String? {
        switch self {
        case .jsonValue(let json):
            return json
        default:
            return nil
        }
    }
    public var stringValue: String {
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
        case .doubleValue(let double):
            return "\(double)"
        case .listValue(let attrs):
            return "[\(attrs)]"
        case .jsonValue(let json):
            return "\(json)"
        }
    }
}

public struct Attribute {
    public let name: String
    public let value: AttributeValue

    public init(name: String, value: AttributeValue) {
        self.name = name
        self.value = value
    }

    public static func prompt(_ prompt: String) -> Self {
        return .init(name: "prompt", value: .stringValue(prompt))
    }

    public static func documentation(_ doc: String) -> Self {
        return .init(name: "documentation", value: .stringValue(doc))
    }
}
