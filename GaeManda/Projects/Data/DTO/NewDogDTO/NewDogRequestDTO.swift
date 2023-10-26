//
//  NewDogRequestDTO.swift
//  DTO
//
//  Created by jung on 2023/09/10.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct NewDogRequestDTO: Encodable {
	public let name: String
	public let sex: String
	public let age: String
	public let weight: String
	public let neatured: Bool
	public let character: String
	
	public init(
		name: String,
		sex: String,
		age: String,
		weight: String,
		neatured: Bool,
		character: String
	) {
		self.name = name
		self.sex = sex
		self.age = age
		self.weight = weight
		self.neatured = neatured
		self.character = character
	}
}
