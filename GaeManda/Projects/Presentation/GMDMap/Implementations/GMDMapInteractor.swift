//
//  GMDMapInteractor.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import RIBs
import GMDMap
import GMDUtils

protocol GMDMapRouting: ViewableRouting { }

protocol GMDMapPresentable: Presentable {
	var listener: GMDMapPresentableListener? { get set }
	
	func updateCameraPosition(lat: Double, lng: Double)
	func openPermissionSettings()
}

final class GMDMapInteractor:
	PresentableInteractor<GMDMapPresentable>,
	GMDMapInteractable,
	GMDMapPresentableListener {
	weak var router: GMDMapRouting?
	weak var listener: GMDMapListener?
	
	private let locaitonManagable: CLLocationManagable
	
	init(
		presenter: GMDMapPresentable,
		locaitonManagable: CLLocationManagable
	) {
		self.locaitonManagable = locaitonManagable
		super.init(presenter: presenter)
		presenter.listener = self
	}
	
	override func didBecomeActive() {
		super.didBecomeActive()
		bindLocationManager()
	}
	
	override func willResignActive() {
		super.willResignActive()
	}
}

private extension GMDMapInteractor {
	func bindLocationManager() {
		locaitonManagable.locationManager.rx.didChangeAuthorization
			.bind(with: self) { owner, clLocationEvent in
				switch clLocationEvent.status {
				case .notDetermined: clLocationEvent.manager.requestWhenInUseAuthorization()
				case .denied, .restricted: owner.presenter.openPermissionSettings()
				default: break
				}
			}
			.disposeOnDeactivate(interactor: self)
		
		locaitonManagable.locationManager.rx.didUpdateLocations
			.filter { !$0.locations.isEmpty }
			.compactMap { $0.locations.last }
			.debug()
			.bind(with: self) { owner, location in
				let lat = location.coordinate.latitude.magnitude
				let lng = location.coordinate.longitude.magnitude
				owner.presenter.updateCameraPosition(lat: lat, lng: lng)
			}
			.disposeOnDeactivate(interactor: self)
	}
}
