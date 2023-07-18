import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "Core",
	targets: [
		.createTarget(
			name: "GMDExtensions",
			product: .staticLibrary,
			sources: ["GMDExtensions/**"],
			dependencies: [
				.Project.CoreLayer.GMDUtils,
				.SPM.RxCocoa
			]
		),
		.createTarget(
			name: "GMDUtils",
			product: .staticLibrary,
			sources: ["GMDUtils/**"],
			dependencies: [
				.SPM.RIBs
			]
		)
	]
)
