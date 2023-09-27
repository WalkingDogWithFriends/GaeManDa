//
//  GMDProfileInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxSwift
import Entity
import GMDProfile
import GMDUtils
import UseCase

protocol GMDProfileRouting: ViewableRouting {
	func userProfileEditAttach()
	func userProfileEditDetach()
	func userProfileEditDismiss()
	func dogProfileEditAttach(selectedId: Int)
	func dogProfileEditDetach()
	func dogProfileEditDismiss()
	func newDogProfileAttach()
	func newDogProfileDetach()
	func newDogProfileDismiss()
}

protocol GMDProfilePresentable: Presentable {
	var listener: GMDProfilePresentableListener? { get set }
	
	func updateUserName(_ name: String)
	func updateUserSexAndAge(_ sexAndAge: String)
	func updateDogs(with viewModel: DogsCarouselViewModel)
}

protocol GMDProfileInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class GMDProfileInteractor:
	PresentableInteractor<GMDProfilePresentable>,
	GMDProfileInteractable,
	GMDProfilePresentableListener {
	weak var router: GMDProfileRouting?
	weak var listener: GMDProfileListener?

	private let dependency: GMDProfileInteractorDependency
	
	init(
		presenter: GMDProfilePresentable,
		dependency: GMDProfileInteractorDependency
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

// MARK: - PresentableListener
extension GMDProfileInteractor {
	func viewWillAppear() {
		fetchUser()
		fetchDogs()
	}
	
	func didTapDogProfileEditButton(at id: Int) {
		router?.dogProfileEditAttach(selectedId: id)
	}
	
	func didTapNewDogButton() {
		router?.newDogProfileAttach()
	}
	
	func didTapDogProfileDeleteButton() { }
	
	func didTapUserProfileEditButton() {
		router?.userProfileEditAttach()
	}
}

// MARK: - UserProfileEditListener
extension GMDProfileInteractor {
	func userProfileEditDidTapBackButton() {
		router?.userProfileEditDetach()
	}
	
	func userProfileEditDismiss() {
		router?.userProfileEditDismiss()
	}
	
	func gmdProfileEndEditing() {
		router?.userProfileEditDetach()
	}
}

// MARK: - DogProfileEditListener
extension GMDProfileInteractor {
	func dogProfileEditDidTapBackButton() {
		router?.dogProfileEditDetach()
	}
	
	func dogProfileEditDismiss() {
		router?.dogProfileEditDismiss()
	}
	
	func dogProfileEndEditing() {
		router?.dogProfileEditDetach()
	}
}

// MARK: - NewDogProfileListener
extension GMDProfileInteractor {
	func newDogProfileDidTapBackButton() {
		router?.newDogProfileDetach()
	}
	
	func newDogProfileDismiss() {
		router?.newDogProfileDismiss()
	}
	
	func newDogProfileDidTapConfirmButton() {
		router?.newDogProfileDetach()
	}
}

// MARK: - Fetch Data From Dependency
private extension GMDProfileInteractor {
	func fetchUser() {
		dependency.gmdProfileUseCase
			.userDependency
			.fetchUser(id: 0)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, user in
				let sexAndAge = "\(user.sex.rawValue) \(user.age)세"

				owner.presenter.updateUserName(user.name)
				owner.presenter.updateUserSexAndAge(sexAndAge)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func fetchDogs() {
		dependency.gmdProfileUseCase
			.dogDependency
			.fetchDogs(id: 0)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, dogs in
				let dogsCarousel = owner.convertToDogsCarousel(with: dogs)
				let viewMoel = DogsCarouselViewModel(dogs: dogsCarousel)
				owner.presenter.updateDogs(with: viewMoel)
			}
			.disposeOnDeactivate(interactor: self)
	}
}

// MARK: - Interactor Logic
private extension GMDProfileInteractor {
	func convertToDogsCarousel(with dogs: [Dog]) -> [Dog] {
		guard
			let last = dogs.last,
			let first = dogs.first
		else {
			return dogs
		}

		return [last] + dogs + [first]
	}
}
