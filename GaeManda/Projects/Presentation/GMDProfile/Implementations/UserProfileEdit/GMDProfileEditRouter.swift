//
//  GMDProfileEditRouter.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol GMDProfileEditInteractable: Interactable {
	var router: GMDProfileEditRouting? { get set }
	var listener: GMDProfileEditListener? { get set }
}

protocol GMDProfileEditViewControllable: ViewControllable { }

final class GMDProfileEditRouter:
	ViewableRouter<GMDProfileEditInteractable, GMDProfileEditViewControllable>,
	GMDProfileEditRouting {
	override init(
		interactor: GMDProfileEditInteractable,
		viewController: GMDProfileEditViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
