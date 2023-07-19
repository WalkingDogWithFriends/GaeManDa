//
//  ChattingRouter.swift
//  ChattingImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

protocol ChattingInteractable: Interactable {
	var router: ChattingRouting? { get set }
	var listener: ChattingListener? { get set }
}

protocol ChattingViewControllable: ViewControllable { }

final class ChattingRouter:
	ViewableRouter<ChattingInteractable, ChattingViewControllable>,
	ChattingRouting {
	override init(
		interactor: ChattingInteractable,
		viewController: ChattingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
