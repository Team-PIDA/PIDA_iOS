// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings
let packageSettings = PackageSettings(
  productTypes: [
    "ComposableArchitecture": .framework,
    "Dependencies": .framework,
    "Clocks": .framework,
    "ConcurrencyExtras": .framework,
    "CombineSchedulers": .framework,
    "IdentifiedCollections": .framework,
    "OrderedCollections": .framework,
    "_CollectionsUtilities": .framework,
    "DependenciesMacros": .framework,
    "SwiftUINavigationCore": .framework,
    "Perception": .framework,
    "IssueReporting": .framework,
    "CasePaths": .framework,
    "CustomDump": .framework,
    "XCTestDynamicOverlay": .framework,
    "PerceptionCore": .framework
  ]
)

#endif

let package = Package(
  name: "PIDA_iOS",
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.18.0"),
    .package(url: "https://github.com/navermaps/SPM-NMapsMap.git", exact: "3.20.0"),
    .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "4.5.0"),
  ]
)
