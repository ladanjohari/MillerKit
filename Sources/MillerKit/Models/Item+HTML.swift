extension Item {
    public func toHtml0() -> String {
        let head = """
<head>
    <style>
    .priority-0 {
        font-weight: bold;
        background-color: pink;
    }
    td {
        vertical-align: top;
        min-width: 400px;
        width: 400px;
    }
    .documentation {
        color: grey;
    }
    </style>
  <meta charset="UTF-8">
</head>
"""
        return """
<div class='item'>
\(head)<h1>\(name): \(documentation ?? "")</h1><table border=1><tr>\((subItems ?? []).map { subItem in subItem.toHtml1() }.joined(separator: "\n"))</tr></table>
</div>
"""
    }

    public func toHtml1() -> String {
        return "<td>\(name): \(documentation ?? "") \((subItems ?? []).map { subItem in subItem.toHtml2() }.joined(separator: "\n"))</td>"
    }

    public func toHtml2() -> String {
        var nameAndDoc = "<span class=\"priority-\(priority)\">(\(name)) <em class=documentation>\(documentation ?? "")</em></span>"
        if starred {
            nameAndDoc = "<b>\(nameAndDoc)</b>"
        }
        if let subItems, subItems.count > 0 {
            return "\(nameAndDoc) <br /> \((subItems ?? []).map { subItem in subItem.toHtml2() }.joined(separator: "\n"))"
        } else {
            return "\(nameAndDoc)"
        }
    }
}
