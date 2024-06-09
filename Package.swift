// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "NativeNetwork",
  platforms: [
    .iOS(.v14),
    .tvOS(.v15),
    .macOS(.v12),
    .watchOS(.v8)
  ],

  products: [
    .library(name: "NativeNetwork", targets: ["NativeNetwork"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.1.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "NativeNetwork",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types")
      ],
      path: "Sources"),
    .testTarget(
      name: "NativeNetworkTests",
      dependencies: ["NativeNetwork"],
      path: "Tests")
  ]
)
