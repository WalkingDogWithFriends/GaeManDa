//
//  LoggedInInteractor.swift
//  Dev-GaeManda
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs

protocol LoggedInRouting: ViewableRouting {
	func attachTabs()
}

protocol LoggedInPresentable: Presentable {
	var listener: LoggedInPresentableListener? { get set }
}

protocol LoggedInListener: AnyObject { }

final class LoggedInInteractor:
	PresentableInteractor<LoggedInPresentable>,
	LoggedInInteractable,
	LoggedInPresentableListener {
	weak var router: LoggedInRouting?
	weak var listener: LoggedInListener?
	
	override init(presenter: LoggedInPresentable) {
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		
		router?.attachTabs()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}
