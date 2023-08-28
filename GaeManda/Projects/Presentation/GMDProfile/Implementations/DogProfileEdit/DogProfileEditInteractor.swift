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
	func didTapBackButton() {
		listener?.dogProfileEditBackButtonDidTap()
	}
}
