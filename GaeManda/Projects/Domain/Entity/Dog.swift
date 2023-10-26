//
//  Dog.swift
//  Entity
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public enum Sex: String, Codable {
	case male = "남"
	case female = "여"
}

public enum Neutered: Codable {
	case `true`
	case `false`
}

public struct Dog: Codable {
	public let id: Int
	public let name: String
	public let sex: Sex
	public let age: String
	public let weight: String
	public let didNeutered: Neutered
	public let character: String
	public let image: Data?
	
	public init(
		id: Int,
		name: String,
		sex: Sex,
		age: String,
		weight: String,
		didNeutered: Neutered,
		character: String
	) {
		self.id = id
		self.name = name
		self.sex = sex
		self.age = age
		self.weight = weight
		self.didNeutered = didNeutered
		self.character = character
		self.image = nil
	}
	
	public init(
		id: Int,
		name: String,
		sex: Sex,
		age: String,
		weight: String,
		didNeutered: Neutered,
		character: String,
		image: Data?
	) {
		self.id = id
		self.name = name
		self.sex = sex
		self.age = age
		self.weight = weight
		self.didNeutered = didNeutered
		self.character = character
		self.image = image
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.id, forKey: .id)
		try container.encode(self.name, forKey: .name)
		try container.encode(self.sex, forKey: .sex)
		try container.encode(self.age, forKey: .age)
		try container.encode(self.weight, forKey: .weight)
		try container.encode(self.didNeutered, forKey: .didNeutered)
		try container.encode(self.character, forKey: .character)
		try container.encodeIfPresent(self.image, forKey: .image)
	}
}
