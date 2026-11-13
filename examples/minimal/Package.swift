// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Minimal",
    platforms: [.macOS(.v15)],
    targets: [
        .target(name: "Minimal"),
        .testTarget(name: "MinimalTests", dependencies: ["Minimal"]),
    ]
)
