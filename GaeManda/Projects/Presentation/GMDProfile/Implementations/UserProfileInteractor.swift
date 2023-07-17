//
//  UserProfileInteractor.swift
//  ProfileImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol UserProfileRouting: ViewableRouting { }

protocol UserProfilePresentable: Presentable {
	var listener: UserProfilePresentableListener? { get set }
}

final class UserProfileInteractor:
	PresentableInteractor<UserProfilePresentable>,
	UserProfileInteractable,
	UserProfilePresentableListener {
	weak var router: UserProfileRouting?
	weak var listener: UserProfileListener?
	
	override init(presenter: UserProfilePresentable) {
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
