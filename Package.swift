// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// It is impossible to write `#if os(macOS<13.0)`, so...

var targets: [Target] = [
  .target(
    name: "yExtensions",
    dependencies: [
      "SwiftRanges",
      "SwiftUnicodeSupplement",
      "yProtocols"
    ]
  ),
  .target(name: "yProtocols", dependencies: []),
  .target(name: "_yExtensionsTests_support", dependencies: []),
  .testTarget(
    name: "yExtensionsTests",
    dependencies: [
      "SwiftUnicodeSupplement",
      "yExtensions",
      "yProtocols",
      "_yExtensionsTests_support"
    ]
  ),
]

let urlTemporaryDirectoryAvailable: Bool = ({
  #if !canImport(Darwin) && swift(<99.99)
  return false
  #else
  if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
    return true
  }
  return false
  #endif
})()
if !urlTemporaryDirectoryAvailable {
  targets.append(.target(name: "URLTemporaryDirectory", dependencies:[]))
}

let package = Package(
  name: "yExtensions",
  platforms: [
    .macOS("10.15.4"), // Workaround for https://bugs.swift.org/browse/SR-13859
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(name: "ySwiftExtensions", type: .dynamic, targets: ["yExtensions", "yProtocols"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/YOCKOW/SwiftRanges.git", from: "3.1.0"),
    .package(url: "https://github.com/YOCKOW/SwiftUnicodeSupplement.git", from: "1.3.0"),
  ],
  targets: targets,
  swiftLanguageVersions: [.v5]
)

import Foundation
if ProcessInfo.processInfo.environment["YOCKOW_USE_LOCAL_PACKAGES"] != nil {
  func localPath(with url: String) -> String {
    guard let url = URL(string: url) else { fatalError("Unexpected URL.") }
    let dirName = url.deletingPathExtension().lastPathComponent
    return "../\(dirName)"
  }
  package.dependencies = package.dependencies.map {
    guard case .sourceControl(_, let location, _) = $0.kind else { fatalError("Unexpected dependency.") }
    return .package(path: localPath(with: location))
  }
}
