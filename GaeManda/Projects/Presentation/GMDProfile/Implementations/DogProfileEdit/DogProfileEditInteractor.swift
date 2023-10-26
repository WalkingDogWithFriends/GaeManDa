//
//  DogProfileEditInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import Entity
import GMDProfile
import UseCase
import GMDExtensions

protocol DogProfileEditRouting: ViewableRouting { }

protocol DogProfileEditPresentable: Presentable {
	var listener: DogProfileEditPresentableListener? { get set }
	
	func updateDogName(_ name: String)
	func updateDogSex(_ sex: Sex)
	func updateDogWeight(_ weight: String)
	func updateDogNeutered(_ isNeutered: Neutered)
	func updateDogCharacter(_ character: String)
	func updateDog(_ dog: Dog)
}

protocol DogProfileEditInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class DogProfileEditInteractor:
	PresentableInteractor<DogProfileEditPresentable>,
	DogProfileEditInteractable,
	DogProfileEditPresentableListener {
	weak var router: DogProfileEditRouting?
	weak var listener: DogProfileEditListener?
	
	private let dependency: DogProfileEditInteractorDependency
	private let editDogId: BehaviorRelay<Int>
	private let dogs = BehaviorRelay<[Dog]>(value: [])
	
	init(
		presenter: DogProfileEditPresentable,
		dependency: DogProfileEditInteractorDependency,
		editDogId: Int
	) {
		self.dependency = dependency
		self.editDogId = BehaviorRelay(value: editDogId)
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
	func viewDidLoad() {
//		bind()
	}
	
	func viewWillAppear() {
		updateDogs()
	}
	
	func didTapBackButton() {
		listener?.dogProfileEditDidTapBackButton()
	}
	
	func dismiss() {
		listener?.dogProfileEditDismiss()
	}
	
	func didTapEndEditButton(dog: Dog) {
		dependency.gmdProfileUseCase
			.updateDog(dog: dog)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, _ in
				owner.listener?.dogProfileEndEditing()
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapDogDashBoard(at id: Int) {
		editDogId.accept(id)
	}
}

// MARK: - Interactor Logic
private extension DogProfileEditInteractor {
	func updateDogs() {
		if let dogs = UserDefaultsManager.shared
			.getDogs() {
				if let dog = dogs.first(where: { $0.id == self.editDogId.value }) {
					presenter.updateDog(dog)
				}
			}
		
//		dependency.gmdProfileUseCase
//			.fetchDogs(id: 0)
//			.subscribe(with: self) { owner, dogs in
//				owner.dogs.accept(dogs)
//			}
//			.disposeOnDeactivate(interactor: self)
	}
	
	func updateEditDog(_ dog: Dog) {
		presenter.updateDogName(dog.name)
		presenter.updateDogSex(dog.sex)
		presenter.updateDogWeight(dog.weight)
		presenter.updateDogNeutered(dog.didNeutered)
		presenter.updateDogCharacter(dog.character)
	}
	
	func bind() {
//		let combineObservable = Observable
//			.combineLatest(editDogId, dogs)
//			.share()
//		
//		combineObservable
//			.map { id, dogs in
//				dogs.map {
//					DogDashBoardViewModel(
//						dogId: $0.id,
//						profileImage: "",
//						isEdited: $0.id == id
//					)
//				}
//			}
//			.bind(with: self) { owner, viewModels in
//				owner.presenter.updateDogDashBoard(dogViewModels: viewModels)
//			}
//			.disposeOnDeactivate(interactor: self)
//		
//		combineObservable
//			.map { id, dogs in
//				// id값으로 수정할 강아지를 찾습니다.
//				dogs.first(where: { $0.id == id })
//			}
//			.bind(with: self) { owner, dog in
//				guard let dog = dog else {
//					// 해당 코드를 사용하면 에러가 납니다..
//					// owner.listener?.dogProfileEditBackButtonDidTap()
//					return
//				}
//				owner.updateEditDog(dog)
//			}
//			.disposeOnDeactivate(interactor: self)
	}
}
