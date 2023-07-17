//
//  LoggedInRouter.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting
import DogsOnAround
import GMDProfile
import GMDUtils

protocol LoggedInInteractable:
	Interactable,
	ChattingListener,
	DogsOnAroundListener,
	UserProfileListener {
	var router: LoggedInRouting? { get set }
	var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
	func setViewControllers(_ viewControllers: [ViewControllable])
}

final class LoggedInRouter:
	ViewableRouter<LoggedInInteractable, LoggedInViewControllable>,
	LoggedInRouting {
	private let chattingBuildable: ChattingBuildable
	private var chattingRouting: ViewableRouting?
	
	private let dogsOnAroundBuildable: DogsOnAroundBuildable
	private var dogsOnAroundRouting: ViewableRouting?
	
	private let userSettingBuildable: UserProfileBuildable
	private var userSettingRouting: ViewableRouting?
	
	init(
		interactor: LoggedInInteractable,
		viewController: LoggedInViewControllable,
		chattingBuildable: ChattingBuildable,
		dogsOnAroundBuildable: DogsOnAroundBuildable,
		userSettingBuildable: UserProfileBuildable
	) {
		self.chattingBuildable = chattingBuildable
		self.dogsOnAroundBuildable = dogsOnAroundBuildable
		self.userSettingBuildable = userSettingBuildable
		
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachTabs() {
		let chattingRouting = chattingBuildable.build(withListener: interactor)
		let dogsOnAroundRouting = dogsOnAroundBuildable.build(withListener: interactor)
		let userSettingRouting = userSettingBuildable.build(withListener: interactor)
		
		attachChild(chattingRouting)
		attachChild(dogsOnAroundRouting)
		attachChild(userSettingRouting)

		let viewControllers = [
			NavigationControllerable(root: chattingRouting.viewControllable),
			NavigationControllerable(root: dogsOnAroundRouting.viewControllable),
			NavigationControllerable(root: userSettingRouting.viewControllable)
		]
		
		viewController.setViewControllers(viewControllers)
	}
}
