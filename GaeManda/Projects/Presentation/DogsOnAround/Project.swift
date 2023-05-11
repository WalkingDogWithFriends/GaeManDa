import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "DogsOnAround"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createTarget(
			name: "DogsOnAround",
			product: .framework,
			sources: ["Interfaces/**"],
			dependencies: [
				.Project.CoreLayer.Extensions,
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.UseCase
			]
		),
		.createTarget(
			name: "DogsOnAroundImpl",
			product: .staticLibrary,
			sources: ["Implementations/**"],
			dependencies: [
				.Project.PresentationLayer.DogsOnAround,
				.Project.DesignKit,
				.SPM.RIBs,
			]
		)
	]
)
