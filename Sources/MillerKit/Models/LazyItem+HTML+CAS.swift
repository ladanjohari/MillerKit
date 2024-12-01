import Foundation
import llbuild2fx
import TSFCASFileTree
import TSCBasic
import CryptoKit

extension LazyItem {
    public func materializeBeautifulStaticHTMLSite(ctx: Context) async throws {
        print("[materializeBeautifulStaticHTMLSite] start")
        if let tree = try await self.toBeautifulStaticHTMLSite(ctx: ctx) {
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

    public func toBeautifulStaticHTMLSite(ctx: Context) async throws -> LLBCASFileTree? {
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

            if let indexTree = try await generateIndex(ctx: ctx) {
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

    func generateIndex(ctx: Context) async throws -> LLBCASFileTree? {
        var contents = ""
        let client = LLBCASFSClient(ctx.db)

        if let subItems {
            for await post in subItems(ctx) {
                contents += """
<li>\(post.name)</li>
"""
            }
        }
        contents = html(withBody: contents)

        let tree = try await client.storeDir(
            .directory(
                files: ["index.html": .file(contents: Array(contents.utf8))]
            ),
            ctx
        ).get()

        return tree
    }

    func html(withBody body: String) -> String {
        return """
<!DOCTYPE>
<html dir="rtl">
<head>
<meta charset="UTF-8">
<style>
#content {
width: 400px;
margin: auto;
}
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
