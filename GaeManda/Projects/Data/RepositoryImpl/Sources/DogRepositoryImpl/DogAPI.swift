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
	case postNewDog(dog: Dog)
}

extension DogAPI: TargetType {
	public var baseURL: URL { return URL(string: "")! }
	
	public var path: String {
		switch self {
			case .fetchDogs:
				return "fetchDog"
			case .updateDogs:
				return "updateDog"
			case .postNewDog:
				return "postNewDog"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
			case . fetchDogs:
				return .get
			case .updateDogs:
				return .put
			case .postNewDog:
				return .post
		}
	}
	
	public var task: TaskType {
		switch self {
			case .fetchDogs:
				return .requestPlain
				
			case .updateDogs:
				// TODO: requestDTO 만들기
				return .requestPlain
				
			case .postNewDog:
				// TODO: requestDTO 만들기
				return .requestPlain
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
				
			case .updateDogs, .postNewDog:
				return  Data()
		}
	}
}
