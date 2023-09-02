//
//  DogProfileEditInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import Entity
import GMDProfile
import UseCase

protocol DogProfileEditRouting: ViewableRouting { }

protocol DogProfileEditPresentable: Presentable {
	var listener: DogProfileEditPresentableListener? { get set }
	
	func updateDogDashBoard(doges: [DogDashBoardViewModel])
	func updateDogName(_ name: String)
	func updateDogSex(_ sex: Sex)
	func updateDogWeight(_ weight: String)
	func updateDogNeutered(_ isNeutered: Bool)
	func updateDogCharacter(_ character: String)
	
	func updateTextFieldMode(_ modes: TextFieldModeViewModel)
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
	
	private let dogs = BehaviorRelay<[Dog]>(value: [])
	private let editDogId = BehaviorRelay<Int>(value: 0)
	private let dependency: DogProfileEditInteractorDependency
	
	init(
		presenter: DogProfileEditPresentable,
		dependency: DogProfileEditInteractorDependency,
		editDogId: Int
	) {
		self.dependency = dependency
		super.init(presenter: presenter)
		presenter.listener = self
		self.editDogId.accept(editDogId)
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
	func viewDidLoad() {
		bind()
	}
	
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
				.observe(on: MainScheduler.instance)
				.subscribe(with: self) { owner, result in
					guard result == "success" else { return }
					owner.listener?.dogProfileEndEditing()
				}
				.disposeOnDeactivate(interactor: self)
			return
		}
		var textFieldsMode = TextFieldModeViewModel()
		
		if dog.name.isEmpty {
			textFieldsMode.nickNameTextFieldMode = .warning
		}
		if dog.weight.isEmpty {
			textFieldsMode.dogWeightTextFieldMode = .warning
		}
		presenter.updateTextFieldMode(textFieldsMode)
	}
	
	func didTapDogDashBoard(at id: Int) {
		editDogId.accept(id)
	}
}

// MARK: - Interactor Logic
private extension DogProfileEditInteractor {
	func updateDogs() {
		dependency.userProfileUseCase
			.fetchDogs(id: 0)
			.subscribe(with: self) { owner, dogs in
				owner.dogs.accept(dogs)
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
	
	func bind() {
		let combineObservable = Observable.combineLatest(editDogId, dogs)
		
		combineObservable
			.map { id, dogs in
				dogs.map {
					DogDashBoardViewModel(
						dogId: $0.id,
						profileImage: "",
						isEdited: $0.id == id
					)
				}
			}
			.skip(1)
			.bind(with: self) { owner, viewModel in
				owner.presenter.updateDogDashBoard(doges: viewModel)
			}
			.disposeOnDeactivate(interactor: self)
		
		combineObservable
			.map { id, dogs in
				// id값으로 수정할 강아지를 찾습니다.
				dogs.first(where: { $0.id == id })
			}
			.skip(1)
			.bind(with: self) { owner, dog in
				guard let dog = dog else {
					// 해당 코드를 사용하면 에러가 납니다..
					// owner.listener?.dogProfileEditBackButtonDidTap()
					return
				}
				owner.updateEditDog(dog)
			}
			.disposeOnDeactivate(interactor: self)
	}
}
