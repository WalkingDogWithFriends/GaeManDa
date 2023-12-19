//
//  AppDataMapper.swift
//  DataMapper
//
//  Created by 김영균 on 12/18/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import DTO
import Entity

public protocol AppDataMapper {
	func mapToRegisterDeviceTokenRequestDTO(from deviceToken: String) -> RegisterDeviceTokenRequestDTO
}

public struct AppDataMapperImpl: AppDataMapper {
	public init() {}
	
	public func mapToRegisterDeviceTokenRequestDTO(from deviceToken: String) -> RegisterDeviceTokenRequestDTO {
		return RegisterDeviceTokenRequestDTO(deviceToken: deviceToken)
	}
}
