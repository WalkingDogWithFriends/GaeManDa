import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.createProject(
    name: "DesignKit",
    targets: [
        .createTarget(
            name: "DesignKit",
            product: .framework,
            resources: ["Resources/**"]
        )
    ]
)
