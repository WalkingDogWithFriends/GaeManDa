//
//  DogSpeciesResponseDTO.swift
//  LocalStorage
//
//  Created by jung on 11/26/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

public struct DogSpeciesResponseDTO: Decodable {
	public let species: String
	
	public init(species: String) {
		self.species = species
	}
}
