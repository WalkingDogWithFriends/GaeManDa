//
//  UserProfileBuilder.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

public protocol UserProfileDependency: Dependency { }

final class UserProfileComponent: Component<UserProfileDependency> { }

public final class UserProfileBuilder:
	Builder<UserProfileDependency>,
	UserProfileBuildable {
	public override init(dependency: UserProfileDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserProfileListener) -> ViewableRouting {
		let viewController = UserProfileViewController()
		let interactor = UserProfileInteractor(presenter: viewController)
		interactor.listener = listener
		return UserProfileRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
