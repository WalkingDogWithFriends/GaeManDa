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
				.SPM.RIBs,
				.SPM.RxSwift,
				.SPM.RxCocoa
			]
		),
		.createTarget(
			name: "GMDUtils",
			product: .staticLibrary,
			sources: ["GMDUtils/**"],
			dependencies: [
				.Project.CoreLayer.GMDExtensions
			]
		)
	]
)
