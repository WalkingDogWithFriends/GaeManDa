//
//  DogDataMapper.swift
//  DataMapper
//
//  Created by 김영균 on 9/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import DTO
import Entity

public protocol DogDataMapper {
	func mapToDog(from dto: DogResponseDTO) -> Dog
}

public struct DogDataMapperImpl: DogDataMapper {
	public init() {}
	
	public func mapToDog(from dto: DogResponseDTO) -> Dog {
		return Dog(
			id: dto.petId,
			name: dto.name,
			sex: .male, // 바꿔야함
			age: dto.age,
			weight: dto.weight,
			didNeutered: dto.isNeutered ? .true : .false,
			character: dto.personality
		)
	}
}
