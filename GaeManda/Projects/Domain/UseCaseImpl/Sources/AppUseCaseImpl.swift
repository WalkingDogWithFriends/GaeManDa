//
//  AppUseCaseImpl.swift
//  UseCase
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Repository
import UseCase

public struct AppUseCaseImpl: AppUseCase {
	// MARK: - Properties
	private let appRepository: AppRepository
	
	// MARK: - Initializers
	public init(appRepository: AppRepository) {
		self.appRepository = appRepository
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
}
