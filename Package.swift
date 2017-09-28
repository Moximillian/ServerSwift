// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "ServerSwift",
  dependencies: [
    .package(url: "https://github.com/vapor/vapor", from: "2.2.0")
  ],
  targets: [
    .target(name: "App", dependencies: ["Vapor"], path: ".", sources: ["Sources"])
  ],
  // "products: " -definition is implicit based on targets
  swiftLanguageVersions: [4]
)

