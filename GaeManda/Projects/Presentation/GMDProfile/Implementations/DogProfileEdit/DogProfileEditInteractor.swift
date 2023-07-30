//
//  DogProfileEditInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol DogProfileEditRouting: ViewableRouting { }

protocol DogProfileEditPresentable: Presentable {
	var listener: DogProfileEditPresentableListener? { get set }
}

final class DogProfileEditInteractor:
	PresentableInteractor<DogProfileEditPresentable>,
	DogProfileEditInteractable,
	DogProfileEditPresentableListener {
	weak var router: DogProfileEditRouting?
	weak var listener: DogProfileEditListener?
	
	override init(presenter: DogProfileEditPresentable) {
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
