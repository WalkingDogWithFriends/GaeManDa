//
//  ChattingListInteractor.swift
//  ChattingImpl
//
//  Created by jung on 2023/08/16.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

protocol ChattingListRouting: ViewableRouting { }

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
