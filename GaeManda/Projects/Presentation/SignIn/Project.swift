import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "SignIn"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createTarget(
			name: "SignIn",
			product: .framework,
			sources: ["Interfaces/**"],
			dependencies: [
				.Project.CoreLayer.Extensions,
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.UseCase
			]
		),
		.createTarget(
			name: "SignInImpl",
			product: .staticLibrary,
			sources: ["Implementations/**"],
			dependencies: [
				.Project.PresentationLayer.SignIn,
				.Project.DesignKit,
				.SPM.RIBs,
			]
		)
	]
)

