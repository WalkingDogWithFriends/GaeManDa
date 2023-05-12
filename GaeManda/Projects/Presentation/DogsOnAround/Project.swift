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
				
			]
		),
		.createTarget(
			name: "DogsOnAroundImpl",
			product: .staticLibrary,
			sources: ["Implementations/**"],
			dependencies: [

			]
		)
	]
)
