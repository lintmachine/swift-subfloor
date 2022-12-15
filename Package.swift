// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-subfloor",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "Subfloor",
            targets: ["Subfloor"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.47.2")),
        .package(
            url: "https://github.com/pointfreeco/swift-identified-collections",
            from: "0.5.0"
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
            ]
        ),
        .testTarget(
            name: "SubfloorTests",
            dependencies: ["Subfloor"]
        ),
    ]
)
