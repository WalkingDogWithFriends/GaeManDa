import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "DesignKit",
	targets: [
		.createTarget(
			name: "DesignKit",
			product: .staticLibrary,
			resources: ["Resources/**"],
			dependencies: [
				.Project.CoreLayer.GMDExtensions
			]
		)
	],
	resourceSynthesizers: [
		.custom(name: "Colors", parser: .assets, extensions: ["xcassets"]),
		.custom(name: "Images", parser: .assets, extensions: ["xcassets"]),
		.fonts()
	]
)
