//
//  DogCharacterDashboardInteractor.swift
//  CorePresentation
//
//  Created by jung on 12/5/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import CorePresentation
import Entity

protocol DogCharacterDashboardRouting: ViewableRouting { }

protocol DogCharacterDashboardPresentable: Presentable {
	var listener: DogCharacterDashboardPresentableListener? { get set }
	
	func updateDogCharacters(_ selectedCharacters: [DogCharacter])
}

final class DogCharacterDashboardInteractor:
	PresentableInteractor<DogCharacterDashboardPresentable>,
	DogCharacterDashboardInteractable,
	DogCharacterDashboardPresentableListener {
	weak var router: DogCharacterDashboardRouting?
	weak var listener: DogCharacterDashboardListener?
	
	private let selectedCharacters: BehaviorRelay<[DogCharacter]>
	private let disposeBag = DisposeBag()
	
	init(
		presenter: DogCharacterDashboardPresentable,
		selectedCharacters: BehaviorRelay<[DogCharacter]>
	) {
		self.selectedCharacters = selectedCharacters
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
extension DogCharacterDashboardInteractor {
	func viewDidLoad() {
		selectedCharacters
			.bind(with: self) { owner, characters in
				owner.presenter.updateDogCharacters(characters)
			}
			.disposed(by: disposeBag)
	}
	
	func didTapAddDogCharacterButton() {
		listener?.didTapAddCharacterButton()
	}
	
	func deletedDogCharacterAt(id: Int) {
		var characters = selectedCharacters.value
		
		let deleteCharacterIndex = characters.enumerated()
			.first { $0.1.id == id }
			.map { $0.0 }
		
		guard let deleteCharacterIndex = deleteCharacterIndex else { return }
		
		characters.remove(at: deleteCharacterIndex)
		
		selectedCharacters.accept(characters)
	}
}
