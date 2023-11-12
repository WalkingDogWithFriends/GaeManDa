//
//  TermsBottomSheetInteractor.swift
//  OnBoarding
//
//  Created by 김영균 on 11/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxSwift
import OnBoarding

public protocol TermsBottomSheetRouting: ViewableRouting {}

protocol TermsBottomSheetPresentable: Presentable {
	var listener: TermsBottomSheetPresentableListener? { get set }
	
	func setTextView(text: String?)
}

final class TermsBottomSheetInteractor:
	PresentableInteractor<TermsBottomSheetPresentable>,
	TermsBottomSheetInteractable,
	TermsBottomSheetPresentableListener {
	weak var router: TermsBottomSheetRouting?
	weak var listener: TermsBottomSheetListener?
	
	private let type: BottomSheetType
	private var terms: String?
	
	init(presenter: TermsBottomSheetPresentable, type: BottomSheetType, terms: String?) {
		self.type = type
		self.terms = terms
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

// MARK: TermsBottomSheetPresentableListener
extension TermsBottomSheetInteractor {
	func viewDidLoad() {
		presenter.setTextView(text: terms)
	}
	
	func dismiss() {
		listener?.termsBottomSheetDismiss()
	}
	
	func didTapConfirmButton() {
		listener?.termsBottomSheetDidFinish(type: type)
	}
}
