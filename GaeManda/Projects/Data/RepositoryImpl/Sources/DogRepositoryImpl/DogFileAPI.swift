//
//  DogFileAPI.swift
//  DTO
//
//  Created by jung on 11/16/23.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import LocalStorage

public enum DogFileAPI {
	case fetchCharacters
	case fetchSpecies
}

extension DogFileAPI: TargetType {
	public var filename: String {
		switch self {
			case .fetchCharacters:
				return "DogCharacters"
			case .fetchSpecies:
				return "DogSpecies"
		}
	}
	
	public var task: TaskType {
		switch self {
			case .fetchCharacters, .fetchSpecies:
				return .read
		}
	}
	
	public var fileType: FileType {
		switch self {
			case .fetchCharacters, .fetchSpecies:
				return .json
		}
	}
}
