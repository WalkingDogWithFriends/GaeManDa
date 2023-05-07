import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.createProject(
    name: "Domain",
    targets: [
        .createTarget(
            name: "Entity",
            product: .framework,
            sources: ["Entity/**"]
        ),
        
        .createTarget(
            name: "UseCaseImp",
            product: .staticLibrary,
            sources: ["UseCaseImp/Sources/**"],
            dependencies: [
                .Project.DataLayer.RepositoryImp
            ]
        ),
        .createTarget(
            name: "UseCaseTest",
            product: .unitTests,
            sources: ["UseCaseImp/Tests/**"],
            dependencies: [
                .Project.DomainLayer.UseCaseImp,
                .Project.DomainLayer.UseCase
            ]
        ),
        
        .createTarget(
            name: "UseCase",
            product: .framework,
            sources: ["Interfaces/UseCase/**"]
        ),
        .createTarget(
            name: "Repository",
            product: .framework,
            sources: ["Interfaces/Repository/**"]
        ),
    ]
)
