//
//  GMDMapViewController.swift
//  GMDMapImpl
//
//  Created by jung on 2023/07/17.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import UIKit
import RIBs
import NMapsMap
import RxCocoa
import RxSwift

protocol GMDMapPresentableListener: AnyObject {
	func viewDidLoad()
	func didTapMarker(group: [GMDMapViewModel])
}

final class GMDMapViewController:
	UIViewController,
	GMDMapViewControllable {
	weak var listener: GMDMapPresentableListener?
	private let mapView = NMFMapView()
	
	// MARK: - View Life Cycles
	override func loadView() {
		self.view = mapView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setMapViewAttributes()
		
		listener?.viewDidLoad()
	}
}

// MARK: - View Methods
extension GMDMapViewController: GMDMapPresentable {
	private enum Constant {
		static let defaultCameraPosition = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14)
		static let defaultCameraZoomLevel = 18.0
		static let defaultCameraAnimation = NMFCameraUpdateAnimation.easeIn
		static let defaultCameraAnimationDuration = 0.3
		static let locationPermissionAlertTitle = "위치 권한이 없습니다."
		static let locationPermissionAlertMessage = "위치 권한을 허용해주세요."
	}
	
	func setMapViewAttributes() {
		mapView.moveCamera(NMFCameraUpdate(position: Constant.defaultCameraPosition))
		mapView.locationOverlay.hidden = false
		mapView.allowsScrolling = false
		mapView.allowsZooming = false
	}
	
	func openPermissionSettings() {
		let alert = UIAlertController(
			title: Constant.locationPermissionAlertTitle,
			message: Constant.locationPermissionAlertMessage,
			preferredStyle: .alert
		)
		let okAction = UIAlertAction(title: "확인", style: .default) { _ in
			guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
		let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
		alert.addAction(okAction)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
	
	func updateCameraPosition(lat: Double, lng: Double) {
		let location = NMGLatLng(lat: lat, lng: lng)
		let cameraUpdatePosition = NMFCameraUpdate(
			scrollTo: location,
			zoomTo: Constant.defaultCameraZoomLevel,
			cameraAnimation: Constant.defaultCameraAnimation,
			duration: Constant.defaultCameraAnimationDuration
		)
		mapView.moveCamera(cameraUpdatePosition)
		mapView.locationOverlay.location = location
	}
	
	func drawMarkers(_ markers: [CentroidMarker]) {
		markers.forEach { marker in
			view.addSubview(marker)
		}		
	}
	
	func bind(for marker: CentroidMarker) {
		marker.rx.tap
			.bind(with: self) { owner, _ in
				owner.listener?.didTapMarker(group: marker.group)
			}
	}
}

/// 부드럽게 지도 위치를 이동하기 위한 확장자
fileprivate extension NMFCameraUpdate {
	convenience init(
		scrollTo: NMGLatLng,
		zoomTo: Double,
		cameraAnimation: NMFCameraUpdateAnimation,
		duration: Double
	) {
		self.init(scrollTo: scrollTo, zoomTo: zoomTo)
		animation = cameraAnimation
		animationDuration = duration
	}
}

fileprivate extension CLLocation {
	var latLng: NMGLatLng {
		return NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
	}
}
