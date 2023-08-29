//
//  DogTaskType.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import Entity
import GMDNetwork

public enum DogAPI {
	case fetchDogs(id: Int)
	case updateDogs(dog: Dog)
}

extension DogAPI: TargetType {
	public var baseURL: URL { return URL(string: "")! }
	
	public var path: String {
		switch self {
		case .fetchDogs:
			return "fetchDog"
		case .updateDogs:
			return "updateDog"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
		case . fetchDogs:
			return .get
		case .updateDogs:
			return .put
		}
	}
	
	public var task: TaskType {
		switch self {
		case let .fetchDogs(id):
			let requestDTO = DogRequestDTO(id: id)
			return .requestParameters(parameters: requestDTO.toDictionary, encoding: .queryString)
			
		case let .updateDogs(dog):
			let requestDTO = UpdateDogRequestDTO(dog: dog)
			
			return .requestParameters(
				parameters: requestDTO.toDictionary,
				encoding: .jsonBody
			)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		switch self {
		case .fetchDogs:
			let jsonString = DogResponseDTO.stubData
			let data = jsonString.data(using: .utf8)
			
			return data ?? Data()
		
		case .updateDogs:
			let jsonString = UpdateDogResponseDTO.stubData
			let data = jsonString.data(using: .utf8)
			
			return data ?? Data()
		}
	}
}
