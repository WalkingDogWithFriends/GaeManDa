import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
  name: "Core",
  targets: [
    .createTarget(
      name: "Extensions",
      product: .framework,
      sources: ["Extensions/**"]
    ),
    .createTarget(
      name: "Utils",
      product: .framework,
      sources: ["Utils/**"],
      dependencies: [
        .SPM.RIBs
      ]
    )
  ]
)
