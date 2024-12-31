// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-subfloor",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "Subfloor",
            targets: ["Subfloor"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-identified-collections",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-navigation",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "Subfloor",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "IdentifiedCollections",
                    package: "swift-identified-collections"
                ),
                .product(
                    name: "SwiftUINavigation",
                    package: "swift-navigation"
                ),
            ]
        ),
        .testTarget(
            name: "SubfloorTests",
            dependencies: ["Subfloor"]
        ),
    ]
)
