//
//  CLLocation+Reactive.swift
//  GMDExtensions
//
//  Created by 김영균 on 10/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

public extension Selector {
	static let didChangeAuthorization = #selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization)
	static let didUpdateLocations = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
	static let didFailWithError = #selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:))
	static let didFinishDeferredUpdatesWithError = #selector(
		CLLocationManagerDelegate.locationManager(_:didFinishDeferredUpdatesWithError:)
	)
}

public extension Reactive where Base: CLLocationManager {
	var delegate: RxCLLocationManagerDelegate {
		return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
	}
	
	var didChangeAuthorization: ControlEvent<CLAuthorizationEvent> {
		let source: Observable<CLAuthorizationEvent> = delegate
			.methodInvoked(.didChangeAuthorization)
			.map(clAuthorizationStatus)
		return ControlEvent(events: source)
	}
	
	var didUpdateLocations: ControlEvent<CLLocationsEvent> {
		let source: Observable<CLLocationsEvent> = delegate
			.methodInvoked(.didUpdateLocations)
			.map(clLocationsEvent)
		return ControlEvent(events: source)
	}
	
	var didError: ControlEvent<CLErrorEvent> {
		let generalError: Observable<CLErrorEvent> = delegate
			.methodInvoked(.didFailWithError)
			.map(clErrorEvent)
		let updatesError: Observable<CLErrorEvent> = delegate
			.methodInvoked(.didFinishDeferredUpdatesWithError)
			.map(clErrorEvent)
		let source = Observable.of(generalError, updatesError).merge()
		return ControlEvent(events: source)
	}
}
