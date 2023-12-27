//
//  CLLocationManagable.swift
//  GaeManda
//
//  Created by 김영균 on 12/21/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CoreLocation
import Foundation

public protocol CLLocationManagable {
	var isUpdatingLocation: Bool { get }
	var locationManager: CLLocationManager { get }
}

public final class CLLocationManagerProxy: CLLocationManager, CLLocationManagable {
	public var isUpdatingLocation: Bool
	public var locationManager: CLLocationManager { return self }
	
	public override init() {
		self.isUpdatingLocation = false
		super.init()
		desiredAccuracy = kCLLocationAccuracyBest
		showsBackgroundLocationIndicator = true
	}
	
	override public func startUpdatingLocation() {
		self.isUpdatingLocation = true
		super.startUpdatingLocation()
	}
	
	override public func stopUpdatingLocation() {
		self.isUpdatingLocation = false
		super.stopUpdatingLocation()
	}
}
