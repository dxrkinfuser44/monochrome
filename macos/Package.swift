// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "MonochromeMac",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MonochromeMac", targets: ["MonochromeMac"])
    ],
    targets: [
        .executableTarget(
            name: "MonochromeMac",
            path: "Sources"
        )
    ]
)
