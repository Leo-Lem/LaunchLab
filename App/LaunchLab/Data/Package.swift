// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Data",
  defaultLocalization: "en",
  platforms: [.iOS(.v17)],
  products: [
    .library(
      name: "Data",
      targets: ["Data"]
    )
  ],
  dependencies: [
    .package(path: "LLExtensions"),
    .package(path: "Styleguide")
  ],
  targets: [
    .target(
      name: "Data",
      dependencies: [
        "LLExtensions",
        "Styleguide"
      ]
    )
  ]
)
