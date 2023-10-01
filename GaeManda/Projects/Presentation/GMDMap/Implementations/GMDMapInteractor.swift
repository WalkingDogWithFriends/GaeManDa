//
//  GMDMapInteractor.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap

protocol GMDMapRouting: ViewableRouting { }

protocol GMDMapPresentable: Presentable {
	var listener: GMDMapPresentableListener? { get set }
}

final class GMDMapInteractor:
	PresentableInteractor<GMDMapPresentable>,
	GMDMapInteractable,
	GMDMapPresentableListener {
	weak var router: GMDMapRouting?
	weak var listener: GMDMapListener?
	
	override init(presenter: GMDMapPresentable) {
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
