//
//  Dog.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum Sex: String {
	case male = "남"
	case female = "여"
}

public enum Neutered {
	case `true`
	case `false`
}

public struct Dog {
	public let id: Int
	public let name: String
	public let sex: Sex
	public let age: String
	public let weight: String
	public let didNeutered: Bool
	public let character: String
	
	public init(
		id: Int,
		name: String,
		sex: Sex,
		age: String,
		weight: String,
		didNeutered: Bool,
		character: String
	) {
		self.id = id
		self.name = name
		self.sex = sex
		self.age = age
		self.weight = weight
		self.didNeutered = didNeutered
		self.character = character
	}
}
