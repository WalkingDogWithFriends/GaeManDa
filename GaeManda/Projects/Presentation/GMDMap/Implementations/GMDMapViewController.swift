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
import GMDExtensions

protocol GMDMapPresentableListener: AnyObject { }

final class GMDMapViewController:
	UIViewController,
	GMDMapPresentable,
	GMDMapViewControllable {
	private enum Constant {
		static let defaultCameraPosition = NMFCameraPosition( NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14)
		static let defaultCameraZoomLevel = 18.0
		static let defaultCameraAnimation = NMFCameraUpdateAnimation.easeIn
		static let defaultCameraAnimationDuration = 0.3
	}
	
	weak var listener: GMDMapPresentableListener?
	
	private lazy var mapView: NMFMapView = {
		let mapView = NMFMapView(frame: view.bounds)
		mapView.moveCamera(NMFCameraUpdate(position: Constant.defaultCameraPosition))
		mapView.locationOverlay.hidden = false
		return mapView
	}()
	
	private let locationManager: CLLocationManager = {
		let locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		return locationManager
	}()
	
	private let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubviews(mapView)
		loadLocation()
		bindCLLocationManager()
	}
	
	deinit {
		locationManager.stopUpdatingLocation()
	}
	
	func loadLocation() {
		if locationManager.authorizationStatus == .authorizedAlways ||
				locationManager.authorizationStatus == .authorizedWhenInUse {
			locationManager.startUpdatingLocation()
		} else {
			/// 권한이 없다면 권한이 없다는 알림창을 보여주고, 권한 설정 페이지로 이동합니다.
			let alert = UIAlertController(title: "위치 권한이 없습니다.", message: "위치 권한을 허용해주세요.", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "확인", style: .default) { _ in
				guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
			let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
			alert.addAction(okAction)
			alert.addAction(cancelAction)
			present(alert, animated: true, completion: nil)
		}
	}
	
	func bindCLLocationManager() {
		locationManager.rx.didUpdateLocations
			.filter { !$0.locations.isEmpty }
			.bind(with: self) { owner, clLocationsEvent in
				let location = clLocationsEvent.locations.last!.latLng
				let cameraUpdatePosition = NMFCameraUpdate(
					scrollTo: location,
					zoomTo: Constant.defaultCameraZoomLevel,
					cameraAnimation: Constant.defaultCameraAnimation,
					duration: Constant.defaultCameraAnimationDuration
				)
				
				owner.mapView.moveCamera(cameraUpdatePosition)
				owner.mapView.locationOverlay.location = location
			}
			.disposed(by: disposeBag)
		
		locationManager.rx.didChangeAuthorization
			.filter { $0.status == .notDetermined }
			.bind { clLocationEvent in
				clLocationEvent.manager.requestWhenInUseAuthorization()
			}
			.disposed(by: disposeBag)
		
		locationManager.rx.didError
			.bind { clLocationEvent in
				print("error: \(clLocationEvent.error)")
			}
			.disposed(by: disposeBag)
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
