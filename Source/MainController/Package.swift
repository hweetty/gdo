// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "gdo",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "1.1.0"),
    ],
    targets: [
        .target(name: "gdo", dependencies: ["SwiftyGPIO"]),
    ]
)
