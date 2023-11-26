//
//  CreateDogRequestDTO.swift
//  LocalStorage
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public struct CreateDogRequestDTO: Encodable {
	public let name: String
	public let birthday: String
	public let species: String
	public let gender: String
	public let weight: Int
	public let isNeutered: Bool
	public let personalites: [Int]
	public let profileImage: String
	
	public init(
		name: String,
		birthday: String,
		species: String,
		gender: String,
		weight: Int,
		isNeutered: Bool,
		personalites: [Int],
		profileImage: String
	) {
		self.name = name
		self.birthday = birthday
		self.species = species
		self.gender = gender
		self.weight = weight
		self.isNeutered = isNeutered
		self.personalites = personalites
		self.profileImage = profileImage
	}
}
