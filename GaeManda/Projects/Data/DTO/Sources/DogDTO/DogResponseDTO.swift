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
	public let name: String
	public let sex: String
	public let age: String
	public let weight: String
	public let didNeutered: Bool
	
	public var toDomain: Dog {
		Dog(
			name: name,
			sex: sex,
			age: age,
			weight: weight,
			didNeutered: didNeutered
		)
	}
}

#if DEBUG
extension DogResponseDTO {
	public static let stubData =
	"""
	[
		{
			"name": "자몽",
			"sex": "여",
			"age": "7",
			"weight": "30",
			"didNeutered": false
		},
		{
			"name": "얌이",
			"sex": "남",
			"age": "2",
			"weight": "12",
			"didNeutered": true
		},
		{
			"name": "루비",
			"sex": "여",
			"age": "5",
			"weight": "22",
			"didNeutered": false
		}
	]
	"""
}
#endif
