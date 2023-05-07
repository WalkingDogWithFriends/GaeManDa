import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.createProject(
    name: "Core",
    targets: [
        .createTarget(
            name: "Extensions",
            product: .framework,
            sources: ["Extensions/**"]
        )
    ]
)
