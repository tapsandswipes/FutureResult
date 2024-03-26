// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "FutureResult",
    products: [
        .library(name: "FutureResult", targets: ["FutureResult"]),
        .library(name: "FunctionComposition", targets: ["FunctionComposition"]),
        .library(name: "ResultExtras", targets: ["ResultExtras"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tapsandswipes/Chainable.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target( name: "FutureResult", dependencies: ["Chainable", "FunctionComposition", "ResultExtras"]),
        .target( name: "FunctionComposition"),
        .target( name: "ResultExtras", dependencies: ["Chainable", "FunctionComposition"]),
        .testTarget( name: "FutureResultTests", dependencies: ["FutureResult", "ResultExtras", "FunctionComposition"]),
    ]
)
