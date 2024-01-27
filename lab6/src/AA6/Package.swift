// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AA6",
    products: [
        .executable(name: "AA6", targets: ["AA6"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KarthikRIyer/swiftplot.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "AA6",
            dependencies: [
                .product(name: "SwiftPlot", package: "swiftplot"),
                .product(name: "SVGRenderer", package: "swiftplot"),
                //.product(name: "AGGRenderer", package: "swiftplot")
            ])
    ]
)
