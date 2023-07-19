//
//  UserProfileRouter.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol UserProfileInteractable: Interactable {
	var router: UserProfileRouting? { get set }
	var listener: UserProfileListener? { get set }
}

protocol UserProfileViewControllable: ViewControllable { }

final class UserProfileRouter:
	ViewableRouter<UserProfileInteractable, UserProfileViewControllable>,
	UserProfileRouting {
	override init(
		interactor: UserProfileInteractable,
		viewController: UserProfileViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
