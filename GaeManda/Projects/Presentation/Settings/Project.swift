import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Settings"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createTarget(
			name: "Settings",
			product: .framework,
			sources: ["Interfaces/**"],
			dependencies: [
				.Project.CoreLayer.Extensions,
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.UseCase
			]
		),
		.createTarget(
			name: "SettingsImpl",
			product: .staticLibrary,
			sources: ["Implementations/**"],
			dependencies: [
				.Project.PresentationLayer.Settings,
				.Project.DesignKit,
				.SPM.RIBs,
			]
		)
	]
)
