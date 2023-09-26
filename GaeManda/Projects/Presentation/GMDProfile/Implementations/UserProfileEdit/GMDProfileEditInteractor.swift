//
//  GMDProfileEditInteractor.swift
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

protocol GMDProfileEditRouting: ViewableRouting { }

protocol GMDProfileEditPresentable: Presentable {
	var listener: GMDProfileEditPresentableListener? { get set }
	
	func updateUsername(_ name: String)
	func updateUserSex(_ sex: Sex)
}

protocol GMDProfileEditInteractorDependency {
	var gmdProfileUseCase: GMDProfileUseCase { get }
}

final class GMDProfileEditInteractor:
	PresentableInteractor<GMDProfileEditPresentable>,
	GMDProfileEditInteractable,
	GMDProfileEditPresentableListener {
	weak var router: GMDProfileEditRouting?
	weak var listener: GMDProfileEditListener?
	
	private let dependency: GMDProfileEditInteractorDependency
	
	init(
		presenter: GMDProfileEditPresentable,
		dependency: GMDProfileEditInteractorDependency
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
extension GMDProfileEditInteractor {
	func viewWillAppear() {
		dependency.gmdProfileUseCase
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
		listener?.gmdProfileEditDidTapBackButton()
	}
	
	func dismiss() {
		listener?.gmdProfileEditDismiss()
	}
	
	func didTapEndEditingButton(name: String, sex: Sex) {
		debugPrint(name, sex)
		dependency.gmdProfileUseCase
			.updateUser(nickName: name, age: 20, sex: sex.rawValue)
			.observe(on: MainScheduler.instance)
			.subscribe(with: self) { owner, result in
				guard result == "success" else { return }
				owner.listener?.gmdProfileEndEditing()
			}
			.disposeOnDeactivate(interactor: self)
	}
}
