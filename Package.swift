// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Navcoin",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Navcoin",
            targets: ["Navcoin"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/attaswift/BigInt.git",
            .upToNextMajor(from: "5.3.0")
        ),
        .package(
            url: "https://github.com/anquii/CryptoSwiftWrapper.git",
            .upToNextMajor(from: "1.4.3")
        )
    ],
    targets: [
        .target(
            name: "Navcoin",
            dependencies: [
                "BigInt",
                "CryptoSwiftWrapper"
            ]
        ),
        .testTarget(
            name: "NavcoinTests",
            dependencies: ["Navcoin"]
        )
    ]
)
