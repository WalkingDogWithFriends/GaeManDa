import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "SignUp"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createTarget(
			name: "SignUp",
			product: .framework,
			sources: ["Interfaces/**"],
			dependencies: [
				.Project.CoreLayer.Extensions,
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.UseCase
			]
		),
		.createTarget(
			name: "SignUpImpl",
			product: .staticLibrary,
			sources: ["Implementations/**"],
			dependencies: [
				.Project.PresentationLayer.SignUp,
				.Project.DesignKit,
				.SPM.RIBs,
			]
		)
	]
)

