//
//  AppUseCase.swift
//  UseCase
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public protocol AppUseCase {
	@discardableResult
	func registerDeviceToken(_ deviceToken: String) async -> Bool
	func startUnpdateLocation()
	func stopUpdatingLocation()
}
