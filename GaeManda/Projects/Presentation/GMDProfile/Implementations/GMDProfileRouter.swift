//
//  GMDProfileRouter.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol GMDProfileInteractable:
	Interactable,
	DogProfileEditListener,
	UserProfileEditListener,
	NewDogProfileListener {
	var router: GMDProfileRouting? { get set }
	var listener: GMDProfileListener? { get set }
}

protocol GMDProfileViewControllable: ViewControllable { }

final class GMDProfileRouter:
	ViewableRouter<GMDProfileInteractable, GMDProfileViewControllable>,
	GMDProfileRouting {
	private let userProfileEditBuildable: UserProfileEditBuildable
	private var userProfileEditRouting: ViewableRouting?
	
	private let dogProfileEditBuildable: DogProfileEditBuildable
	private var dogProfileEditRouting: ViewableRouting?
	
	private let newDogProfileBuildable: NewDogProfileBuildable
	private var newDogProfileRouting: ViewableRouting?
	
	init(
		interactor: GMDProfileInteractable,
		viewController: GMDProfileViewControllable,
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
extension GMDProfileRouter {
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
	
	func userProfileEditDismiss() {
		guard let router = userProfileEditRouting else { return }
		
		userProfileEditRouting = nil
		detachChild(router)
	}
}

// MARK: DogProfileEdit
extension GMDProfileRouter {
	func dogProfileEditAttach(selectedId: Int) {
		if dogProfileEditRouting != nil { return }
		
		let router = dogProfileEditBuildable.build(
			withListener: interactor,
			selectedDogId: selectedId
		)
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
	
	func dogProfileEditDismiss() {
		guard let router = dogProfileEditRouting else { return }

		dogProfileEditRouting = nil
		detachChild(router)
	}
}

// MARK: - NewDogProfile
extension GMDProfileRouter {
	func newDogProfileAttach() {
		if newDogProfileRouting != nil { return }
		
		let router = newDogProfileBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		
		newDogProfileRouting = router
		attachChild(router)
	}
	
	func newDogProfileDetach() {
		guard let router = newDogProfileRouting else { return }
		
		router.viewControllable.popViewController(animated: true)
		newDogProfileRouting = nil
		detachChild(router)
	}
	
	func newDogProfileDismiss() {
		guard let router = newDogProfileRouting else { return }
		
		newDogProfileRouting = nil
		detachChild(router)
	}
}
