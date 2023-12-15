//
//  UserProfilePassingModel.swift
//  CorePresentation
//
//  Created by jung on 12/15/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Entity

public struct UserProfilePassingModel {
	public let name: String
	public let birthday: String // YYYY.MM.DD
	public let gender: Gender
	
	public init(name: String, birthday: String, gender: Gender) {
		self.name = name
		self.birthday = birthday
		self.gender = gender
	}
}
