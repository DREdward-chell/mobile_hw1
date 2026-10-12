// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NotesSwift",
    products: [
        .executable(name: "notes-swift", targets: ["Notes"])
    ],
    targets: [
        .executableTarget(name: "Notes")
    ]
)
