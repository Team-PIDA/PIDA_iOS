// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings
    let packageSettings = PackageSettings(productTypes: [:])
#endif

let package = Package(
    name: "PIDA_iOS",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.18.0"),
        .package(url: "https://github.com/navermaps/SPM-NMapsMap.git", exact: "3.20.0")
    ]
)
