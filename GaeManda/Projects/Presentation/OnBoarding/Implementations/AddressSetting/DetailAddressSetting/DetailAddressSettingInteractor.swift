//
//  DetailAddressSettingInteractor.swift
//  OnBoarding
//
//  Created by jung on 2023/07/08.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import RxSwift
import GMDUtils
import OnBoarding
import UseCase

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
	
	private let detailAddressUseCase: DetailAddressSettingUseCase
	
	init(presenter: DetailAddressSettingPresentable, detailAddressUseCase: DetailAddressSettingUseCase) {
		self.detailAddressUseCase = detailAddressUseCase
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
	
	func loadLocationButtonDidTap(jibunAddress: String) {
		detailAddressUseCase.fetchGeocode(for: jibunAddress)
			.observe(on: MainScheduler.instance)
			.subscribe(
				with: self,
				onSuccess: { owner, coordinate in
					owner.listener?.detailAddressSettingLoadLocationButtonDidTap(
						latitude: coordinate.latitude,
						longitude: coordinate.longitude
					)
				},
				onFailure: { _, error in
					print(error)
				}
			)
			.disposeOnDeactivate(interactor: self)
	}
}
