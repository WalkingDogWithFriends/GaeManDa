import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Settings"

let project = Project.createProject(
  name: projectName,
  targets: [
    .createIntefaceTarget(
      name: projectName,
      dependencies: [
        .Project.DomainLayer.Entity,
        .SPM.RIBs
      ]
    ),
    .createImplementationTarget(
      name: projectName,
      dependencies: [
        .Project.PresentationLayer.Settings,
        .Project.DesignKit,
        .Project.CoreLayer.Extensions,
        .Project.CoreLayer.Utils,
        .Project.DomainLayer.UseCase
      ]
    ),
    .createTestTarget(name: projectName)
  ]
)
