// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Navcoin",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "Navcoin", targets: ["Navcoin"])
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", exact: "5.3.0"),
        .package(url: "https://github.com/anquii/BigIntExtensions.git", exact: "0.1.0"),
        .package(url: "https://github.com/anquii/BinaryExtensions.git", exact: "0.1.1"),
        .package(url: "https://github.com/anquii/BLSCT.git", branch: "release/v0.2.0")
    ],
    targets: [
        .target(name: "Navcoin", dependencies: ["BigInt", "BigIntExtensions", "BinaryExtensions", "BLSCT"]),
        .testTarget(name: "NavcoinTests", dependencies: ["Navcoin"])
    ]
)
