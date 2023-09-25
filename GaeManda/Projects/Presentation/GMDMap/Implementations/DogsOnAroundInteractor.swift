//
//  DogsOnAroundInteractor.swift
//  DogsOnAroundImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap

protocol DogsOnAroundRouting: ViewableRouting { }

protocol DogsOnAroundPresentable: Presentable {
	var listener: DogsOnAroundPresentableListener? { get set }
}

final class DogsOnAroundInteractor:
	PresentableInteractor<DogsOnAroundPresentable>,
	DogsOnAroundInteractable,
	DogsOnAroundPresentableListener {
	weak var router: DogsOnAroundRouting?
	weak var listener: DogsOnAroundListener?
	
	override init(presenter: DogsOnAroundPresentable) {
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
