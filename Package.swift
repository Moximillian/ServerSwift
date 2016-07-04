import PackageDescription

let package = Package(
    name: "ServerSwift",
    dependencies: [
      .Package(url: "https://github.com/qutheory/vapor.git", majorVersion: 0, minor: 12) //,
      //.Package(url: "https://github.com/hkellaway/Gloss.git", majorVersion: 0, minor: 7)
  ]
)
