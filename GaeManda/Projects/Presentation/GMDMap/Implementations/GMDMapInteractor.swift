//
//  GMDMapInteractor.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import RIBs
import GMDMap
import GMDClustering
import GMDUtils

protocol GMDMapRouting: ViewableRouting {
	func attachMapUser(with mapUser: [GMDMapViewModel])
	func detachMapUser()
}

protocol GMDMapPresentable: Presentable {
	var listener: GMDMapPresentableListener? { get set }
	
	func updateCameraPosition(lat: Double, lng: Double)
	func openPermissionSettings()
	
	func drawMarkers(_ markers: [CentroidMarker])
}

final class GMDMapInteractor:
	PresentableInteractor<GMDMapPresentable>,
	GMDMapInteractable {
	weak var router: GMDMapRouting?
	weak var listener: GMDMapListener?
	
	private let locaitonManagable: CLLocationManagable
	private let clustering = Clustering<GMDMapViewModel>()
	
	init(
		presenter: GMDMapPresentable,
		locaitonManagable: CLLocationManagable
	) {
		self.locaitonManagable = locaitonManagable
		super.init(presenter: presenter)
		presenter.listener = self
		clustering.delegate = self
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
		// 위치 정보에 대한 권한이 바뀔때 권한 요청을 다시 진행.
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

// MARK: - GMDMapPresentableListener
extension GMDMapInteractor: GMDMapPresentableListener {
	func viewDidLoad() {
		locaitonManagable.locationManager.startUpdatingLocation()
		clustering.run(data: stubData)
	}
	
	func didTapMarker(group: [GMDMapViewModel]) {
		print("tap")
	}
}

// MARK: - ClusteringDelegate
extension GMDMapInteractor: ClusteringDelegate {
	typealias DataType = GMDMapViewModel
	
	func didFinishClustering(with results: [ClusterResult<GMDMapViewModel>]) {
		let markers = results.map { result in
			return CentroidMarker(
				centroid: CGPoint(x: result.centroid.longitude, y: result.centroid.latitude),
				group: result.group
			)
		}
		debugPrint(markers)
		presenter.drawMarkers(markers)
	}
}
