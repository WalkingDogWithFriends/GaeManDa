import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
  name: "Data",
  targets: [
    .createTarget(
      name: "DTO",
      product: .framework,
      sources: ["DTO/Sources/**"]
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
      name: "RepositoryImpl",
      product: .framework,
      sources: ["RepositoryImpl/Sources/**"],
      dependencies: [
        .Project.DomainLayer.Repository
      ]
    ),
    .createTarget(
      name: "RepositoryImplTest",
      product: .unitTests,
      sources: ["RepositoryImpl/Tests/**"],
      dependencies: [
        .Project.DataLayer.RepositoryImpl,
        .Project.DomainLayer.Repository
      ]
    )
  ]
)
