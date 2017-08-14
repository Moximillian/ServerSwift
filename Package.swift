import PackageDescription

let package = Package(
    name: "ServerSwift",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2, minor: 2)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

