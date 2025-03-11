// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    let packageSettings = PackageSettings(productTypes: [:])
#endif

let package = Package(
    name: "PIDA_iOS",
    dependencies: [
        .package(url: "https://docs.tuist.io/documentation/tuist/dependencies", exact: "1.18.0")
    ]
)
