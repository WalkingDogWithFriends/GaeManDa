import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Data",
	targets: [
		.createTarget(
			name: "DTO",
			product: .staticLibrary,
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
			name: "RepositoryImpl",
			product: .staticLibrary,
			sources: ["RepositoryImpl/Sources/**"],
			dependencies: [
				.Project.DataLayer.DTO,
				.Project.DomainLayer.Repository,
				.Project.DataLayer.GMDNetwork
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
		),
		.createTarget(
			name: "GMDNetwork",
			product: .staticLibrary,
			sources: ["GMDNetwork/**"],
			dependencies: [
				.Project.DataLayer.DTO
			]
		)
	]
)
