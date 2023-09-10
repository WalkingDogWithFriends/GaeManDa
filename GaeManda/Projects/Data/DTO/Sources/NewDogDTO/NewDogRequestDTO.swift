//
//  NewDogRequestDTO.swift
//  DTO
//
//  Created by jung on 2023/09/10.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

public struct NewDogRequestDTO: Encodable {
	public let name: String
	public let sex: String
	public let age: String
	public let weight: String
	public let neatured: Bool
	public let character: String
}

public extension NewDogRequestDTO {
	init(dog: Dog) {
		self.name = dog.name
		self.sex = dog.sex.rawValue
		self.age = dog.age
		self.weight = dog.weight
		self.neatured = dog.didNeutered == .true ? true : false
		self.character = dog.character
	}
}
