//
//  UserAPI.swift
//  DTO
//
//  Created by jung on 2023/07/20.
//  Copyright © 2023 com.gaemanda. All rights reserved.
//

import Foundation
import GMDNetwork
import DTO

enum UserAPI {
	case fetchUser(id: Int)
}

extension UserAPI: TargetType {
	public var baseURL: URL {
		return URL(string: "")!
	}
	
	public var path: String {
		switch self {
		case .fetchUser:
			return "user"
		}
	}
	
	public var method: HTTPMethod {
		switch self {
		case .fetchUser:
			return .get
		}
	}
	
	public var task: TaskType {
		switch self {
		case let .fetchUser(id):
			let requestDTO = UserRequestDTO(id: id)
			return .requestParameters(parameters: requestDTO.toDictionary, encoding: .queryString)
		}
	}
	
	public var headers: HTTPHeaders {
		return .default
	}
	
	public var sampleData: Data {
		switch self {
		case .fetchUser:
			do {
				let data = UserResponseDTO.stubData
				let json = try JSONSerialization.data(withJSONObject: [data], options: .prettyPrinted)
				return json
			} catch {
				return Data()
			}
		}
	}
}
