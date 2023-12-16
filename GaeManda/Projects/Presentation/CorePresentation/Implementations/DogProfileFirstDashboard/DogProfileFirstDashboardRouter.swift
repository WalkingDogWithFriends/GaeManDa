//
//  DogProfileFirstDashboardRouter.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogProfileFirstDashboardInteractable: Interactable, BirthdayPickerListener {
	var router: DogProfileFirstDashboardRouting? { get set }
	var listener: DogProfileFirstDashboardListener? { get set }
}

protocol DogProfileFirstDashboardViewControllable: ViewControllable { }

final class DogProfileFirstDashboardRouter:
	ViewableRouter<DogProfileFirstDashboardInteractable, DogProfileFirstDashboardViewControllable>,
	DogProfileFirstDashboardRouting {
	private let birthdayPickerBuildable: BirthdayPickerBuildable
	private var birthdayPickerRouting: ViewableRouting?

	init(
		interactor: DogProfileFirstDashboardInteractable,
		viewController: DogProfileFirstDashboardViewControllable,
		birthdayPickerBuildable: BirthdayPickerBuildable
	) {
		self.birthdayPickerBuildable = birthdayPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - BirthdayPicker
extension DogProfileFirstDashboardRouter {
	func birthdayPickerAttach() {
		guard birthdayPickerRouting == nil else { return }
		let router = birthdayPickerBuildable.build(withListener: interactor)
		self.birthdayPickerRouting = router
		attachChild(router)
		viewControllable.present(
			router.viewControllable,
			animated: false,
			modalPresentationStyle: .overFullScreen
		)
	}
	
	func birthdayPickerDetach() {
		guard let router = birthdayPickerRouting else { return }
		detachChild(router)
		self.birthdayPickerRouting = nil
	}
}
