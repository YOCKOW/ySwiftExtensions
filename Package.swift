// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ySwiftExtensions",
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(name: "ySwiftExtensions", type: .dynamic, targets: ["yExtensions", "yProtocols"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/YOCKOW/SwiftUnicodeSupplement.git", from: "0.5.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(name: "_yExtensions_support"),
    .target(name: "_yExtensionsTests_support", dependencies: ["_yExtensions_support"]),
    .target(name: "yExtensions", dependencies: ["SwiftUnicodeSupplement", "_yExtensions_support"]),
    .target(name: "yProtocols", dependencies: ["_yExtensions_support"]),
    .testTarget(name: "yExtensionsTests", dependencies: ["yExtensions", "_yExtensionsTests_support"]),
    .testTarget(name: "yProtocolsTests", dependencies: ["yProtocols", "_yExtensionsTests_support"]),
  ],
  swiftLanguageVersions: [.v4, .v4_2, .v5]
)

