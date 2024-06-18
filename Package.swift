// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "URLConfig",
  platforms: [
    .iOS(.v15),
    .tvOS(.v15),
    .macOS(.v12),
    .watchOS(.v8)
  ],

  products: [
    .library(name: "URLConfig", targets: ["URLConfig"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.1.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "URLConfig",
      dependencies: [
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types")
      ],
      path: "Sources"),
    .testTarget(
      name: "Tests",
      dependencies: ["URLConfig"],
      path: "Tests")
  ]
)
