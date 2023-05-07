import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "DogsOnAround"

let project = Project.createPresentationProject(
    name: projectName,
    implementationDependencies: [
        .SPM.RIBs,
        .Project.CoreLayer.Extensions,
        .Project.DomainLayer.Entity,
        .Project.DomainLayer.Repository,
        .Project.DesignKit
    ],
    interfaceDependencies: [
        .SPM.RIBs,
        .Project.DomainLayer.Entity
    ]
)
