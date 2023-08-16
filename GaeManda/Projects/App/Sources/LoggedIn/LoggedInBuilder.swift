//
//  LoggedInBuilder.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

protocol LoggedInDependency: Dependency { }

// MARK: - Builder
protocol LoggedInBuildable: Buildable {
	func build(withListener listener: LoggedInListener) -> ViewableRouting
}

final class LoggedInBuilder:
	Builder<LoggedInDependency>,
	LoggedInBuildable {
	override init(dependency: LoggedInDependency) {
		super.init(dependency: dependency)
	}
	
	func build(withListener listener: LoggedInListener) -> ViewableRouting {
		let component = LoggedInComponent(dependency: dependency)
		let viewController = LoggedInTabBarController()
		let interactor = LoggedInInteractor(presenter: viewController)
		interactor.listener = listener
		return LoggedInRouter(
			interactor: interactor,
			viewController: viewController,
			chattingListBuildable: component.chattingListBuildable,
			dogsOnAroundBuildable: component.dogsOnAroundBuildable,
			userSettingBuildable: component.userProfileBuildable
		)
	}
}
