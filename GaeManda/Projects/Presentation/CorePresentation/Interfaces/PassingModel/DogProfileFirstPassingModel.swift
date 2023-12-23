//
//  DogProfileFirstPassingModel.swift
//  CorePresentation
//
//  Created by jung on 12/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Entity

public struct DogProfileFirstPassingModel {
	public let name: String
	public let birthday: String // YYYY.MM.DD
	public let gender: Gender
	public let weight: Int
	
	public init(
		name: String,
		birthday: String,
		gender: Gender,
		weight: Int
	) {
		self.name = name
		self.birthday = birthday
		self.gender = gender
		self.weight = weight
	}
}
