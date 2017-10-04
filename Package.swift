// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "ServerSwift",
  dependencies: [
    .package(url: "https://github.com/swift-server/http", .branch("develop"))
  ],
  targets: [
    .target(name: "ServerSwift", dependencies: ["HTTP"], path: ".", sources: ["Sources"])
  ],
  // "products: " -definition is implicit based on targets
  swiftLanguageVersions: [4]
)

