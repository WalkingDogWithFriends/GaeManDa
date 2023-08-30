//
//  DogProfileEditInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxSwift
import Entity
import GMDProfile
import UseCase

protocol DogProfileEditRouting: ViewableRouting { }

protocol DogProfileEditPresentable: Presentable {
	var listener: DogProfileEditPresentableListener? { get set }
	
	func updateDogDashBoard(doges: [Dog], editIndex: Int)
	func updateDogName(_ name: String)
	func updateDogSex(_ sex: Sex)
	func updateDogWeight(_ weight: String)
	func updateDogNeutered(_ isNeutered: Bool)
	func updateDogCharacter(_ character: String)
	
	func dogNameIsEmpty()
	func dogWeightIsEmpty()
}

protocol DogProfileEditInteractorDependency {
	var userProfileUseCase: UserProfileUseCase { get }
}

final class DogProfileEditInteractor:
	PresentableInteractor<DogProfileEditPresentable>,
	DogProfileEditInteractable,
	DogProfileEditPresentableListener {
	weak var router: DogProfileEditRouting?
	weak var listener: DogProfileEditListener?
	
	private let dependency: DogProfileEditInteractorDependency
	private var editDogId: Int
	
	init(
		presenter: DogProfileEditPresentable,
		dependency: DogProfileEditInteractorDependency,
		editDogId: Int
	) {
		self.editDogId = editDogId
		self.dependency = dependency
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
extension DogProfileEditInteractor {
	func viewWillAppear() {
		updateDogs()
	}
	
	func didTapBackButton() {
		listener?.dogProfileEditBackButtonDidTap()
	}
	
	func didTapEndEditButton(dog: Dog) {
		if !dog.name.isEmpty && !dog.weight.isEmpty {
			dependency.userProfileUseCase
				.updateDog(dog: dog)
				.subscribe(with: self) { owner, result in
					guard result == "success" else { return }
					owner.listener?.dogProfileEndEditing()
				}
				.disposeOnDeactivate(interactor: self)
			return
		}
		
		if dog.name.isEmpty {
			presenter.dogNameIsEmpty()
		}
		if dog.weight.isEmpty {
			presenter.dogWeightIsEmpty()
		}
	}
	
	func didTapDogDashBoard(at id: Int) {
		self.editDogId = id
		updateDogs()
	}
}

// MARK: - Interactor Logic
private extension DogProfileEditInteractor {
	func updateDogs() {
		dependency.userProfileUseCase
			.fetchDogs(id: 0)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, dogs in
				if let dog = dogs.first(where: { $0.id == owner.editDogId }) {
					owner.updateEditDog(dog)
				} else {
					// 해당 id의 강아지가 없는 경우 1번째 강아지로 대체
					owner.editDogId = dogs[0].id
					owner.updateEditDog(dogs[0])
				}
				// Update DogDashBoard
				owner.presenter.updateDogDashBoard(
					doges: dogs,
					editIndex: owner.editDogId
				)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func updateEditDog(_ dog: Dog) {
		presenter.updateDogName(dog.name)
		presenter.updateDogSex(dog.sex)
		presenter.updateDogWeight(dog.weight)
		presenter.updateDogNeutered(dog.didNeutered)
		presenter.updateDogCharacter(dog.character)
	}
}
