//
//  UserProfileRouter.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile
import GMDUtils

protocol UserProfileInteractable:
	Interactable,
	DogProfileEditListener,
	UserProfileEditListener,
	NewDogProfileListener {
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
	
	private let newDogProfileBuildable: NewDogProfileBuildable
	private var newDogProfileRouting: ViewableRouting?
	
	init(
		interactor: UserProfileInteractable,
		viewController: UserProfileViewControllable,
		userProfileEditBuildable: UserProfileEditBuildable,
		dogProfileEditBuildable: DogProfileEditBuildable,
		newDogProfileBuildable: NewDogProfileBuildable
	) {
		self.userProfileEditBuildable = userProfileEditBuildable
		self.dogProfileEditBuildable = dogProfileEditBuildable
		self.newDogProfileBuildable = newDogProfileBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: UserProfileEdit
extension UserProfileRouter {
	func userProfileEditAttach() {
		if userProfileEditRouting != nil { return }

		let router = userProfileEditBuildable.build(withListener: interactor)
		pushViewController(router.viewControllable)

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
	func dogProfileEditAttach(selectedId: Int) {
		if dogProfileEditRouting != nil { return }
		
		let router = dogProfileEditBuildable.build(
			withListener: interactor,
			selectedDogId: selectedId
		)
		pushViewController(router.viewControllable)
		
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

// MARK: - NewDogProfile
extension UserProfileRouter {
	func newDogProfileAttach() {
		if newDogProfileRouting != nil { return }
		
		let router = newDogProfileBuildable.build(withListener: interactor)
		pushViewController(router.viewControllable)
		
		newDogProfileRouting = router
		attachChild(router)
	}
	
	func newDogProfileDetach() {
		guard let router = newDogProfileRouting else { return }
		
		router.viewControllable.popViewController(animated: true)
		newDogProfileRouting = nil
		detachChild(router)
	}
}

// MARK: - Private Extension
private extension UserProfileRouter {
	func pushViewController(_ viewControllable: ViewControllable) {
		viewController.pushViewController(
			viewControllable,
			animated: true
		)
	}
}
