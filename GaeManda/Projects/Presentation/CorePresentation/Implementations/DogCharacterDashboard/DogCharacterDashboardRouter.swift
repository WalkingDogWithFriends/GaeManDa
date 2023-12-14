//
//  DogCharacterDashboardRouter.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogCharacterDashboardInteractable: Interactable {
	var router: DogCharacterDashboardRouting? { get set }
	var listener: DogCharacterDashboardListener? { get set }
}

protocol DogCharacterDashboardViewControllable: ViewControllable { }

final class DogCharacterDashboardRouter:
	ViewableRouter<DogCharacterDashboardInteractable,
	DogCharacterDashboardViewControllable>,
	DogCharacterDashboardRouting {
	override init(
		interactor: DogCharacterDashboardInteractable,
		viewController: DogCharacterDashboardViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
