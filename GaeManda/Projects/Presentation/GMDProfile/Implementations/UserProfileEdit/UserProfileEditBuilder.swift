//
//  UserProfileEditBuilder.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

public protocol UserProfileEditDependency: Dependency { }

final class UserProfileEditComponent: Component<UserProfileEditDependency> { }

public final class UserProfileEditBuilder:
	Builder<UserProfileEditDependency>,
	UserProfileEditBuildable {
	public override init(dependency: UserProfileEditDependency) {
		super.init(dependency: dependency)
	}
	
	public func build(withListener listener: UserProfileEditListener) -> ViewableRouting {
		let component = UserProfileEditComponent(dependency: dependency)
		let viewController = UserProfileEditViewController()
		let interactor = UserProfileEditInteractor(presenter: viewController)
		interactor.listener = listener
		return UserProfileEditRouter(
			interactor: interactor,
			viewController: viewController
		)
	}
}
