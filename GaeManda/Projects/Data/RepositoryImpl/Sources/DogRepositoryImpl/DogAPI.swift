//
//  DogTaskType.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import DTO
import GMDNetwork

public enum DogAPI {
	case fetchDogs
	case updateDog(_ dto: UpdateDogRequestDTO)
	case createDog(_ dto: CreateDogRequestDTO)
}

extension DogAPI: TargetType {
	public var baseURL: URL {
		return URL(string: "http://117.17.198.45:8000/api/pet")!
	}
	
	public var path: String {
		switch self {
			case .fetchDogs, .updateDog, .createDog:
				return "profile"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
			case . fetchDogs:
				return .get
			case .updateDog:
				return .patch
			case .createDog:
				return .post
		}
	}
	
	public var task: TaskType {
		switch self {
			case .fetchDogs:
				return .requestPlain
				
			case let .updateDog(requestDTO):
				return .requestParameters(parameters: requestDTO.toDictionary, encoding: .jsonBody)
				
			case let .createDog(requestDTO):
				return .requestParameters(parameters: requestDTO.toDictionary, encoding: .jsonBody)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		switch self {
			case .fetchDogs:
				let jsonString = FetchDogsResponseDTO.stubData
				let data = jsonString.data(using: .utf8)
				
				return data ?? Data()
				
			case .updateDog, .createDog:
				return  Data()
		}
	}
}
