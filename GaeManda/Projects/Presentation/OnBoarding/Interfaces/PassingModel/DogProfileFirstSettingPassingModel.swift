//
//  DogProfileFirstSettingPassingModel.swift
//  OnBoarding
//
//  Created by jung on 12/2/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Entity
import GMDUtils

public struct DogProfileFirstSettingPassingModel {
	public let name: String
	public let birthday: String
	public let gender: Gender
	public let weight: Int
	public let profileImage: UIImageWrapper
	
	public init(
		name: String,
		birthday: String,
		gender: Gender,
		weight: Int,
		profileImage: UIImageWrapper
	) {
		self.name = name
		self.birthday = birthday
		self.gender = gender
		self.weight = weight
		self.profileImage = profileImage
	}
}
