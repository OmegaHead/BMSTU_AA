// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AA1",
    products: [
        .executable(name: "AA1", targets: ["AA1"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KarthikRIyer/swiftplot.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "AA1",
            dependencies: [
                .product(name: "SwiftPlot", package: "swiftplot"),
                .product(name: "SVGRenderer", package: "swiftplot"),])
    ]
)
