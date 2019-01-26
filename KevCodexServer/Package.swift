// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KevCodexServer",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
//        .package(url: "https://github.com/PerfectlySoft/Perfect-WebRedirects", from: "3.0.0"),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "5.0.0"),
        .package(url: "https://github.com/OpenKitten/MeowVapor.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "Run", dependencies: ["App"]),
        .target(name: "App", dependencies: ["MongoKitten", "Vapor", "MeowVapor", "Leaf"]),
//        .target(name: "LegacyApp", dependencies: ["PerfectHTTPServer", "PerfectWebRedirects", "MongoKitten"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
