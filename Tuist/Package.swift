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
    "PerceptionCore": .framework,
  ]
)

#endif

let package = Package(
  name: "PIDA_iOS",
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.23.1"),
    .package(url: "https://github.com/swiftlang/swift-syntax", exact: "601.0.1"),
    .package(url: "https://github.com/navermaps/SPM-NMapsMap.git", exact: "3.23.0"),
    .package(url: "https://github.com/LottieFiles/dotlottie-ios", exact: "0.8.0"),
    .package(url: "https://github.com/firebase/firebase-ios-sdk", exact: "12.7.0"),
    .package(url: "https://github.com/mixpanel/mixpanel-swift", exact: "5.1.4")
  ]
)
