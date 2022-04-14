// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LoaderUI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "LoaderUI",
            targets: ["LoaderUI"]),
    ],
    targets: [
        .target(
            name: "LoaderUI",
            path: "Sources"
        ),
    ]
)
