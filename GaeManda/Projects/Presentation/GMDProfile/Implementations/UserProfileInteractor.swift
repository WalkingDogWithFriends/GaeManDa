//
//  UserProfileInteractor.swift
//  ProfileImpl
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

protocol UserProfileRouting: ViewableRouting {
	func userProfileEditAttach()
	func userProfileEditDetach()
	func dogProfileEditAttach(selectedId: Int)
	func dogProfileEditDetach()
}

protocol UserProfilePresentable: Presentable {
	var listener: UserProfilePresentableListener? { get set }
	
	func updateUserName(_ name: String)
	func updateUserSexAndAge(_ sexAndAge: String)
	func updateDogs(with viewModel: DogsCarouselViewModel)
}

protocol UserProfileInteractorDependency {
	var userProfileUseCase: UserProfileUseCase { get }
}

final class UserProfileInteractor:
	PresentableInteractor<UserProfilePresentable>,
	UserProfileInteractable,
	UserProfilePresentableListener {
	weak var router: UserProfileRouting?
	weak var listener: UserProfileListener?

	private let dependency: UserProfileInteractorDependency
	
	init(
		presenter: UserProfilePresentable,
		dependency: UserProfileInteractorDependency
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
extension UserProfileInteractor {
	func viewWillAppear() {
		fetchUser()
		fetchDogs()
	}
	
	func didTapDogProfileEditButton(at id: Int) {
		router?.dogProfileEditAttach(selectedId: id)
	}
	
	func didTapNewDogButton() { }
	
	func didTapDogProfileDeleteButton() { }
	
	func didTapUserProfileEditButton() {
		router?.userProfileEditAttach()
	}
}

// MARK: - UserProfileEditListener
extension UserProfileInteractor {
	func userProfileEditBackButtonDidTap() {
		router?.userProfileEditDetach()
	}
	
	func userProfileEndEditing() {
		router?.userProfileEditDetach()
	}
}

// MARK: - DogProfileEditListener
extension UserProfileInteractor {
	func dogProfileEditBackButtonDidTap() {
		router?.dogProfileEditDetach()
	}
	
	func dogProfileEndEditing() {
		router?.dogProfileEditDetach()
	}
}

// MARK: - Fetch Data From Dependency
private extension UserProfileInteractor {
	func fetchUser() {
		dependency.userProfileUseCase
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
		dependency.userProfileUseCase
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
private extension UserProfileInteractor {
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
