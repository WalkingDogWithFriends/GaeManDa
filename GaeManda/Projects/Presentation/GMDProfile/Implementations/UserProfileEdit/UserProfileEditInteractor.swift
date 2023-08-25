//
//  UserProfileEditInteractor.swift
//  GMDProfileImpl
//
//  Created by jung on 2023/07/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import Entity
import GMDProfile
import UseCase

protocol UserProfileEditRouting: ViewableRouting { }

protocol UserProfileEditPresentable: Presentable {
	var listener: UserProfileEditPresentableListener? { get set }
	
	func updateUsername(_ name: String)
	func updateUserSex(_ sex: Sex)
	
	func userNameIsEmpty()
}

protocol UserProfileEditInteractorDependency {
	var userProfileUseCase: UserProfileUseCase { get }
}

final class UserProfileEditInteractor:
	PresentableInteractor<UserProfileEditPresentable>,
	UserProfileEditInteractable,
	UserProfileEditPresentableListener {
	weak var router: UserProfileEditRouting?
	weak var listener: UserProfileEditListener?
	
	private let dependency: UserProfileEditInteractorDependency
	
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
		dependency.userProfileUseCase
			.userDependency
			.fetchUser(id: 0)
			.subscribe(with: self) { owner, user in
				owner.presenter.updateUsername(user.name)
				owner.presenter.updateUserSex(user.sex)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapBackbutton() {
		listener?.userProfileEditBackButtonDidTap()
	}
	
	func didTapEndEditingButton(name: String, sex: Sex) {
		print("\(name), \(sex)")
		if name.isEmpty {
			presenter.userNameIsEmpty()
		} else {
			dependency.userProfileUseCase
				.updateUser(nickName: name, age: 20, sex: sex.rawValue)
				.subscribe(with: self) { owner, result in
					guard result == "success" else { return }
					owner.listener?.userProfileEndEditing()
				}
				.disposeOnDeactivate(interactor: self)
		}
	}
}
