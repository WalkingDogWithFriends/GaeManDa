import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "DogsOnAround"

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
        .Project.PresentationLayer.DogsOnAround,
        .Project.DesignKit,
        .Project.CoreLayer.Extensions,
        .Project.DomainLayer.UseCase
      ]
    ),
    .createTestTarget(name: projectName)
  ]
)
