//
//  UserProfileDashboardRouter.swift
//  CorePresentation
//
//  Created by jung on 12/14/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol UserProfileDashboardInteractable: Interactable, BirthdayPickerListener {
	var router: UserProfileDashboardRouting? { get set }
	var listener: UserProfileDashboardListener? { get set }
}

protocol UserProfileDashboardViewControllable: ViewControllable { }

final class UserProfileDashboardRouter:
	ViewableRouter<UserProfileDashboardInteractable,
	UserProfileDashboardViewControllable>,
	UserProfileDashboardRouting {
	private let birthdayPickerBuildable: BirthdayPickerBuildable
	private var birthdayPickerRouting: ViewableRouting?
	
	init(
		interactor: UserProfileDashboardInteractable,
		viewController: UserProfileDashboardViewControllable,
		birthdayPickerBuildable: BirthdayPickerBuildable
	) {
		self.birthdayPickerBuildable = birthdayPickerBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - BirthdayPicker
extension UserProfileDashboardRouter {
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
