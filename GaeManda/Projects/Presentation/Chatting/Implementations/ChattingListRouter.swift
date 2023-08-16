//
//  ChattingListRouter.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

protocol ChattingListInteractable: Interactable {
	var router: ChattingListRouting? { get set }
	var listener: ChattingListListener? { get set }
}

protocol ChattingListViewControllable: ViewControllable { }

final class ChattingListRouter:
	ViewableRouter<ChattingListInteractable, ChattingListViewControllable>,
	ChattingListRouting {
	override init(
		interactor: ChattingListInteractable,
		viewController: ChattingListViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
