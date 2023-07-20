//
//  DogTaskType.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import GMDNetwork
import DTO

public enum DogAPI {
	case fetchDogs(id: Int)
}

extension DogAPI: TargetType {
	public var baseURL: URL { return URL(string: "")! }
	
	public var path: String {
		switch self {
		case .fetchDogs:
			return "fetchDog"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
		case . fetchDogs:
			return .get
		}
	}
	
	public var task: TaskType {
		switch self {
		case let .fetchDogs(id):
			let requestDTO = DogRequestDTO(id: id)
			return .requestParameters(parameters: requestDTO.toDictionary, encoding: .queryString)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		switch self {
		case .fetchDogs:
			do {
				let data = DogResponseDTO.stubData
				let json = try JSONSerialization.data(withJSONObject: [data], options: .prettyPrinted)
				return json
			} catch {
				return Data()
			}
		}
	}
}
