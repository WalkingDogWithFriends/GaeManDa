//
//  UserProfileEditBuilder.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation
import GMDProfile
import UseCase

public protocol UserProfileEditDependency: Dependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
	var userProfileDashboardBuildable: UserProfileDashboardBuildable { get }
}

final class UserProfileEditComponent:
	Component<UserProfileEditDependency>,
	UserProfileEditInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase {
		dependency.gmdProfileUseCase
	}
	
	var userProfileDashboardBuildable: UserProfileDashboardBuildable {
		dependency.userProfileDashboardBuildable
	}
}

public final class UserProfileEditBuilder:
	Builder<UserProfileEditDependency>,
	UserProfileEditBuildable {
	public override init(dependency: UserProfileEditDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserProfileEditListener) -> ViewableRouting {
		let component = UserProfileEditComponent(dependency: dependency)
		let viewController = UserProfileEditViewController()
		let interactor = UserProfileEditInteractor(
			presenter: viewController,
			dependency: component
		)
		
		interactor.listener = listener
		return UserProfileEditRouter(
			interactor: interactor,
			viewController: viewController,
			userProfileDashboardBuildable: component.userProfileDashboardBuildable
		)
	}
}
