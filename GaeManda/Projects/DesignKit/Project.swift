import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "DesignKit",
	targets: [
		.createTarget(
			name: "DesignKit",
			product: .framework,
			resources: ["Resources/**"],
			dependencies: [
				.Project.CoreLayer.GMDExtensions
			]
		)
	],
	resourceSynthesizers: [
		.custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
		.fonts()
	]
)
