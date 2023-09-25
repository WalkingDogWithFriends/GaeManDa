import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Domain",
	targets: [
		.createTarget(
			name: "Entity",
			product: .staticLibrary,
			sources: ["Entity/**"]
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
			name: "UseCase",
			product: .staticLibrary,
			sources: ["Interfaces/UseCase/**"],
			dependencies: [
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.Repository,
				.SPM.RxSwift
			]
		),
		.createTarget(
			name: "UseCaseImpl",
			product: .staticLibrary,
			sources: ["UseCaseImpl/Sources/**"],
			dependencies: [
				.Project.DomainLayer.UseCase
			]
		),
		.createTarget(
			name: "Repository",
			product: .staticLibrary,
			sources: ["Interfaces/Repository/**"],
			dependencies: [
				.Project.DomainLayer.Entity,
				.SPM.RxSwift
			]
		),
		.createTarget(
			name: "UseCaseTest",
			product: .unitTests,
			sources: ["UseCaseImpl/Tests/**"],
			dependencies: [
				.Project.DomainLayer.UseCase,
				.Project.DomainLayer.UseCaseImpl
			]
		)
	]
)
