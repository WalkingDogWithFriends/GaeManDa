//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by jung on 11/16/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "CorePresentation"

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
				.Project.PresentationLayer.CorePresentation,
				.Project.CoreLayer.GMDUtils,
				.Project.CoreLayer.GMDExtensions,
				.Project.DomainLayer.UseCase,
				.Project.DesignKit,
				.SPM.RxCocoa,
				.SPM.RxGesture,
				.SPM.SnapKit
			]
		)
	]
)
