//
//  DogProfileSecondDashboardBuilder.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

public protocol DogProfileSecondDashboardDependency: Dependency { }

public final class DogProfileSecondDashboardBuilder:
	Builder<DogProfileSecondDashboardDependency>,
	DogProfileSecondDashboardBuildable {
	public override init(dependency: DogProfileSecondDashboardDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: DogProfileSecondDashboardListener,
		dogSpecies: [String],
		selectedDogSpecies: String?,
		isNeutered: Bool?
	) -> ViewableRouting {
		let viewController = DogProfileSecondDashboardViewController()
		let interactor = DogProfileSecondDashboardInteractor(
			presenter: viewController,
			dogSpecies: dogSpecies,
			selectedDogSpecies: selectedDogSpecies
		)
		interactor.listener = listener
		return DogProfileSecondDashboardRouter(interactor: interactor, viewController: viewController)
	}
}
