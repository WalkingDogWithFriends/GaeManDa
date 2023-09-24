//
//  UserProfileEditInteractor.swift
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

protocol UserProfileEditRouting: ViewableRouting { }

protocol UserProfileEditPresentable: Presentable {
	var listener: UserProfileEditPresentableListener? { get set }
	
	func updateUsername(_ name: String)
	func updateUserSex(_ sex: Sex)
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
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, user in
				owner.presenter.updateUsername(user.name)
				owner.presenter.updateUserSex(user.sex)
			}
			.disposeOnDeactivate(interactor: self)
	}
	
	func didTapBackbutton() {
		listener?.userProfileEditDidTapBackButton()
	}
	
	func dismiss() {
		listener?.userProfileEditDismiss()
	}
	
	func didTapEndEditingButton(name: String, sex: Sex) {
		debugPrint(name, sex)
		dependency.userProfileUseCase
			.updateUser(nickName: name, age: 20, sex: sex.rawValue)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, result in
				guard result == "success" else { return }
				owner.listener?.userProfileEndEditing()
			}
			.disposeOnDeactivate(interactor: self)
	}
}
