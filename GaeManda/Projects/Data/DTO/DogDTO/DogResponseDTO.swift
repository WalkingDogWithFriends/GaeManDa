//
//  DogResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation

public struct DogResponseDTO: Decodable {
	public let petId: Int
	public let name: String
	public let age: String
	public let birthday: String
	public let species: String
	public let weight: String
	public let isNeutered: Bool
	public let personality: String
	public let profileImage: String
	
	public init(
		petId: Int,
		name: String,
		age: String,
		birthday: String,
		species: String,
		weight: String,
		isNeutered: Bool,
		personality: String,
		profileImage: String
	) {
		self.petId = petId
		self.name = name
		self.age = age
		self.birthday = birthday
		self.species = species
		self.weight = weight
		self.isNeutered = isNeutered
		self.personality = personality
		self.profileImage = profileImage
	}
}

#if DEBUG
extension DogResponseDTO {
	public static let stubData =
 """
 [
 {
 "petId": 1,
 "name": "얌이",
 "age": "12",
 "birthday": "20180303",
 "species": "시츄",
 "weight": "5",
 "isNeutered": true,
 "personality": "착함",
 "profileImage": ""
 },
 {
 "petId": 2,
 "name": "얌이",
 "age": "14",
 "birthday": "20190303",
 "species": "진돗개",
 "weight": "3",
 "isNeutered": false,
 "personality": "저희 강아지는 온순해요",
 "profileImage": ""
 },
 {
 "petId": 3,
 "name": "루비",
 "age": "5",
 "birthday": "20210303",
 "species": "말티즈",
 "weight": "22",
 "isNeutered": false,
 "personality": "저희 강아지는 활발해요",
 "profileImage": ""
 }
 ]
 """
}
#endif
