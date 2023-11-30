//
//  UpdateDogRequestDTO.swift
//  LocalStorage
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct UpdateDogRequestDTO: Encodable {
	public let petId: Int
	public let name: String
	public let birthday: String
	public let species: String
	public let gender: String
	public let weight: Int
	public let isNeutered: Bool
	public let personalites: [Int]
	public let profileImage: Data
	/// 프로필 이미지의 변경이 있는지 없는지 여부.
	public let isFileChange: Bool
	
	public init(
		petId: Int,
		name: String,
		birthday: String,
		species: String,
		gender: String,
		weight: Int,
		isNeutered: Bool,
		personalites: [Int],
		profileImage: Data,
		isFileChange: Bool
	) {
		self.petId = petId
		self.name = name
		self.birthday = birthday
		self.species = species
		self.gender = gender
		self.weight = weight
		self.isNeutered = isNeutered
		self.personalites = personalites
		self.profileImage = profileImage
		self.isFileChange = isFileChange
	}
}
