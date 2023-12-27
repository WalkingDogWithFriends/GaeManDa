//
//  DogProfileSecondDashboardRouter.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogProfileSecondDashboardInteractable: Interactable {
	var router: DogProfileSecondDashboardRouting? { get set }
	var listener: DogProfileSecondDashboardListener? { get set }
}

// swiftlint:disable:next type_name
protocol DogProfileSecondDashboardViewControllable: ViewControllable { }

final class DogProfileSecondDashboardRouter: 
	ViewableRouter<DogProfileSecondDashboardInteractable,
	DogProfileSecondDashboardViewControllable>,
	DogProfileSecondDashboardRouting {
	override init(
		interactor: DogProfileSecondDashboardInteractable,
		viewController: DogProfileSecondDashboardViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
