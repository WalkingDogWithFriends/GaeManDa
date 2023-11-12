//
//  TermsBottomSheetRouter.swift
//  OnBoarding
//
//  Created by 김영균 on 11/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

protocol TermsBottomSheetInteractable: Interactable {
	var router: TermsBottomSheetRouting? { get set }
	var listener: TermsBottomSheetListener? { get set }
}

protocol TermsBottomSheetViewControllable: ViewControllable {}

final class TermsBottomSheetRouter:
	ViewableRouter<TermsBottomSheetInteractable,
	TermsBottomSheetViewControllable>,
	TermsBottomSheetRouting {
	override init(interactor: TermsBottomSheetInteractable, viewController: TermsBottomSheetViewControllable) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
