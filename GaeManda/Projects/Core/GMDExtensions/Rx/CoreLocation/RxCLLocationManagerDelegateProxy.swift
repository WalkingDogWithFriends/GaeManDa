//
//  RxCLLocationManagerDelegateProxy.swift
//  GMDExtensions
//
//  Created by 김영균 on 10/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift

public typealias RxCLLocationManagerDelegate = DelegateProxy<CLLocationManager, CLLocationManagerDelegate>

final class RxCLLocationManagerDelegateProxy: 
	RxCLLocationManagerDelegate,
	DelegateProxyType,
	CLLocationManagerDelegate {
	static func registerKnownImplementations() {
		self.register { locationManager -> RxCLLocationManagerDelegateProxy in
			RxCLLocationManagerDelegateProxy(parentObject: locationManager, delegateProxy: self)
		}
	}
	
	static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
		return object.delegate
	}
	
	static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
		object.delegate = delegate
	}
}
