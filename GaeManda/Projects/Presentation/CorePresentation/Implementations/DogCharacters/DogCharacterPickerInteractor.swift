//
//  DogCharacterPickerInteractor.swift
//  CorePresentation
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import CorePresentation
import Entity
import UseCase

protocol DogCharacterPickerRouting: ViewableRouting { }

protocol DogCharacterPickerPresentable: Presentable {
	var listener: DogCharacterPickerPresentableListener? { get set }
	
	func updateDogCharacterCell(_ viewModel: [DogCharacterViewModel])
}

protocol DogCharacterPickerInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class DogCharacterPickerInteractor:
	PresentableInteractor<DogCharacterPickerPresentable>,
	DogCharacterPickerInteractable,
	DogCharacterPickerPresentableListener {
	weak var router: DogCharacterPickerRouting?
	weak var listener: DogCharacterPickerListener?
	
	var dependency: DogCharacterPickerInteractorDependency
	var selectedId: [Int]
	
	init(
		presenter: DogCharacterPickerPresentable,
		dependency: DogCharacterPickerInteractorDependency,
		selectedId: [Int]?
	) {
		self.dependency = dependency
		self.selectedId = selectedId ?? []
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
