//
//  AppUseCaseImpl.swift
//  UseCase
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import GMDUtils
import Repository
import UseCase

public struct AppUseCaseImpl: AppUseCase {
	// MARK: - Properties
	private let appRepository: AppRepository
	private let locationManagable: CLLocationManagable
	
	// MARK: - Initializers
	public init(appRepository: AppRepository, locationManagable: CLLocationManagable) {
		self.appRepository = appRepository
		self.locationManagable = locationManagable
	}
}

extension AppUseCaseImpl {
	public func registerDeviceToken(_ deviceToken: String) async -> Bool {
		do {
			try await appRepository.registerDeviceToken(deviceToken)
			return true
		} catch {
			return false
		}
	}
	
	public func startUnpdateLocation() {
		guard !locationManagable.isUpdatingLocation else { return }
		locationManagable.locationManager.startUpdatingLocation()
	}
	
	public func stopUpdatingLocation() {
		locationManagable.locationManager.stopUpdatingLocation()
	}
}
