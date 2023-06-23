import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "SignUp"

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
        .Project.PresentationLayer.SignUp,
        .Project.DesignKit,
        .Project.CoreLayer.Extensions,
        .Project.CoreLayer.Utils,
        .Project.DomainLayer.UseCase
      ]
    ),
    .createTestTarget(name: projectName)
  ]
)
