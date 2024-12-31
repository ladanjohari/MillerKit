import Foundation
import llbuild2fx
import TSFCASFileTree
import TSCBasic
import CryptoKit

/*
public protocol SiteGeneratorDelegate {
    func itemToHTML(_: LazyItem) async throws -> String
    func summarizeGroup(_: [LazyItem]) async throws -> String
}

extension LazyItem {
    public func materializeBeautifulStaticHTMLSite(
        ctx: Context,
        siteGeneratorDelegate: SiteGeneratorDelegate
    ) async throws {
        print("[materializeBeautifulStaticHTMLSite] start")
        if let tree = try await self.toBeautifulStaticHTMLSite(ctx: ctx, siteGeneratorDelegate: siteGeneratorDelegate) {
            try await LLBCASFileTree.export(
                tree.id,
                from: ctx.db,
                to: AbsolutePath("/tmp/example.com"),
                stats: .init(),
                ctx
            ).get()
            print("[materializeBeautifulStaticHTMLSite] \(tree.id)")
        } else {
            print(":(")
        }
    }

    public func toBeautifulStaticHTMLSite(
        ctx: Context,
        siteGeneratorDelegate: SiteGeneratorDelegate
    ) async throws -> LLBCASFileTree? {
        let client = LLBCASFSClient(ctx.db)

        if let subItems {
            var trees: [LLBCASFileTree] = []
            for await page in try subItems(ctx) {
                print("[toBeautifulStaticHTMLSite] \(self.name) generating \(page)")
                if let tree = try await generagePage(page, ctx: ctx) {
                    trees.append(tree)
                }
                print("[toBeautifulStaticHTMLSite] done \(page)")
            }

            if let indexTree = try await generateIndex(ctx: ctx, siteGeneratorDelegate: siteGeneratorDelegate) {
                trees.append(indexTree)
            }

            if !trees.isEmpty {
                return try await LLBCASFileTree.merge(trees: trees, in: ctx.db, ctx).get()
            } else {
                return nil
            }
        }

        throw StringError("Subitems is nil for root tree")
    }

    func generateIndex(
        ctx: Context,
        siteGeneratorDelegate: SiteGeneratorDelegate
    ) async throws -> LLBCASFileTree? {
        var contents = ""
        let client = LLBCASFSClient(ctx.db)

        var tags: [String: [String]] = [:]

        if let subItems {
            var items: [LazyItem] = []

            for await post in subItems(ctx) {
                items.append(post)

                print("[tags] fetching tags for \(post.name)")
                for await ts in post.tags(ctx: ctx) {
                    print("[tags] found tags \(post.name): \(ts)")
                    tags[post.id] = ts
                    break
                }
            }

            let calendar = Calendar.current

            var dict: Dictionary<String, [LazyItem]> = [:]
            for item in items {
                for tag in tags[item.id] ?? [] {
                    dict[tag] = dict[tag, default: []] + [item]
                }
            }

//            let dict2: Dictionary<[Int], [LazyItem]> = Dictionary(grouping: items, by: {
//                if let createdAt = $0.staticCreatedAt() {
//                    let year = calendar.component(.year, from: createdAt)
//                    let month = calendar.component(.month, from: createdAt)
//                    return [year, month]
//                } else {
//                    return []
//                }
//            })

            let dict2: Dictionary<String, [LazyItem]> = Dictionary(grouping: items, by: {
                if let cat = $0.staticCategory() {
                    return cat
                } else {
                    return "No category"
                }
            })

            let extraContents_ = try await dict.parallelMap { group, items in
                let dateGroup = group
                let renderedItems = try await items.parallelMap { item in
                    (item, try await siteGeneratorDelegate.itemToHTML(item))
                }.sorted(by: { a, b in
                    a.0.staticCreatedAt() ?? Date.now < b.0.staticCreatedAt() ?? Date.now
                }).reversed().map(\.1).joined(separator: "\n")

//                return (group, "<div class='item'><div class=title><details><summary><li>\(dateGroup) (\(items.count))</li></summary><ul>\(renderedItems)</ul></details></div></div>")
                // return (group, "<div class='item'><div class=title><li>\(dateGroup) (\(items.count))</li><ul>\(renderedItems)</ul></div></div>")
                return (group, "\(dateGroup) (\(items.count)) <div class='item'><div class=title>\(renderedItems)</div></div>")
            }.sorted(by: { a, b in
                // (a.0).lexicographicallyPrecedes(b.0)
                dict[a.0, default: []].count < dict[b.0, default: []].count
            }).reversed()

            let extraContents = try await dict2.parallelMap { group, items in
                let dateGroup = group
                let renderedItems = try await items.parallelMap { item in
                    (item, try await siteGeneratorDelegate.itemToHTML(item))
                }.sorted(by: { a, b in
                    a.0.staticCreatedAt() ?? Date.now < b.0.staticCreatedAt() ?? Date.now
                }).reversed().map(\.1).joined(separator: "\n")

//                return (group, "<div class='item'><div class=title><details><summary><li>\(dateGroup) (\(items.count))</li></summary><ul>\(renderedItems)</ul></details></div></div>")
//                return (group, "<div class='item'><div class=title><li>\(dateGroup) (\(items.count))</li><ul>\(renderedItems)</ul></div></div>")

                return (group, "<details><summary><b>\(dateGroup)</b> (\(items.count)) <p>\((try? await siteGeneratorDelegate.summarizeGroup(items)) ?? "")</p></summary><div class='css-masonry css-nimasonry'>\(renderedItems)</div></details>")
            }.sorted(by: { a, b in
                 (a.0).lexicographicallyPrecedes(b.0)
            }).reversed()

            contents += extraContents.map(\.1).joined(separator: "\n")

            contents += "<hr />"
            Array(dict).sorted(by: { a, b in a.value.count > b.value.count }).map {
                if $0.value.count >= 1 {
                    contents += "<span style=\"\($0.value.count > 1 ? "font-weight: bold" : "")\">\($0.key) <span style='color: grey'>(\($0.value.count))</span></span> "
                }
            }
        }
        contents = html(withBody: contents, withCSS: """
#content {
width: 400px;
margin: auto;
}
.no-summary {
opacity: 0.3
}
.interesting-0 {
display: none
}
.interesting-1 {
display: none
}
pre {
    white-space: pre-wrap;
}
.item.nima.pinned {
    background: linear-gradient(to bottom, #FFD700, #FF4500);
}
""")

        let tree = try await client.storeDir(
            .directory(
                files: ["index.html": .file(contents: Array(contents.utf8))]
            ),
            ctx
        ).get()

        return tree
    }

    func html(withBody body: String, withCSS style: String) -> String {
        return """
<!DOCTYPE>
<html>
<head>
<meta charset="UTF-8">

<link rel="stylesheet" href="https://johari.me/grid.css">

<style type="text/css">
.tag {
    font-size: 0.8em;
    border-readius: 3px;
}

body {
  font-family: Helvetica Neue, Helvetica, Arial;
}

div#container {
  margin: 0 auto;
  max-width: 33em;
}

@media only screen and (min-width: 500px) {
  body {
    font-size: 1.2em;
  }
}

#videos {
  width: 100%;
  text-align: center;
}
</style>

<style>
\(style)
</style>
</head>

<body>
\(body)
</body>

</html>
"""
    }

    func generagePage(_ page: LazyItem, ctx: Context) async throws -> LLBCASFileTree? {
        print("[generagePage] generating \(page)")
        let client = LLBCASFSClient(ctx.db)

        if let subItems = page.subItems {
            var trees: [LLBCASFileTree] = []

            var bodies: [String] = []

            for await comment in subItems(ctx) {
                bodies.append(comment.name)
            }

            let contents = html(withBody: """
<div id="content">
<p><b>\(page.name)</b></p>

\(bodies.map { "<p>\($0)</p>" }.joined(separator: "\n"))
</div>
""", withCSS: """
#content {
width: 400px;
margin: auto;
}
""")
            let checksum = SHA256.hash(data: Data(page.name.utf8)).compactMap { String(format: "%02x", $0) }.joined()

            let tree = try await client.storeDir(
                .directory(
                    files: ["\(checksum).html": .file(contents: Array(contents.utf8))]
                ),
                ctx
            ).get()

            trees.append(tree)

            if !trees.isEmpty {
                return try await LLBCASFileTree.merge(trees: trees, in: ctx.db, ctx).get()
            } else {
                return nil
            }
        }
        return nil
    }
}
*/
