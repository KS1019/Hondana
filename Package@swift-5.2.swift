// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hondana",
    products: [
        .executable(name: "hondana", targets: ["Commands"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/KS1019/AssertSwiftCLI", .upToNextMinor(from: "0.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "Commands",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Files",
                "Models",
                "Rainbow",
                "SwiftyTextTable",
                "Extensions",
            ]),
        .target(name: "Models"),
        .target(name: "Extensions"),
        .testTarget(
            name: "HondanaTests",
            dependencies: ["Commands", "AssertSwiftCLI"]),
        .testTarget(
            name: "ExtensionsTests",
            dependencies: ["Extensions"]),
    ]
)