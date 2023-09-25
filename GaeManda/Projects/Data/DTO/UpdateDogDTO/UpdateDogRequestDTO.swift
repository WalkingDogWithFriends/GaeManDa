//
//  DogRequestDTO.swift
//  DTO
//
//  Created by jung on 2023/08/30.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

public struct UpdateDogRequestDTO: Encodable {
	public let id: Int
	public let name: String
	public let sex: String
	public let age: String
	public let weight: String
	public let didNeutered: Bool
	public let character: String
	
	public init(id: Int, name: String, sex: String, age: String, weight: String, didNeutered: Bool, character: String) {
		self.id = id
		self.name = name
		self.sex = sex
		self.age = age
		self.weight = weight
		self.didNeutered = didNeutered
		self.character = character
	}
	
	public init(dog: Dog) {
		self.id = dog.id
		self.name = dog.name
		self.sex = dog.sex.rawValue
		self.age = dog.age
		self.weight = dog.weight
		self.didNeutered = dog.didNeutered == .true ? true : false
		self.character = dog.character
	}
}
