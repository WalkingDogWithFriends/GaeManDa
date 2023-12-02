//
//  DogResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public struct FetchDogsResponseDTO: Decodable {
	public let petId: Int
	public let name: String
	public let birthday: String
	public let species: String
	public let gender: String
	public let weight: Int
	public let isNeutered: Bool
	public let personalites: [Int]
	public let profileImageURL: String
	
	public enum CodingKeys: String, CodingKey {
		case petId
		case name
		case birthday
		case species
		case gender
		case weight
		case isNeutered
		case personalites
		case profileImageURL = "profileImage"
	}
	
	public init(
		petId: Int,
		name: String,
		birthday: String,
		species: String,
		gender: String,
		weight: Int,
		isNeutered: Bool,
		personalites: [Int],
		profileImageURL: String
	) {
		self.petId = petId
		self.name = name
		self.birthday = birthday
		self.species = species
		self.gender = gender
		self.weight = weight
		self.isNeutered = isNeutered
		self.personalites = personalites
		self.profileImageURL = profileImageURL
	}
}

#if DEBUG
extension FetchDogsResponseDTO {
	public static let stubData =
 """
 [
 {
 "petId": 1,
 "name": "얌이",
 "birthday": "20180303",
 "species": "시츄",
 "gender": "M",
 "weight": 5,
 "isNeutered": true,
 "personalities": [2],
 "profileImageURL": ""
 },
 {
 "petId": 2,
 "name": "얌이",
 "birthday": "20190303",
 "species": "진돗개",
 "gender": "F",
 "weight": 3,
 "isNeutered": false,
 "personalities": [1, 3, 4],
 "profileImageURL": ""
 },
 {
 "petId": 3,
 "name": "루비",
 "birthday": "20210303",
 "species": "말티즈",
 "gender": "M",
 "weight": 22,
 "isNeutered": false,
 "personalities": [1, 2, ,5],
 "profileImageURL": ""
 }
 ]
 """
}
#endif
