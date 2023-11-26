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

final class DogCharacterPickerInteractor:
	PresentableInteractor<DogCharacterPickerPresentable>,
	DogCharacterPickerInteractable,
	DogCharacterPickerPresentableListener {
	weak var router: DogCharacterPickerRouting?
	weak var listener: DogCharacterPickerListener?
	
	var selectedId: [Int]
	var dogCharacters: [DogCharacter] = []
	
	init(
		presenter: DogCharacterPickerPresentable,
		dogCharacters: [DogCharacter],
		selectedId: [Int]?
	) {
		self.dogCharacters = dogCharacters
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

// MARK: - PresentableListener
extension DogCharacterPickerInteractor {
	func viewDidLoad() {
		let viewModel = convertToDogCharacterViewModels(from: dogCharacters)
		
		presenter.updateDogCharacterCell(viewModel)
	}
	
	func didTapConfirmButton(with selectedId: [Int]) {
		let selectedCharacters = selectedId
			.compactMap { id in dogCharacters.first { $0.id == id } }
		
		listener?.dogCharactersSelected(selectedCharacters)
	}
	
	func dismiss() {
		listener?.dogCharacterPickerDismiss()
	}
}

// MARK: - Private Method
private extension DogCharacterPickerInteractor {
	func convertToDogCharacterViewModels(from characters: [DogCharacter]) -> [DogCharacterViewModel] {
		return characters.map { dogCharacter in
			var viewModel = DogCharacterViewModel(dogCharacter: dogCharacter)
			
			if self.selectedId.contains(dogCharacter.id) {
				viewModel.isChoice = true
			}
			
			return viewModel
		}
	}
}
