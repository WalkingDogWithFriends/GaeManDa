//
//  DogCharacterPickerInteractor.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import CorePresentation

protocol DogCharacterPickerRouting: ViewableRouting { }

protocol DogCharacterPickerPresentable: Presentable {
	var listener: DogCharacterPickerPresentableListener? { get set }
}

final class DogCharacterPickerInteractor:
	PresentableInteractor<DogCharacterPickerPresentable>,
	DogCharacterPickerInteractable,
	DogCharacterPickerPresentableListener {
	weak var router: DogCharacterPickerRouting?
	weak var listener: DogCharacterPickerListener?
	
	override init(presenter: DogCharacterPickerPresentable) {
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
