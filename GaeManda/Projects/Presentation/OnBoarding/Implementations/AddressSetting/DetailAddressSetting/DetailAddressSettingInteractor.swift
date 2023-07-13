//
//  DetailAddressSettingInteractor.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import OnBoarding
import Utils

protocol DetailAddressSettingRouting: ViewableRouting { }

protocol DetailAddressSettingPresentable: Presentable {
	var listener: DetailAddressSettingPresentableListener? { get set }
}

final class DetailAddressSettingInteractor:
	PresentableInteractor<DetailAddressSettingPresentable>,
	DetailAddressSettingInteractable,
	DetailAddressSettingPresentableListener {
	weak var router: DetailAddressSettingRouting?
	weak var listener: DetailAddressSettingListener?

	override init(presenter: DetailAddressSettingPresentable) {
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
extension DetailAddressSettingInteractor {
	func detailAddressSettingDidDismiss() {
		listener?.detailAddressSettingDidDismiss()
	}
	
	func closeButtonDidTap() {
		listener?.detailAddressSettingCloseButtonDidTap()
	}
	
	func loadLocationButtonDidTap() {
		print("loadLocationButtonDidTap")
	}
}
