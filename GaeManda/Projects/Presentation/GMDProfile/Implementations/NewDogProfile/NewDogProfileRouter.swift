//
//  NewDogProfileRouter.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol NewDogProfileInteractable: Interactable {
	var router: NewDogProfileRouting? { get set }
	var listener: NewDogProfileListener? { get set }
}

protocol NewDogProfileViewControllable: ViewControllable { }

final class NewDogProfileRouter:
	ViewableRouter<NewDogProfileInteractable, NewDogProfileViewControllable>,
	NewDogProfileRouting {
	override init(
		interactor: NewDogProfileInteractable,
		viewController: NewDogProfileViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
