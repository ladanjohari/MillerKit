// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MillerKit",
    platforms: [.macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MillerKit",
            targets: ["MillerKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-llbuild2", branch: "main"),
        .package(url: "https://github.com/apple/swift-async-algorithms", branch: "main"),
        .package(url: "https://github.com/swiftlang/swift-testing", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MillerKit",
            dependencies: [
                .product(name: "llbuild2fx", package: "swift-llbuild2"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ]
        ),
        .testTarget(
            name: "MillerKitTests",
            dependencies: ["MillerKit", .product(name: "Testing", package: "swift-testing")]
        ),
        .executableTarget(
            name: "JSONBrowser",
            dependencies: ["MillerKit"]
        ),
        
    ]
)
