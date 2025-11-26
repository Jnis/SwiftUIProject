import ProjectDescription

let project = Project(
    name: "Demo",
    targets: [
        .target(
            name: "Demo",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Demo",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "DemoTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.DemoTests",
            infoPlist: .default,
            sources: ["Demo/Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Demo")
            ]
        ),
    ]
)
