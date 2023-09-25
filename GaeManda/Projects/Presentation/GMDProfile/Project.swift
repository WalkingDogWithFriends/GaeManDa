import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "GMDProfile"

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
				.Project.PresentationLayer.GMDProfile,
				.Project.CoreLayer.GMDExtensions,
				.Project.CoreLayer.GMDUtils,
				.Project.DomainLayer.UseCase,
				.Project.DomainLayer.Entity,
				.Project.DesignKit,
				.SPM.RxCocoa,
				.SPM.RxGesture,
				.SPM.SnapKit
			]
		),
		.createTestTarget(name: projectName)
	]
)
