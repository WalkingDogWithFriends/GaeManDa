//
//  LoggedInRouter.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable {
	var router: LoggedInRouting? { get set }
	var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
	func setViewControllers(_ viewControllers: [ViewControllable])
}

final class LoggedInRouter:
	ViewableRouter<LoggedInInteractable, LoggedInViewControllable>,
	LoggedInRouting {
	override init(
		interactor: LoggedInInteractable,
		viewController: LoggedInViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachTabs() {	}
}
