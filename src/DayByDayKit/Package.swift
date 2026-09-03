// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "DayByDayKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "DayByDayKit",
            targets: ["DayByDayKit"]
        )
    ],
    targets: [
        .target(
            name: "DayByDayKit"
        ),
        .testTarget(
            name: "DayByDayKitTests",
            dependencies: ["DayByDayKit"]
        )
    ],
    swiftLanguageModes: [.v6]
)
