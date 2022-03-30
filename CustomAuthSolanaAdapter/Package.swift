// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomAuthSolanaAdapter",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CustomAuthSolanaAdapter",
            targets: ["CustomAuthSolanaAdapter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/torusresearch/customauth-swift-sdk", branch: "master"),
        .package(url: "https://github.com/torusresearch/fetch-node-details-swift.git", branch: "master"),
        .package(url: "https://github.com/ajamaica/Solana.Swift", branch: "master"),
        .package(url: "https://github.com/pebble8888/ed25519swift", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CustomAuthSolanaAdapter",
            dependencies: [
                .product(name: "CustomAuth", package: "customauth-swift-sdk"),
                .product(name: "Solana", package: "Solana.Swift"),
                "ed25519swift"
            ]
        )
    ]
)
