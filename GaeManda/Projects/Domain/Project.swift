import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Domain",
	targets: [
		.createTarget(
			name: "Entity",
			product: .framework,
			sources: ["Entity/**"]
		),
		.createTarget(
			name: "UseCaseImpl",
			product: .staticLibrary,
			sources: ["UseCaseImpl/Sources/**"],
			dependencies: [
				.Project.DomainLayer.Repository
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
		)
	]
)
