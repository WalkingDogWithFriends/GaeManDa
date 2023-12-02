//
//  UserProfileSettingPassingModel.swift
//  OnBoarding
//
//  Created by jung on 12/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Entity
import GMDUtils

public struct UserProfileSettingPassingModel {
	public let nickname: String
	public let birthday: String
	public let gender: Gender
	public let profileImage: UIImageWrapper
	
	public init(
		nickname: String,
		birthday: String,
		gender: Gender,
		profileImage: UIImageWrapper
	) {
		self.nickname = nickname
		self.birthday = birthday
		self.gender = gender
		self.profileImage = profileImage
	}
}
