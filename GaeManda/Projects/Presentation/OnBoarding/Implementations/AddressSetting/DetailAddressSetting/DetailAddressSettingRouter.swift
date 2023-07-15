//
//  DetailAddressSettingRouter.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding

protocol DetailAddressSettingInteractable: Interactable {
	var router: DetailAddressSettingRouting? { get set }
	var listener: DetailAddressSettingListener? { get set }
}

protocol DetailAddressSettingViewControllable: ViewControllable { }

final class DetailAddressSettingRouter:
	ViewableRouter<DetailAddressSettingInteractable,
	DetailAddressSettingViewControllable>,
	DetailAddressSettingRouting {
	override init(
		interactor: DetailAddressSettingInteractable,
		viewController: DetailAddressSettingViewControllable
	) {
		super.init(interactor: interactor, viewController: viewController)
		interactor.router = self
	}
}
