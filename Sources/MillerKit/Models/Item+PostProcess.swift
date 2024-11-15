extension Item {
    public func allItems() -> [Item] {
        return [self] + (self.subItems ?? []).flatMap { $0.allItems() }
    }

    public func match(assignee: String) -> [Item] {
        var res: [Item] = []
        if self.assignedTo.contains(assignee) {
            res.append(self)
        }

        let matchesFromChildren = (self.subItems ?? []).flatMap { $0.match(assignee: assignee) }
        res += matchesFromChildren

        return res
    }
}
