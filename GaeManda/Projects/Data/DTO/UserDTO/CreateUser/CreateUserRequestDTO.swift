//
//  CreateUserRequestDTO.swift
//  LocalStorage
//
//  Created by jung on 12/1/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct CreateUserRequestDTO: Encodable {
	public let nickname: String
	public let profileImage: Data
	public let gender: String
	public let birthday: String
	public let latitude: Double
	public let longitude: Double

	public init(
		nickname: String,
		profileImage: Data,
		gender: String,
		birthday: String,
		latitude: Double,
		longitude: Double
	) {
		self.nickname = nickname
		self.profileImage = profileImage
		self.gender = gender
		self.birthday = birthday
		self.latitude = latitude
		self.longitude = longitude
	}
}
