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
	GMDProfileEditListener,
	NewDogProfileListener {
	var router: GMDProfileRouting? { get set }
	var listener: GMDProfileListener? { get set }
}

protocol GMDProfileViewControllable: ViewControllable { }

final class GMDProfileRouter:
	ViewableRouter<GMDProfileInteractable, GMDProfileViewControllable>,
	GMDProfileRouting {
	private let gmdProfileEditBuildable: GMDProfileEditBuildable
	private var gmdProfileEditRouting: ViewableRouting?
	
	private let dogProfileEditBuildable: DogProfileEditBuildable
	private var dogProfileEditRouting: ViewableRouting?
	
	private let newDogProfileBuildable: NewDogProfileBuildable
	private var newDogProfileRouting: ViewableRouting?
	
	init(
		interactor: GMDProfileInteractable,
		viewController: GMDProfileViewControllable,
		gmdProfileEditBuildable: GMDProfileEditBuildable,
		dogProfileEditBuildable: DogProfileEditBuildable,
		newDogProfileBuildable: NewDogProfileBuildable
	) {
		self.gmdProfileEditBuildable = gmdProfileEditBuildable
		self.dogProfileEditBuildable = dogProfileEditBuildable
		self.newDogProfileBuildable = newDogProfileBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: GMDProfileEdit
extension GMDProfileRouter {
	func gmdProfileEditAttach() {
		if gmdProfileEditRouting != nil { return }
		
		let router = gmdProfileEditBuildable.build(withListener: interactor)
		viewController.pushViewController(
			router.viewControllable,
			animated: true
		)
		
		gmdProfileEditRouting = router
		attachChild(router)
	}
	
	func gmdProfileEditDetach() {
		guard let router = gmdProfileEditRouting else { return }
		
		router.viewControllable.popViewController(animated: true)
		gmdProfileEditRouting = nil
		detachChild(router)
	}
	
	func gmdProfileEditDismiss() {
		guard let router = gmdProfileEditRouting else { return }
		
		gmdProfileEditRouting = nil
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
