//
//  ChattingInteractor.swift
//  ChattingImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Chatting

protocol ChattingRouting: ViewableRouting { }

protocol ChattingPresentable: Presentable {
	var listener: ChattingPresentableListener? { get set }
}

final class ChattingInteractor:
	PresentableInteractor<ChattingPresentable>,
	ChattingInteractable,
	ChattingPresentableListener {
	weak var router: ChattingRouting?
	weak var listener: ChattingListener?
	
	override init(presenter: ChattingPresentable) {
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
