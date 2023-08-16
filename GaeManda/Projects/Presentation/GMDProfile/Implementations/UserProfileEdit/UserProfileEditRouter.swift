//
//  UserProfileEditRouter.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol UserProfileEditInteractable: Interactable {
	var router: UserProfileEditRouting? { get set }
	var listener: UserProfileEditListener? { get set }
}

protocol UserProfileEditViewControllable: ViewControllable { }

final class UserProfileEditRouter:
	ViewableRouter<UserProfileEditInteractable, UserProfileEditViewControllable>,
	UserProfileEditRouting {
	override init(
		interactor: UserProfileEditInteractable,
		viewController: UserProfileEditViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
