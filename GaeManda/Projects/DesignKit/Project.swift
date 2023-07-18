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
				.Project.CoreLayer.GMDExtensions,
				.SPM.SnapKit
			]
		)
	],
	resourceSynthesizers: [
		.custom(name: "Assets", parser: .assets, extensions: ["xcassets"]),
		.fonts()
	]
)
