public struct LineLocation: Equatable, Hashable, Codable {
    public let fromLine: Int
    public let fromIndex: Int
    public let toLine: Int
    public let toIndex: Int

    public init(fromLine: Int, fromIndex: Int, toLine: Int, toIndex: Int) {
        self.fromLine = fromLine
        self.fromIndex = fromIndex
        self.toLine = toLine
        self.toIndex = toIndex
    }
    
    public init(line: Int, column: Int) {
        self.fromLine = line
        self.fromIndex = column
        self.toLine = line+1
        self.toIndex = 0
    }
}
