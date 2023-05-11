import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Chatting"

let project = Project.createProject(
	name: projectName,
	targets: [
		.createTarget(
			name: "Chatting",
			product: .framework,
			sources: ["Interfaces/**"],
			dependencies: [
				.Project.CoreLayer.Extensions,
				.Project.DomainLayer.Entity,
				.Project.DomainLayer.UseCase
			]
		),
		.createTarget(
			name: "ChattingImpl",
			product: .staticLibrary,
			sources: ["Implementations/**"],
			dependencies: [
				.Project.PresentationLayer.Chatting,
				.Project.DesignKit,
				.SPM.RIBs,
			]
		)
	]
)
