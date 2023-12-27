//
//  AppRepository.swift
//  UseCase
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public protocol AppRepository {
	func registerDeviceToken(_ deviceToken: String) async throws
}
