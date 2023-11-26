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
	var gmdProfileUseCase: GMDProfileUseCase { get }
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
	
	func dismiss() {
		listener?.newDogProfileDismiss()
	}
	
	func didTapConfirmButton(dog: Dog) {
		dependency.gmdProfileUseCase
			.createDog(dog)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, _ in
				owner.listener?.newDogProfileDidTapConfirmButton()
			}
			.disposeOnDeactivate(interactor: self)
		
		listener?.newDogProfileDidTapConfirmButton()
	}
}
