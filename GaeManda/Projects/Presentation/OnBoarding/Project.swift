import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "OnBoarding"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createIntefaceTarget(
			name: projectName,
			dependencies: [
				.Project.DomainLayer.Entity,
				.SPM.RIBs
			]
		),
		.createImplementationTarget(
			name: projectName,
			dependencies: [
				.Project.PresentationLayer.OnBoarding,
				.Project.DesignKit,
				.Project.CoreLayer.Extensions,
				.Project.DomainLayer.UseCase
			]
		),
		.createTestTarget(name: projectName)
	]
)
