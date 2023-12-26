//
//  PermissionManager.swift
//  GMDUtils
//
//  Created by 김영균 on 12/20/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import CoreLocation
import FirebaseMessaging

public protocol PermissionManager {
	func requestNotificationPermission() async throws -> Bool
	func requestLocationPermission()
}

public struct PermissionManagerImpl {
	private let locationManager: CLLocationManager
	
	public init(locationManager: CLLocationManager) {
		self.locationManager = locationManager
	}
}

extension PermissionManagerImpl: PermissionManager {
	public func requestNotificationPermission() async throws -> Bool {
		let center = UNUserNotificationCenter.current()
		return try await center.requestAuthorization(options: [.alert, .sound, .badge])
	}
	
	public func requestLocationPermission() {
		let status = locationManager.authorizationStatus
		if status == .notDetermined || status == .denied || status == .restricted {
			locationManager.requestWhenInUseAuthorization()
		}
	}
}
