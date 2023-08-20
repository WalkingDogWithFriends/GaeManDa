//
//  ChattingListInteractor.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

protocol ChattingListRouting: ViewableRouting {
	func attachChatting(with user: String)
	func detachChatting()
}

protocol ChattingListPresentable: Presentable {
	var listener: ChattingListPresentableListener? { get set }
}

final class ChattingListInteractor:
	PresentableInteractor<ChattingListPresentable>,
	ChattingListInteractable,
	ChattingListPresentableListener {
	weak var router: ChattingListRouting?
	weak var listener: ChattingListListener?
	
	override init(presenter: ChattingListPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

// MARK: - PresentableListener
extension ChattingListInteractor {
	func didTapChatting(with user: String) {
		router?.attachChatting(with: user)
	}
}
