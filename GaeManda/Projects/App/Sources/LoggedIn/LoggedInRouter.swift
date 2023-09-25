//
//  LoggedInRouter.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting
import GMDMap
import GMDProfile
import GMDUtils

protocol LoggedInInteractable:
	Interactable,
	ChattingListListener,
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
	private let chattingListBuildable: ChattingListBuildable
	private var chattingListRouting: ViewableRouting?
	
	private let dogsOnAroundBuildable: DogsOnAroundBuildable
	private var dogsOnAroundRouting: ViewableRouting?
	
	private let userSettingBuildable: UserProfileBuildable
	private var userSettingRouting: ViewableRouting?
	
	init(
		interactor: LoggedInInteractable,
		viewController: LoggedInViewControllable,
		chattingListBuildable: ChattingListBuildable,
		dogsOnAroundBuildable: DogsOnAroundBuildable,
		userSettingBuildable: UserProfileBuildable
	) {
		self.chattingListBuildable = chattingListBuildable
		self.dogsOnAroundBuildable = dogsOnAroundBuildable
		self.userSettingBuildable = userSettingBuildable
		
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachTabs() {
		let chattingListRouting = chattingListBuildable.build(withListener: interactor)
		let dogsOnAroundRouting = dogsOnAroundBuildable.build(withListener: interactor)
		let userSettingRouting = userSettingBuildable.build(withListener: interactor)
		
		attachChild(chattingListRouting)
		attachChild(dogsOnAroundRouting)
		attachChild(userSettingRouting)

		let viewControllers = [
			NavigationControllerable(root: dogsOnAroundRouting.viewControllable),
			NavigationControllerable(root: userSettingRouting.viewControllable),
			NavigationControllerable(root: chattingListRouting.viewControllable)
		]
		
		viewController.setViewControllers(viewControllers)
	}
}
