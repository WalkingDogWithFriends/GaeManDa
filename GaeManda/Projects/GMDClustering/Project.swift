//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by jung on 11/5/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createProject(
	name: "GMDClustering",
	targets: [
		.createTarget(
			name: "GMDClustering",
			product: .staticLibrary,
			sources: ["Sources/**"]
		)
	]
)
