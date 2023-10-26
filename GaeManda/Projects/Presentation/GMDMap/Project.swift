import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "GMDMap"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createIntefaceTarget(
			name: projectName,
			dependencies: [
				.SPM.RIBs
			]
		),
		.createImplementationTarget(
			name: projectName,
			dependencies: [
				.Project.PresentationLayer.GMDMap,
				.Project.CoreLayer.GMDUtils,
				.Project.CoreLayer.GMDExtensions,
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.UseCase,
				.Project.DesignKit,
				.SPM.RxCocoa,
				.SPM.RxGesture,
				.SPM.SnapKit
			]
		),
		.createTestTarget(name: projectName)
	]
)
