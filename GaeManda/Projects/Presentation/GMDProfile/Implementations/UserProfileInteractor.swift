//
//  UserProfileInteractor.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile
import RxCocoa
import RxSwift
import Entity
import UseCase

protocol UserProfileRouting: ViewableRouting { }

protocol UserProfilePresentable: Presentable {
	var listener: UserProfilePresentableListener? { get set }
	
	var dogsProfile: BehaviorSubject<[Dog]> { get }
	var userProfile: BehaviorSubject<User> { get }
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
	
	init(
		presenter: UserProfilePresentable,
		dependency: UserProfileInteractorDependency
	) {
		self.dependency = dependency
		self.disposeBag = DisposeBag()
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		
		Task {
			await dependency
				.userProfileUseCase
				.fetchDogs(id: 0)
				.subscribe(onSuccess: presenter.dogsProfile.onNext)
				.disposed(by: disposeBag)
			
			await dependency
				.userProfileUseCase
				.fetchUser(id: 0)
				.subscribe(onSuccess: presenter.userProfile.onNext)
				.disposed(by: disposeBag)
		}
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}
