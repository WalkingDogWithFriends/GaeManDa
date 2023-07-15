import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Core",
	targets: [
		.createTarget(
			name: "GMDExtensions",
			product: .framework,
			sources: ["GMDExtensions/**"],
			dependencies: [
				.SPM.RxCocoa
			]
		),
		.createTarget(
			name: "GMDUtils",
			product: .framework,
			sources: ["GMDUtils/**"],
			dependencies: [
				.SPM.RIBs
			]
		)
	]
)
