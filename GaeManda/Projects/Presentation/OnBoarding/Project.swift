import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "OnBoarding"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createIntefaceTarget(
			name: projectName,
			dependencies: [
				.Project.CoreLayer.GMDUtils,
				.SPM.RIBs
			]
		),
		.createImplementationTarget(
			name: projectName,
			dependencies: [
				.Project.PresentationLayer.OnBoarding,
				.Project.CoreLayer.GMDExtensions,
				.Project.DomainLayer.UseCase,
				.Project.DomainLayer.Entity,
				.Project.DesignKit,
				.SPM.RxCocoa,
				.SPM.RxGesture,
				.SPM.SnapKit,
				.SPM.NMapsMap
			]
		),
		.createTestTarget(name: projectName)
	]
)
