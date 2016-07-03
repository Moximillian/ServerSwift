import PackageDescription

let package = Package(
    name: "ServerSwift",
    dependencies: [
      .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 12)
  ]
)
