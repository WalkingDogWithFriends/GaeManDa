//
//  UserDataMapper.swift
//  DataMapper
//
//  Created by 김영균 on 9/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import DTO
import Entity

public protocol UserDataMapper {
	func mapToUser(from dto: UserProfileResponseDTO) -> User
}

public struct UserProfileDataMapperImpl: UserDataMapper {
	public init() {}
	
	public func mapToUser(from dto: UserProfileResponseDTO) -> User {
		return User(name: dto.nickname, sex: Gender(rawValue: dto.gender) ?? .male, age: "\(dto.age)")
	}
}
