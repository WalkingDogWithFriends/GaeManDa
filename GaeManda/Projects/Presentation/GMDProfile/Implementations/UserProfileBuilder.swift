//
//  UserProfileBuilder.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile
import UseCase

public protocol UserProfileDependency: Dependency {
	var userProfileUseCase: UserProfileUseCase { get }
	var userProfileEditBuildable: UserProfileEditBuildable { get }
	var dogProfileEditBuildable: DogProfileEditBuildable { get }
}

final class UserProfileComponent:
	Component<UserProfileDependency>,
	UserProfileInteractorDependency {
	var userProfileUseCase: UserProfileUseCase {
		dependency.userProfileUseCase
	}
	fileprivate var userProfileEditBuildable: UserProfileEditBuildable {
		dependency.userProfileEditBuildable
	}
	fileprivate var dogProfileEditBuildable: DogProfileEditBuildable {
		dependency.dogProfileEditBuildable
	}
}

public final class UserProfileBuilder:
	Builder<UserProfileDependency>,
	UserProfileBuildable {
	public override init(dependency: UserProfileDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserProfileListener) -> ViewableRouting {
		let component = UserProfileComponent(dependency: dependency)
		let viewController = UserProfileViewController()
		let interactor = UserProfileInteractor(
			presenter: viewController,
			dependency: component
		)
				
		interactor.listener = listener
		return UserProfileRouter(
			interactor: interactor,
			viewController: viewController,
			userProfileEditBuildable: component.userProfileEditBuildable,
			dogProfileEditBuildable: component.dogProfileEditBuildable
		)
	}
}
