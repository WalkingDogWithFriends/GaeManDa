//
//  ChattingListRouter.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

protocol ChattingListInteractable:
	Interactable,
	ChattingListener {
	var router: ChattingListRouting? { get set }
	var listener: ChattingListListener? { get set }
}

protocol ChattingListViewControllable: ViewControllable { }

final class ChattingListRouter:
	ViewableRouter<ChattingListInteractable, ChattingListViewControllable>,
	ChattingListRouting {
	private let chattingBuildable: ChattingBuildable
	private var chattingRouting: ViewableRouting?
	
	init(
		interactor: ChattingListInteractable,
		viewController: ChattingListViewControllable,
		chattingBuildable: ChattingBuildable
	) {
		self.chattingBuildable = chattingBuildable
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}

// MARK: - Chatting
extension ChattingListRouter {
	func attachChatting(with user: String) {
		if chattingRouting != nil { return }
		
		let router = chattingBuildable.build(withListener: interactor)
		viewControllable.pushViewController(
			router.viewControllable,
			animated: true
		)
		chattingRouting = router
		attachChild(router)
	}
	
	func detachChatting() {
		guard let router = chattingRouting else { return }
		
		viewControllable.popViewController(animated: true)
		chattingRouting = nil
		detachChild(router)
	}
}
