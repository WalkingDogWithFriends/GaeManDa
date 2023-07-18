import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "DogsOnAround"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createIntefaceTarget(
			name: projectName,
			dependencies: [
				.Project.DomainLayer.Entity,
				.Project.CoreLayer.GMDUtils,
				.SPM.RIBs
			]
		),
		.createImplementationTarget(
			name: projectName,
			dependencies: [
				.Project.PresentationLayer.DogsOnAround,
				.Project.DesignKit,
				.Project.CoreLayer.GMDExtensions,
				.Project.DomainLayer.UseCase,
				.SPM.RxCocoa,
				.SPM.RxGesture
			]
		),
		.createTestTarget(name: projectName)
	]
)
