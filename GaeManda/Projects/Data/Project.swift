import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Data",
	targets: [
		.createTarget(
			name: "LocalStorage",
			product: .staticFramework,
			sources: ["LocalStorage/Sources/**"],
			resources: ["LocalStorage/Resources/**"]
		),
		.createTarget(
			name: "DTO",
			product: .staticLibrary,
			sources: ["DTO/**"]
		),
		.createTarget(
			name: "DataMapper",
			product: .staticLibrary,
			sources: ["DataMapper/**"],
			dependencies: [
				.Project.DataLayer.DTO,
				.Project.DomainLayer.Entity
			]
		),
		.createTarget(
			name: "RepositoryImpl",
			product: .staticLibrary,
			sources: ["RepositoryImpl/Sources/**"],
			dependencies: [
				.Project.DataLayer.LocalStorage,
				.Project.DataLayer.DTO,
				.Project.DataLayer.GMDNetwork,
				.Project.DataLayer.DataMapper,
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
