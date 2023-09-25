import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "SignIn"

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
				.Project.PresentationLayer.SignIn,
				.Project.CoreLayer.GMDExtensions,
				.Project.CoreLayer.GMDUtils,
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
