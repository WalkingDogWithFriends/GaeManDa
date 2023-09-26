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
	GMDMapListener,
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
	
	private let gmdMapBuildable: GMDMapBuildable
	private var gmdMapRouting: ViewableRouting?
	
	private let gmdProfileBuildable: UserProfileBuildable
	private var gmdProfileRouting: ViewableRouting?
	
	init(
		interactor: LoggedInInteractable,
		viewController: LoggedInViewControllable,
		chattingListBuildable: ChattingListBuildable,
		gmdMapBuildable: GMDMapBuildable,
		gmdProfileBuildable: UserProfileBuildable
	) {
		self.chattingListBuildable = chattingListBuildable
		self.gmdMapBuildable = gmdMapBuildable
		self.gmdProfileBuildable = gmdProfileBuildable
		
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
	
	func attachTabs() {
		let gmdMapRouting = gmdMapBuildable.build(withListener: interactor)
		let gmdProfileRouting = gmdProfileBuildable.build(withListener: interactor)
		let chattingListRouting = chattingListBuildable.build(withListener: interactor)
		
		attachChild(gmdMapRouting)
		attachChild(gmdProfileRouting)
		attachChild(chattingListRouting)

		let viewControllers = [
			NavigationControllerable(root: gmdMapRouting.viewControllable),
			NavigationControllerable(root: gmdProfileRouting.viewControllable),
			NavigationControllerable(root: chattingListRouting.viewControllable)
		]
		
		viewController.setViewControllers(viewControllers)
	}
}
