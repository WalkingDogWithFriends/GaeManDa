//
//  UserProfileDashboardBuilder.swift
//  CorePresentation
//
//  Created by jung on 12/14/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxRelay
import CorePresentation

public protocol UserProfileDashboardDependency: Dependency, BirthdayPickerDependency { }

public final class UserProfileDashboardBuilder:
	Builder<UserProfileDashboardDependency>,
	UserProfileDashboardBuildable {
	public override init(dependency: UserProfileDashboardDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(
		withListener listener: UserProfileDashboardListener,
		nicknameTextFieldMode: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarning: BehaviorRelay<Bool>,		
		userProfilePassingModel: UserProfilePassingModel?
	) -> ViewableRouting {
		let viewController = UserProfileDashboardViewController()
		let interactor = UserProfileDashboardInteractor(
			presenter: viewController,
			passingModel: userProfilePassingModel,
			nicknameTextFieldMode: nicknameTextFieldMode,
			birthdayTextFieldIsWarning: birthdayTextFieldIsWarning
		)
		
		interactor.listener = listener
		
		let birthdayPickerBuildable = BirthdayPickerBuilder(dependency: dependency)
		
		return UserProfileDashboardRouter(
			interactor: interactor,
			viewController: viewController,
			birthdayPickerBuildable: birthdayPickerBuildable
		)
	}
}
