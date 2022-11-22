// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Hondana",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "hondana", targets: ["Hondana"]),
        .library(name: "HondanaKit", targets: ["HondanaKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/KS1019/AssertSwiftCLI", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        .executableTarget(
            name: "Hondana",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Files",
                "Extensions",
                "HondanaKit",
            ]
        ),
        .target(name: "HondanaKit",
                dependencies: [
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    "Files",
                    "Rainbow",
                    "SwiftyTextTable",
                    "Extensions",
                ]),
        .target(name: "Extensions", dependencies: ["Files"]),
        .testTarget(name: "HondanaTests", dependencies: ["Hondana", "AssertSwiftCLI"]),
        .testTarget(name: "HondanaKitTests", dependencies: ["HondanaKit", "AssertSwiftCLI", "Extensions"]),
        .testTarget(name: "ExtensionsTests", dependencies: ["Extensions"]),
    ]
)
