import ProjectDescription

let project = Project(
    name: "PIDA_iOS",
    targets: [
        .target(
            name: "PIDA_iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.PIDA-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["PIDA_iOS/Sources/**"],
            resources: ["PIDA_iOS/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "PIDA_iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.PIDA-iOSTests",
            infoPlist: .default,
            sources: ["PIDA_iOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "PIDA_iOS")]
        ),
    ]
)
