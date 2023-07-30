//
//  UserProfileRouter.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol UserProfileInteractable:
	Interactable,
	DogProfileEditListener,
	UserProfileEditListener {
	var router: UserProfileRouting? { get set }
	var listener: UserProfileListener? { get set }
}

protocol UserProfileViewControllable: ViewControllable { }

final class UserProfileRouter:
	ViewableRouter<UserProfileInteractable, UserProfileViewControllable>,
	UserProfileRouting {
	private let userProfileEditBuildable: UserProfileEditBuildable
	private var userProfileEditRouting: ViewableRouting?
	
	private let dogProfileEditBuildable: DogProfileEditBuildable
	private var dogProfileEditRouting: ViewableRouting?
	
	init(
		interactor: UserProfileInteractable,
		viewController: UserProfileViewControllable,
		userProfileEditBuildable: UserProfileEditBuildable,
		dogProfileEditBuildable: DogProfileEditBuildable
	) {
		self.userProfileEditBuildable = userProfileEditBuildable
		self.dogProfileEditBuildable = dogProfileEditBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: UserProfileEdit
extension UserProfileRouter {
	func userProfileEditAttach() {
		if userProfileEditRouting != nil { return }
		
		let router = userProfileEditBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		
		userProfileEditRouting = router
		attachChild(router)
	}
	
	func userProfileEditDetach() {
		guard let router = userProfileEditRouting else { return }
		
		router.viewControllable.popViewController(animated: true)
		userProfileEditRouting = nil
		detachChild(router)
	}
}

// MARK: DogProfileEdit
extension UserProfileRouter {
	func dogProfileEditAttach() {
		if dogProfileEditRouting != nil { return }
		
		let router = dogProfileEditBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		
		dogProfileEditRouting = router
		attachChild(router)
	}
	
	func dogProfileEditDetach() {
		guard let router = dogProfileEditRouting else { return }
		
		router.viewControllable.popViewController(animated: true)
		dogProfileEditRouting = nil
		detachChild(router)
	}
}
