// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package,
// containing a Swift Package Manager project
// that will use the Skip build plugin to transpile the
// Swift Package, Sources, and Tests into an
// Android Gradle Project with Kotlin sources and JUnit tests.
import PackageDescription
import Foundation

// Set SKIP_ZERO=1 to build without Skip libraries
let zero = ProcessInfo.processInfo.environment["SKIP_ZERO"] != nil
let skipstone = !zero ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []

let package = Package(
    name: "skipapp-scrumdinger",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "ScrumDingerApp", type: .dynamic, targets: ["ScrumDinger"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.8.37"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.0.0"),
        .package(url: "https://source.skip.tools/skip-av.git", from: "0.0.2")
    ],
    targets: [
        .target(name: "ScrumDinger", dependencies: (zero ? [] : [
            .product(name: "SkipUI", package: "skip-ui"),
            .product(name: "SkipAV", package: "skip-av")
        ]), resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "ScrumDingerTests", dependencies: ["ScrumDinger"] + (zero ? [] : [
            .product(name: "SkipTest", package: "skip")]
        ), resources: [.process("Resources")], plugins: skipstone),
    ]
)
