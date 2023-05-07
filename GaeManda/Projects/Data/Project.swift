import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.createProject(
    name: "Data",
    targets: [
        .createTarget(
            name: "DTO",
            product: .framework,
            sources: ["DTO/Sources/**"],
            dependencies: [
                .Project.DomainLayer.Entity
            ]
        ),
        .createTarget(
            name: "DTOTest",
            product: .unitTests,
            sources: ["DTO/Tests/**"],
            dependencies: [
                .Project.DataLayer.DTO
            ]
        ),
        
        .createTarget(
            name: "RepositoryImp",
            product: .framework,
            sources: ["RepositoryImp/Sources/**"]
        ),
        .createTarget(
            name: "RepositoryImpTest",
            product: .unitTests,
            sources: ["RepositoryImp/Tests/**"],
            dependencies: [
                .Project.DataLayer.RepositoryImp,
                .Project.DomainLayer.Repository
            ]
        ),
    ]
)
