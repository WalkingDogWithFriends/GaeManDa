//
//  UserProfileEditRouter.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxRelay
import CorePresentation
import GMDProfile

protocol UserProfileEditInteractable: Interactable, UserProfileDashboardListener {
	var router: UserProfileEditRouting? { get set }
	var listener: UserProfileEditListener? { get set }
}

protocol UserProfileEditViewControllable: ViewControllable {
	func addUserProfileDashboard(_ viewControllable: ViewControllable)
}

final class UserProfileEditRouter:
	ViewableRouter<UserProfileEditInteractable, UserProfileEditViewControllable>,
	UserProfileEditRouting {
	private let userProfileDashboardBuildable: UserProfileDashboardBuildable
	private var userProfileDashboardRouting: ViewableRouting?
	
	init(
		interactor: UserProfileEditInteractable,
		viewController: UserProfileEditViewControllable,
		userProfileDashboardBuildable: UserProfileDashboardBuildable
	) {
		self.userProfileDashboardBuildable = userProfileDashboardBuildable
		
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - UserProfileDashboard
extension UserProfileEditRouter {
	func attachUserProfileDashboard(
		usernameTextFieldModeRelay: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarningRelay: BehaviorRelay<Bool>
	) {
		guard userProfileDashboardRouting == nil else { return }
		let router = userProfileDashboardBuildable.build(
			withListener: interactor,
			nicknameTextFieldMode: usernameTextFieldModeRelay,
			birthdayTextFieldIsWarning: birthdayTextFieldIsWarningRelay,
			userProfilePassingModel: nil
		)
		
		self.userProfileDashboardRouting = router
		attachChild(router)
		viewController.addUserProfileDashboard(router.viewControllable)
	}
}
