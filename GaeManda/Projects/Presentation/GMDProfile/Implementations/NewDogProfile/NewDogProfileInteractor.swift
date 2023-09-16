//
//  NewDogProfileInteractor.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import Entity
import GMDProfile
import UseCase

protocol NewDogProfileRouting: ViewableRouting { }

protocol NewDogProfilePresentable: Presentable {
	var listener: NewDogProfilePresentableListener? { get set }
}

protocol NewDogProfileInteractorDependency {
	var userProfileUseCase: UserProfileUseCase { get }
}

final class NewDogProfileInteractor:
	PresentableInteractor<NewDogProfilePresentable>,
	NewDogProfileInteractable,
	NewDogProfilePresentableListener {
	weak var router: NewDogProfileRouting?
	weak var listener: NewDogProfileListener?
	private let dependency: NewDogProfileInteractorDependency
	
	init(
		presenter: NewDogProfilePresentable,
		dependency: NewDogProfileInteractorDependency
	) {
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

// MARK: - PresentablListener
extension NewDogProfileInteractor {
	func didTapBackButton() {
		listener?.newDogProfileDidTapBackButton()
	}
	
	func didTapConfirmButton(dog: Dog) {
		dependency.userProfileUseCase
			.postNewDog(dog: dog)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, message in
				guard message == "success" else { return }

				owner.listener?.newDogProfileDidTapConfirmButton()
			}
			.disposeOnDeactivate(interactor: self)
		
		listener?.newDogProfileDidTapConfirmButton()
	}
}
