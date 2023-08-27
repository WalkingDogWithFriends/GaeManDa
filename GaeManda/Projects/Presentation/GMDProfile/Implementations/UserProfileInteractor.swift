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
	func dogProfileEditAttach()
	func dogProfileEditDetach()
}

protocol UserProfilePresentable: Presentable {
	var listener: UserProfilePresentableListener? { get set }
	
	func updateUserName(_ name: String)
	func updateUserSexAndAge(_ sexAndAge: String)
	func updateDogs(_ dogs: [Dog])
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
	
	func didTapDogProfileEditButton() {
		router?.dogProfileEditAttach()
	}
	
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
				owner.presenter.updateDogs(dogs)
			}
			.disposeOnDeactivate(interactor: self)
	}
}
