import SwiftUI

public enum SymbolKind: Hashable, Codable {
    case `class`
    case `struct`
    case `function`
    case target
    case `enum`
    case `enumCase`
    case `protocol`
    case method
    case property
    case unknown(String)
    case workspace
    case package

    case characteristic
    case tree
    case event
    case place
    case historical
    case topic


    case file
    case codeBlock
    case codeBlockList
    case variable

    public var caps: String {
        switch self {
        case .target:
            "T"
        case .class:
            "C"
        case .struct:
            "S"
        case .enum:
            "E"
        case .enumCase:
            "e"
        case .protocol:
            "P"
        case .method:
            "M"
        case .property:
            "P"
        case .package:
            "P"
        case .unknown(let str):
            "? \(str)"
        case .workspace:
            "W"
        case .tree:
            "T"
        case .characteristic:
            "C"
        case .event:
            "E"
        case .historical:
            "H"
        case .place:
            "P"
        case .topic:
            "T"
        case .file:
            "F"
        case .codeBlock:
            "{}"
        case .codeBlockList:
            "[{}]"
        case .variable:
            "V"
        case .function:
            "f"
        }
    }

    var color: Color {
        switch self {
        case .target:
            .blue
        case .class:
            .yellow
        case .struct:
            .orange
        case .enum:
            .black
        case .protocol:
            .purple
        case .method:
            .indigo
        case .property:
            .cyan
        case .enumCase:
            .green
        case .package:
            .orange
        case .workspace:
            .purple
        case _:
            .red
        }
    }
}
