//
//  DogProfileEditRouter.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol DogProfileEditInteractable: Interactable {
	var router: DogProfileEditRouting? { get set }
	var listener: DogProfileEditListener? { get set }
}

protocol DogProfileEditViewControllable: ViewControllable { }

final class DogProfileEditRouter:
	ViewableRouter<DogProfileEditInteractable, DogProfileEditViewControllable>,
	DogProfileEditRouting {
	override init(
		interactor: DogProfileEditInteractable,
		viewController: DogProfileEditViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
