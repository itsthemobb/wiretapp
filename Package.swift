// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "Wiretapp",
    platforms: [
        .iOS(SupportedPlatform.IOSVersion.v13),
        .macOS(SupportedPlatform.MacOSVersion.v10_15),
        .tvOS(SupportedPlatform.TVOSVersion.v13),
        .watchOS(SupportedPlatform.WatchOSVersion.v6),
    ],
    products: [
        .library(
            name: "Wiretapp",
            targets: ["Wiretapp"]
        ),
        .library(
            name: "wiretappTest",
            targets: ["WiretappTest"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Wiretapp",
            dependencies: [],
            path: "Sources/wiretapp/"
        ),
        .target(
            name: "WiretappTest",
            dependencies: ["Wiretapp"],
            path: "Sources/wiretappTest/"
        ),
    ]
)
