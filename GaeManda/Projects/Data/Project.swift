import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Data",
	targets: [
		.createTarget(
			name: "DTO",
			product: .staticLibrary,
			sources: ["DTO/**"]
		),
		.createTarget(
			name: "RepositoryImpl",
			product: .staticLibrary,
			sources: ["RepositoryImpl/Sources/**"],
			dependencies: [
				.Project.DataLayer.DTO,
				.Project.DataLayer.GMDNetwork,
				.Project.DomainLayer.Repository,
				.Project.DomainLayer.DataMapper
			]
		),
		.createTarget(
			name: "GMDNetwork",
			product: .staticLibrary,
			sources: ["GMDNetwork/**"],
			dependencies: [
				.Project.DataLayer.DTO
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
