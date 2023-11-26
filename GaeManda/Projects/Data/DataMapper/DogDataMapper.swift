//
//  DogDataMapper.swift
//  DataMapper
//
//  Created by 김영균 on 9/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import Entity

public protocol DogDataMapper {
	func mapToDog(from dto: FetchDogsResponseDTO) -> Dog
	func mapToDogCharacter(from dto: [DogCharacterResponseDTO]) -> [DogCharacter]
	func mapToUpdateDogRequestDTO(from entity: Dog, isProfileImageChaged: Bool) -> UpdateDogRequestDTO
	func mapToCreateDogRequestDTO(from entity: Dog) -> CreateDogRequestDTO
}

public struct DogDataMapperImpl: DogDataMapper {
	public init() {}
	
	public func mapToDog(from dto: FetchDogsResponseDTO) -> Dog {
		return Dog(
			id: dto.petId,
			name: dto.name,
			profileImage: dto.profileImage.data(using: .utf8),
			species: DogSpecies(rawValue: dto.species) ?? .ETC,
			gender: Gender(rawValue: dto.gender) ?? .male,
			birthday: dto.birthday,
			weight: dto.weight,
			isNeutered: dto.isNeutered,
			characterIds: dto.personalites
		)
	}
	
	public func mapToDogCharacter(from dto: [DogCharacterResponseDTO]) -> [DogCharacter] {
		return dto.map { DogCharacter(id: $0.id, character: $0.character) }
	}
	
	public func mapToUpdateDogRequestDTO(from entity: Dog, isProfileImageChaged: Bool) -> UpdateDogRequestDTO {
		return UpdateDogRequestDTO(
			petId: entity.id,
			name: entity.name,
			birthday: entity.birthday,
			species: entity.species.rawValue,
			gender: entity.gender.rawValue,
			weight: entity.weight,
			isNeutered: entity.isNeutered,
			personalites: entity.characterIds,
			profileImage: convertToString(from: entity.profileImage),
			isFileChange: isProfileImageChaged
		)
	}
	
	public func mapToCreateDogRequestDTO(from entity: Dog) -> CreateDogRequestDTO {
		return CreateDogRequestDTO(
			name: entity.name,
			birthday: entity.birthday,
			species: entity.species.rawValue,
			gender: entity.gender.rawValue,
			weight: entity.weight,
			isNeutered: entity.isNeutered,
			personalites: entity.characterIds,
			profileImage: convertToString(from: entity.profileImage)
		)
	}
}

// MARK: - Private Methods
private extension DogDataMapperImpl {
	func convertToString(from data: Data?) -> String {
		guard let data = data else { return "" }
		
		return String(decoding: data, as: UTF8.self)
	}
}
