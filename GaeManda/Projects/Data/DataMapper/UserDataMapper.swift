//
//  UserDataMapper.swift
//  DataMapper
//
//  Created by 김영균 on 9/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import Entity

public protocol UserDataMapper {
	func mapToUser(from dto: FetchUserResponseDTO) -> User
	func mapToUpdateUserRequestDTO(from entity: User, isProfileImageChanged: Bool)
	-> UpdateUserRequestDTO
	func mapToCreateUserRequestDTO(from entity: User) -> CreateUserRequestDTO
}

public struct UserProfileDataMapperImpl: UserDataMapper {
	public init() {}
	
	public func mapToUser(from dto: FetchUserResponseDTO) -> User {
		return User(
			id: dto.memberId,
			name: dto.nickname,
			gender: Gender(rawValue: dto.gender) ?? .male,
			address: Location(latitude: dto.latitude, longitude: dto.longitude),
			birthday: dto.birthday,
			profileImage: dto.profileImageURL
		)
	}
	
	public func mapToUpdateUserRequestDTO(from entity: User, isProfileImageChanged: Bool) -> UpdateUserRequestDTO {
		return UpdateUserRequestDTO(
			nickname: entity.name,
			profileImage: entity.profileImage.data(using: .utf8) ?? Data(),
			gender: entity.gender.rawValue,
			birthday: entity.birthday,
			latitude: entity.address.latitude,
			longitude: entity.address.longitude,
			isFileChage: isProfileImageChanged
		)
	}
	
	public func mapToCreateUserRequestDTO(from entity: User) -> CreateUserRequestDTO {
		return CreateUserRequestDTO(
			nickname: entity.name,
			profileImage: entity.profileImage.data(using: .utf8) ?? Data(),
			gender: entity.gender.rawValue,
			birthday: entity.birthday,
			latitude: entity.address.latitude,
			longitude: entity.address.longitude
		)
	}
}
