//
//  UserProfileInteractor.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxCocoa
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
	
	private let disposeBag: DisposeBag
	private let dependency: UserProfileInteractorDependency
	
	// MARK: Interactable Output
	var dogProfiles: Driver<[Dog]>
	var userName: Driver<String>
	var userSexAndAge: Driver<String>
	
	init(
		presenter: UserProfilePresentable,
		dependency: UserProfileInteractorDependency
	) {
		self.dependency = dependency
		self.disposeBag = DisposeBag()
		
		self.dogProfiles = dependency
			.userProfileUseCase
			.fetchDogs(id: 0)
			.ignoreTerminate()
			.asDriver(onErrorJustReturn: [])

		let users = dependency
			.userProfileUseCase
			.fetchUser(id: 0)
			.ignoreTerminate()
			.asDriver(onErrorJustReturn: User.defaultUser)
		
		self.userName = users.map { $0.name }
		self.userSexAndAge = users.map { "\($0.sex) \($0.age)세" }
		
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

// MARK: PresentableListener
extension UserProfileInteractor {
	func dogProfileEditButtonDidTap() {
		router?.dogProfileEditAttach()
	}
	
	func userProfileEditButtonDidTap() {
		router?.userProfileEditAttach()
	}
}

// MARK: UserProfileEditListener
extension UserProfileInteractor {
	func userProfileEditBackButtonDidTap() {
		router?.userProfileEditDetach()
	}
}

// MARK: DogProfileEditListener
extension UserProfileInteractor {
	func dogProfileEditBackButtonDidTap() {
		router?.dogProfileEditDetach()
	}
}
