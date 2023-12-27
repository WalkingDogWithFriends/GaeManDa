//
//  UserProfileEditInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RIBs
import RxSwift
import RxRelay
import CorePresentation
import Entity
import GMDProfile
import UseCase

protocol UserProfileEditRouting: ViewableRouting {
	func attachUserProfileDashboard(
		usernameTextFieldModeRelay: BehaviorRelay<NicknameTextFieldMode>,
		birthdayTextFieldIsWarningRelay: BehaviorRelay<Bool>
	)
}

protocol UserProfileEditPresentable: Presentable {
	var listener: UserProfileEditPresentableListener? { get set }
}

protocol UserProfileEditInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class UserProfileEditInteractor:
	PresentableInteractor<UserProfileEditPresentable>,
	UserProfileEditInteractable,
	UserProfileEditPresentableListener {
	weak var router: UserProfileEditRouting?
	weak var listener: UserProfileEditListener?
	
	private let dependency: UserProfileEditInteractorDependency
	
	private let userNameTextFieldMode = BehaviorRelay<NicknameTextFieldMode>(value: .valid)
	private let birthdayTextFieldIsWarning = BehaviorRelay<Bool>(value: true)
	
	init(
		presenter: UserProfileEditPresentable,
		dependency: UserProfileEditInteractorDependency
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

// MARK: PresentableListener
extension UserProfileEditInteractor {
	func viewWillAppear() {
		router?.attachUserProfileDashboard(
			usernameTextFieldModeRelay: userNameTextFieldMode,
			birthdayTextFieldIsWarningRelay: birthdayTextFieldIsWarning
		)
		
		dependency.gmdProfileUseCase
			.fetchUser()
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { _, _ in
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapBackbutton() {
		listener?.userProfileEditDidTapBackButton()
	}
	
	func dismiss() {
		listener?.userProfileEditDismiss()
	}
	
	func didTapEndEditingButton(name: String, sex: Gender) {
		// 추후 Profile페이지 시에 수정 예정
		let user = User(
			id: 0, name: name, gender: sex, address: Location(latitude: 0, longitude: 0), birthday: "", profileImage: ""
		)
		
		debugPrint(name, sex)
		dependency.gmdProfileUseCase
			.updateUser(user, isProfileImageChanged: true)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, _ in
				owner.listener?.gmdProfileEndEditing()
			}
			.disposeOnDeactivate(interactor: self)
	}
}

// MARK: - UserProfileDashboardListener
extension UserProfileEditInteractor {
	func didSelectedGender(_ gender: Gender) { }
	
	func didEnteredUserName(_ name: String) { }
	
	func didSelectedBirthday(_ date: String) { }
}
