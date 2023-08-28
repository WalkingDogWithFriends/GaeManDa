//
//  DogResponseDTO.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import Entity

public struct DogResponseDTO: Decodable {
	public let id: Int
	public let name: String
	public let sex: String
	public let age: String
	public let weight: String
	public let didNeutered: Bool
	public let character: String

	public var toDomain: Dog {
		Dog(
			id: id,
			name: name,
			sex: Sex(rawValue: sex) ?? .male,
			age: age,
			weight: weight,
			didNeutered: didNeutered,
			character: character
		)
	}
}

#if DEBUG
extension DogResponseDTO {
	public static let stubData =
	"""
	[
		{
			"id": 1,
			"name": "자몽",
			"sex": "여",
			"age": "7",
			"weight": "30",
			"didNeutered": false,
			"character": "저희 강아지는 잘 물어요"
		},
		{
			"id": 2,
			"name": "얌이",
			"sex": "남",
			"age": "2",
			"weight": "12",
			"didNeutered": true,
			"character": "저희 강아지는 온순해요"
		},
		{
			"id": 3,
			"name": "루비",
			"sex": "여",
			"age": "5",
			"weight": "22",
			"didNeutered": false,
			"character": "저희 강아지는 활발해요"
		}
	]
	"""
}
#endif
