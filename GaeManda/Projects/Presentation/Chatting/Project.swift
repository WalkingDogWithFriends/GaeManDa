import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Chatting"

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
				.Project.PresentationLayer.Chatting,
				.Project.DesignKit,
				.Project.CoreLayer.GMDExtensions,
				.Project.DomainLayer.UseCase,
				.SPM.RxCocoa,
				.SPM.RxGesture,
				.SPM.SnapKit
			]
		),
		.createTestTarget(name: projectName)
	]
)
