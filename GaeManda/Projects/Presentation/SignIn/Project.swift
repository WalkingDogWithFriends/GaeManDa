import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "SignIn"

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
        .Project.PresentationLayer.SignIn,
        .Project.DesignKit,
        .Project.CoreLayer.Extensions,
        .Project.DomainLayer.UseCase
      ]
    ),
    .createTestTarget(name: projectName)
  ]
)

