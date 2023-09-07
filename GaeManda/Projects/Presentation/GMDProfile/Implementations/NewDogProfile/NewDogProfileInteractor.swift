//
//  NewDogProfileInteractor.swift
//  GMDProfile
//
//  Created by jung on 2023/09/05.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDProfile

protocol NewDogProfileRouting: ViewableRouting { }

protocol NewDogProfilePresentable: Presentable {
	var listener: NewDogProfilePresentableListener? { get set }
}

final class NewDogProfileInteractor:
	PresentableInteractor<NewDogProfilePresentable>,
	NewDogProfileInteractable,
	NewDogProfilePresentableListener {
	weak var router: NewDogProfileRouting?
	weak var listener: NewDogProfileListener?
	
	override init(presenter: NewDogProfilePresentable) {
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

// MARK: - PresentablListener
extension NewDogProfileInteractor {
	func didTapBackButton() {
		listener?.newDogProfileDidTapBackButton()
	}
	
	func didTapConfirmButton() {
		// 서버에 보내는 로직 추가
		listener?.newDogProfileDidTapConfirmButton()
	}
}
