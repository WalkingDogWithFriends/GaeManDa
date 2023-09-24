//
//  BirthdayPickerRouter.swift
//  OnBoardingImpl
//
//  Created by 김영균 on 9/23/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

protocol BirthdayPickerInteractable: Interactable {
	var router: BirthdayPickerRouting? { get set }
	var listener: BirthdayPickerListener? { get set }
}

protocol BirthdayPickerViewControllable: ViewControllable {}

final class BirthdayPickerRouter:
	ViewableRouter<BirthdayPickerInteractable, BirthdayPickerViewControllable>,
	BirthdayPickerRouting {
	override init(
		interactor: BirthdayPickerInteractable,
		viewController: BirthdayPickerViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
