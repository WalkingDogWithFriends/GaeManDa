//
//  DogProfileSecondDashboard.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

public protocol DogProfileSecondDashboardBuildable: Buildable {
		func build(
			withListener listener: DogProfileSecondDashboardListener,
			dogSpecies: [String],
			selectedDogSpecies: String?,
			isNeutered: Bool?
		) -> ViewableRouting
}

public protocol DogProfileSecondDashboardListener: AnyObject {
	func didSelectedDogSpecies(_ dogSpecies: String)
	func didSelectedIsNeutered(_ isNeutered: Bool)
}
