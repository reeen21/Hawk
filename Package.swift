// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hawk",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Hawk",
            targets: ["Hawk"]),
    ],
    targets: [
        .target(
            name: "Hawk"),
        .testTarget(
            name: "HawkTests",
            dependencies: ["Hawk"]
        ),
    ]
)
